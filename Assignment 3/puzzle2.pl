dig(0). dig(1). dig(2). dig(3). dig(4). dig(5). dig(6). dig(7). dig(8). dig(9). car(0). car(1).



solve([G,E,T, B, Y, A, R]) :-

/*Start by guessing B because it's a carry (either a 0 or 1 (in the addition section)) + must be greater than 0 because it's a starting character*/

/*Many constraints use B, it'll be faster if program can find value of B first*/

car(B), B > 0, car(C1000),



/*Guess G - which will help finding E*/

dig(G), G > 0, 



/*Test G based on B*/

/*Find E based on B and G*/

B is (B+G+C1000) // 10, dig(E), E is (B+G+C1000) mod 10,



/*Guess A*/

dig(A), car(C100),



/*Test A based on E*/

A is (A+E+C100) mod 10, C1000 is (A+E+C100) // 10, 



/*Guess T - which will help finding R*/

dig(T),



/*Test R based on B and T*/

dig(R), 

R is (B+T) mod 10, C100 is (B+T) // 10,



/*Guess Y and test constraints*/

/*Verify choice of G, E, T, B, A are correct*/

dig(Y), 

E is (Y*T) mod 10, C1 is (Y*T) // 10,

B is (Y*E+C1) mod 10, C10 is (Y*E+C1) // 10,

A is (Y*G+C10) mod 10, B is (Y*G+C10) // 10,



/*Verify choice for G, E, T, B are correct*/

/*Last constraints because they're more useful for verifying than finding values*/

T is (B*T) mod 10, 

E is (B*E) mod 10, 

G is (B*G) mod 10,



all_diff([G, E, T, B, Y, A, R]). 





all_diff([]).

all_diff([Head|Tail]) :- not members(Head, Tail), all_diff(Tail).





members(X, [X|Tail]).

members(X, [Head | Tail]):- members(X, Tail). 





print_solution([G, E, T, B, Y, A, R]) :- 

solve([G, E, T, B, Y, A, R]), 

write('     '), write(G), write(E), write(T), nl, 

write('*     '), write(B), write(Y), nl,

write('  -------'), nl, 

write('    '), write(B), write(A), write(B), write(E), nl,

write('+   '), write(G), write(E), write(T), nl,

write('  -------'), nl,

write('   '), write(B), write(E), write(A), write(R), write(E), nl.

