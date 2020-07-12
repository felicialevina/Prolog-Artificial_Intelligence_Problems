points(-1).

points(0).

points(1).

points(2).



solve([O1,P1,R1,S1,T1,O2,P2,R2,S2,T2,O3,P3,R3,S3,T3,O4,P4,R4,S4,T4,O5,P5,R5,S5,T5]):-



/*6th Constraint is implemented in between other constraints (no draw in round 1, 2 and 3), after each values are generated*/



/*1st constraint*/ points(P1), not P1 = 1, P1 = 0, points(S1), not S1 = 1, S1 = 2, points(P2), not P2 = 1, P2 = 2, points(O2), not O2 = 1, O2 = 0, 



/*3rd constraint (implemented first because O2 was generated from the previous constraint and we want to test that result in this constraint)*/ 

points(O4), O4 = -1, points(O1), not O1 = 1, points(O3), not O3 = 1, wonTwice(O1, O2, O3), 



/*2nd constraint*/ points(T3), T3 = -1, points(T1), not T1 = 1, points(T2), not T2 = 1, winLose(T1, T2), 



/*5th constraint (implemented here to generate values for round 1, 2 and 3 and test the constraints on them)*/ 

points(R1), not R1 = 1, points(R2), not R2 = 1, points(R3), not R3 = 1, winLose(R1, R2, R3), 



/*Hidden Constraints (implemented here to complete values for round 1, 2 and 3)*/

points(S2), not S2 = 1, points(S3), not S3 = 1, points(P3), not P3 = 1,



/*4th constraint (implemented last because most of the variables have not been generated previously*/

points(P4), points(T4), points(S4), points(R4), fourExactly(1, [O4, P4, T4, S4, R4]), 

points(O5), points(P5), points(T5), points(S5), points(R5), fourExactly(1, [O5, P5, T5, S5, R5]),



/*

Hidden Constraints

1. noParticipate: in each round, there can only be one team that does not participate

2. noParticipate: each team will only not participate in one of the rounds

3. twoWins: in each round, only 2 teams can win (the other 2 lose)

*/

noParticipate([O1,P1,R1,S1,T1]), noParticipate([O2,P2,R2,S2,T2]), noParticipate([O3,P3,R3,S3,T3]), noParticipate([O4,P4,R4,S4,T4]), noParticipate([O5,P5,R5,S5,T5]),

noParticipate([O1,O2,O3,O4,O5]), noParticipate([P1,P2,P3,P4,P5]), noParticipate([T1,T2,T3,T4,T5]), noParticipate([S1,S2,S3,S4,S5]), noParticipate([R1,R2,R3,R4,R5]),

twoWins([O1,P1,R1,S1,T1]), twoWins([O2,P2,R2,S2,T2]), twoWins([O3,P3,R3,S3,T3]).





/*Win once and lose once in the previous 2 or 3 rounds*/

winLose(X, Y) :- X = 0, Y = 2.

winLose(X, Y) :- X = 2, Y = 0.

winLose(X,Y,Z) :- X = 2, Y = 0.

winLose(X,Y,Z) :- X = 0, Y = 2.

winLose(X,Y,Z) :- Y = 2, Z = 0.

winLose(X,Y,Z) :- Y = 0, Z = 2.

winLose(X,Y,Z) :- X = 2, Z = 0.

winLose(X,Y,Z) :- X = 0, Z = 2.





/*Win twice in the previous 3 rounds*/

wonTwice(X, Y, Z) :- X = 2, Y = 2.

wonTwice(X, Y, Z) :- Y = 2, Z = 2.

wonTwice(X, Y, Z) :- X = 2, Z = 2.





/*Check if there are only 2 wins in every round*/

twoWins([X1, X2, X3, X4, X5]) :- X1 = 2, X2 = 2, not X3 = 2, not X4 = 2, not X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- X1 = 2, not X2 =2, X3 = 2, not X4 = 2, not X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- X1 = 2, not X2 = 2, not X3 = 2, X4 = 2, not X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- X1 = 2, not X2 = 2, not X3 = 2, not X4 = 2, X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- not X1 = 2, X2 = 2, X3 = 2, not X4 = 2, not X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- not X1 = 2, X2 = 2, not X3 = 2, X4 = 2, not X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- not X1 = 2, X2 = 2, not X3 = 2, not X4 = 2, X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- not X1 = 2, not X2 = 2, X3 = 2, X4 = 2, not X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- not X1 = 2, not X2 = 2, X3 = 2, not X4 = 2, X5 = 2.

twoWins([X1, X2, X3, X4, X5]) :- not X1 = 2, not X2 = 2, not X3 = 2, X4 = 2, X5 = 2.





/*there should be exactly 4 teams with 1 because the match was a draw*/

fourExactly(X, [X1, X2, X3, X4, X5]) :- X1 = X, X2 = X, X3 = X, X4 = X, not X5 = X.

fourExactly(X, [X1, X2, X3, X4, X5]) :- X1 = X, X2 = X, X3 = X, not X4 = X, X5 = X.

