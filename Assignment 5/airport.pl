:- discontiguous(isParked/3).
:- discontiguous(atSegment/3).
:- discontiguous(blocked/3).
:- discontiguous(facing/3).
:- discontiguous(isMoving/2).
:- discontiguous(hasType/2).

%% The following loads the file initAirport.pl with the initial and goal states
%% You can vary goal states as explained in Part 2, but do not include it inline.
:- [ initAirport ].  

solve_problem(N,L) :- C0 is cputime,
                      max_length(L,N),
                      reachable(S,L), goal_state(S),
                      Cf is cputime, D is Cf - C0, nl,
                      write('Elapsed time (sec): '), write(D), nl.

max_length([],N) :- N >= 0.
max_length([_|L],N1) :- N1 > 0, N is N1 -1, max_length(L,N).

reachable(S,[]) :- initial_state(S).
/* This rule is for the regular part of the assignment */
reachable(S2, [M|List]) :- reachable(S1,List), 
                    legal_move(S2,M,S1).   

/* The following rule is for the bonus question only: remove comments
   and write your own rules to implement the predicate useless(M,List). 
*/
% reachable(S2, [M | ListOfActions]) :- reachable(S1,ListOfActions),
%                    legal_move(S2,M,S1),
%                    not useless(M,ListOfActions).

legal_move([A|S], A, S) :- poss(A,S).
initial_state([]).


    /* --------------- Precondition Axioms ----------------- */

% Write your rules here: for each action you have to write 1 rule
% characterizing when action is possible in the current situation S.


poss(move(Airplane, Type, Dir1, Seg1, Seg2, Dir2), S) :- 
hasType(Airplane, Type), atSegment(Airplane, Seg1, S), facing(Airplane,Dir1,S),
canMove(Seg1, Seg2, Dir1), moveDir(Seg1,Seg2,Dir2), not Seg1 = Seg2, not opposite(Seg1,Seg2), not Dir1 = Dir2, 
not blocked(Seg2, Airplane2, S), 
not (segIsBlocked(Seg, Airplane, Seg2, Dir2), atSegment(Airplane2, Seg, S)).


poss(pushback(Airplane, Type, Dir1, Seg1, Seg2, Dir2), S) :- 
hasType(Airplane,Type), atSegment(Airplane,Seg1,S), facing(Airplane,Dir1,S),
canPushback(Seg1, Seg2, Dir1), moveBackDir(Seg1,Seg2,Dir2), not Seg1 = Seg2, not Dir1 = Dir2, 
isParked(Airplane, Seg1, S),
not (blocked(Seg2, Airplane2, S), not Airplane2 = Airplane).


poss(startup(Airplane), S) :- 
isPushing(Airplane, S), not isMoving(Airplane, S), 
not (segIsBlocked(Seg, Airplane, Seg2, Dir2), atSegment(Airplane2, Seg, S), not Airplane2 = Airplane).


poss(park(Airplane, Type, Seg, Dir), S) :- hasType(Airplane, Type), isMoving(Airplane, S), atSegment(Airplane, Seg,S), facing(Airplane, Dir, S), not isStartRunway(Seg, Dir).


poss(takeoff(Airplane, Seg, Dir), S) :- isStartRunway(Seg,Dir), atSegment(Airplane, Seg, S), facing(Airplane, Dir, S), isMoving(Airplane, S).


/*--------------- Sucessor State Axioms --------------------*/

% You are given rules for the fluent blocked(Seg,Airplane,S), but you
% have to write yourself rules for all other fluents.


blocked(Seg2,Airplane, [move(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]).
 
blocked(Seg,Airplane, [move(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]) :-
	opposite(Seg,Seg2).

blocked(Segment,Airplane,[move(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]) :-
	segIsBlocked(Segment,Type,Seg2,Dir2).

blocked(Seg2,Airplane, [pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2)|S]).

blocked(Seg1,Airplane, [pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2)|S]) :-
	opposite(Seg1,Seg2), different(Dir1,Dir2). 

% When Airplane is being pushed away from a gateway, its engines are off,
% and for this reason it does not block any segments it is not at. 
% But when an Airplane starts up its engines, it starts blocking a few segments.

blocked(Segment,Airplane, [startup(Airplane)|S]) :-
	hasType(Airplane, Type),
	facing(Airplane,Dir1,S),
	atSegment(Airplane,Seg1,S),
	segIsBlocked(Segment,Type,Seg1,Dir1).
       
/* If Seg1 is blocked in situation S, it remains blocked in the next 
   situation [A|S] if it is not true that the most recent action A was 
   moving from Seg1 to Seg2 and Seg1 is not blocked from Seg2,        
   and
   it is not true that the most recent action was moving from some Seg,Dir
   to Seg2,Dir2 and Seg1 was blocked from Seg, but is not blocked from Seg2, 
   and
   the last action is not pushback from Seg1 to a distinct segment Seg2,         
   and
   the last action is not takeoff from Seg1 or from another segment,  
   and
   Airplane did not park at a segment such that Seg1 is blocked from it:
   after parking Seg1 ceases to become blocked because engines turn off.
   Otherwise, if one of the above conditions fails, then Seg1 is no longer 
   blocked in the next state. 
*/        
blocked(Seg1,Airplane, [A | S]) :-
	not (A=move(Airplane,Type,Dir1,Seg1,Seg2,Dir2),
		not segIsBlocked(Seg1,Type,Seg2,Dir2) ), 

	not ( A=move(Airplane,Type,SomeDir,SomeSeg,Seg2,Dir2),
		segIsBlocked(Seg1,Type,SomeSeg,SomeDir), 
		not Seg1=Seg2,
		not segIsBlocked(Seg1,Type,Seg2, Dir2) ),

	not ( A=pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2),
		not opposite(Seg1,Seg2) ),