fourExactly(X, [X1, X2, X3, X4, X5]) :- X1 = X, X2 = X, not X3 = X, X4 = X, X5 = X.

fourExactly(X, [X1, X2, X3, X4, X5]) :- X1 = X, not X2 = X, X3 = X, X4 = X, X5 = X.

fourExactly(X, [X1, X2, X3, X4, X5]) :- not X1 = X, X2 = X, X3 = X, X4 = X, X5 = X.



/*there should be only one team that does not participat in each round and each team can only not play once throughout the tournament*/

noParticipate([X1, X2, X3, X4, X5]) :- X1 = (-1), not X2 = (-1), not X3 = (-1), not X4 = (-1), not X5 = (-1).

noParticipate([X1, X2, X3, X4, X5]) :- not X1 = (-1), X2 = (-1), not X3 = (-1), not X4 = (-1), not X5 = (-1).

noParticipate([X1, X2, X3, X4, X5]) :- not X1 = (-1), not X2 = (-1), X3 = (-1), not X4 = (-1), not X5 = (-1).

noParticipate([X1, X2, X3, X4, X5]) :- not X1 = (-1), not X2 = (-1), not X3 = (-1), X4 = (-1), not X5 = (-1).

noParticipate([X1, X2, X3, X4, X5]) :- not X1 = (-1), not X2 = (-1), not X3 = (-1), not X4 = (-1), X5 = (-1).





print_solution([O1,P1,R1,S1,T1,O2,P2,R2,S2,T2,O3,P3,R3,S3,T3,O4,P4,R4,S4,T4,O5,P5,R5,S5,T5]) :- 

solve([O1,P1,R1,S1,T1,O2,P2,R2,S2,T2,O3,P3,R3,S3,T3,O4,P4,R4,S4,T4,O5,P5,R5,S5,T5]),

write('		round1	round2	round3	round4	round5	total'), nl, 

write('--------------------------------------------------------------'), nl, 

write('Oakville	'), write('	  '), write(O1), write('	  '), write(O2), write('	  '), write(O3), write('	 '), write(O4), write('	  '), write(O5), write('	 '), Total1 is O1+O2+O3+O4+O5, write(Total1), nl, 

write('Pickering	'), write('	  '), write(P1), write('	  '), write(P2), write('	  '), write(P3), write('	  '), write(P4), write('	 '), write(P5), write('	 '), Total2 is P1+P2+P3+P4+P5, write(Total2), nl,

write('RichmHill	'), write('	 '), write(R1), write('	  '), write(R2), write('	  '), write(R3), write('	  '), write(R4), write('	  '), write(R5), write('	 '), Total3 is R1+R2+R3+R4+R5, write(Total3), nl,

write('Scarboro	'), write('	  '), write(S1), write('	 '), write(S2), write('	  '), write(S3), write('	  '), write(S4), write('	  '), write(S5), write('	 '), Total4 is S1+S2+S3+S4+S5, write(Total4), nl,

write('Toronto	'), write('	  '), write(T1), write('	  '), write(T2), write('	 '), write(T3), write('	  '), write(T4), write('	  '), write(T5), write('	 '), Total5 is T1+T2+T3+T4+T5, write(Total5), nl,

write('--------------------------------------------------------------'), nl.





/* 

Prolog Session:



?- solve(List).

	List = [2, 0, -1, 2, 0, 0, 2, 0, -1, 2, 2, 0, 2, 0, -1, -1, 1, 1, 1, ...]

	Yes (0.00s cpu, solution 1, maybe more)

	No (0.30s cpu)


?- X is cputime, solve(List), Y is cputime, Z is Y - X.

	X = 1.59375

	List = [2, 0, -1, 2, 0, 0, 2, 0, -1, 2, 2, 0, 2, 0, -1, -1, 1, 1, 1, ...]

	Y = 1.59375

	Z = 0.0

	Yes (0.00s cpu, solution 1, maybe more)

	No (0.45s cpu)



?- print_solution(List).

	List = [2, 0, -1, 2, 0, 0, 2, 0, -1, 2, 2, 0, 2, 0, -1, -1, 1, 1, 1, ...]

	Yes (0.00s cpu, solution 1, maybe more)

	No (0.28s cpu)



Output:

		round1	round2	round3	round4	round5	total
--------------------------------------------------------------
Oakville	  2	  0	  2	 -1	  1	 4

Pickering	  0	  2	  0	  1	 -1	 2

RichmHill	 -1	  0	  2	  1	  1	 3

Scarboro	  2	 -1	  0	  1	  1	 3

Toronto		  0	  2	 -1	  1	  1	 3
--------------------------------------------------------------



?- X is cputime, print_solution(List), Y is cputime, Z is Y - X.

	X = 1.203125

	List = [2, 0, -1, 2, 0, 0, 2, 0, -1, 2, 2, 0, 2, 0, -1, -1, 1, 1, 1, ...]

	Y = 1.203125

	Z = 0.0

	Yes (0.00s cpu, solution 1, maybe more)

	No (0.39s cpu)

*/

 