/* Seg1 that is blocked by Airplane in the current situation S remains 
blocked by this Airplane in the next situation [A|S] unless the last action A
is such that the airplane took off from this or another segment.	*/
	not A=takeoff(Airplane,Segment,Dir),

%% Airplane did not park at some Segment that blocks Seg1 %%
	not ( A=park(Airplane,Type,SomeSeg,Dir),	
	      segIsBlocked(Seg1,Type,SomeSeg,Dir),
		not SomeSeg = Seg1 ),

	blocked(Seg1,Airplane,S).


% Write all other successor state axioms here.


isParked(Airplane, Seg, [park(Airplane, Type, Seg, Dir) | S]).
isParked(Airplane, Seg, [A|S] ) :- not (A = pushback(Airplane, Type, Dir1, Seg, Seg2, Dir2)), isParked(Airplane, Seg, S). 


airborne(Airplane, Seg, [takeoff(Airplane, Seg, Dir) | S]).  
airborne(Airplane, Seg, [A|S]) :- airborne(Airplane, Seg, S). 


isMoving(Airplane, [startup(Airplane) | S]).
isMoving(Airplane, [A|S]) :- not A = park(Airplane, Type, Seg, Dir), not A = takeoff(Airplane, Seg, Dir), isMoving(Airplane, S).


isPushing(Airplane, [pushback(Airplane, Type, Dir1, Seg1, Seg2, Dir2) | S]).
isPushing(Airplane, [A|S]) :- not A = startup(Airplane), isPushing(Airplane, S). 


atSegment(Airplane, Seg2, [move(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]).
atSegment(Airplane, Seg2, [pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]) :- atSegment(Airplane, Seg1, S).
atSegment(Airplane, Seg1, [A|S]) :- 
not A = move(Airplane,Type,Dir1,Seg1,Seg2,Dir2), 
not A = pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2), atSegment(Airplane, Seg1, S). 
atSegment(Airplane, Seg, [move(Airplane2, Type, Dir1, Seg1, Dir2) | S]) :- not Airplane = Airplane2, atSegment(Airplane, Seg, S). 
atSegment(Airplane, Seg, [pushback(Airplane2, Type, Dir1, Seg1, Dir2) | S]) :- not Airplane = Airplane2, atSegment(Airplane, Seg, S). 


facing(Airplane, Dir2, [move(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]).
facing(Airplane, Dir2, [pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2) | S]) :- facing(Airplane, Dir1, S).
facing(Airplane, Dir1, [A|S]) :- 
not A = move(Airplane,Type,Dir1,Seg1,Seg2,Dir2), 
not A = pushback(Airplane,Type,Dir1,Seg1,Seg2,Dir2), facing(Airplane, Dir1, S). 
facing(Airplane, Dir, [move(Airplane2, Type, Dir1, Seg1, Dir2) | S]) :- not Airplane = Airplane2, atSegment(Airplane, Dir, S). 
facing(Airplane, Dir, [pushback(Airplane2, Type, Dir1, Seg1, Dir2) | S]) :- not Airplane = Airplane2, atSegment(Airplane, Dir, S). 



/*-------------- Generic Domain Properties ------------*/

segIsBlocked(seg(V1,V2), Type, seg(V1,V2), V2).
segIsBlocked(seg(V1,V2), Type, seg(V2,V1), V1).

segIsBlocked(Seg1, Type, Seg2, Dir2) :-
	(Type = medium ; Type = heavy),
	canMove(Seg1,Seg2,Dir1),
	moveDir(Seg1,Seg2,Dir2).

canMove(seg(V1,V2), seg(V2,V3), V2) :- 
	adjacent(V1,V2), adjacent(V2,V3).	

moveDir(seg(V1,V2), seg(V2,V3), V3) :-
	adjacent(V1,V2), adjacent(V2,V3).	

canPushback(seg(V2,V3),seg(V1,V2),V3) :- 
	adjacent(V1,V2), adjacent(V2,V3).	

moveBackDir(seg(V2,V3),seg(V1,V2),V2) :-
	adjacent(V1,V2), adjacent(V2,V3).	

%% clockwise direction and counter-clockwise direction are different %%
different(V1,V2) :- not V1=V2.

/* An airplane can be pushed from gateway by turning it around its axis. 
  In this case, it is re-oriented from a segment between vertices (V1,V2) with 
  heading towards V2 to the same segment, but with the vertex V1 at front.  */
opposite(seg(V1,V2),seg(V2,V1)).

