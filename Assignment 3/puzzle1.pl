dig(0). dig(1). dig(2). dig(3). dig(4). dig(5). dig(6). dig(7). dig(8). dig(9).



solve([G,E,T, B, Y, A, R]) :- dig(G), dig(E), dig(T), dig(B), dig(Y), dig(A), dig(R), 



G > 0, B > 0, 



E is (Y*T) mod 10, C1 is (Y*T) // 10,

B is (Y*E+C1) mod 10, C10 is (Y*E+C1) // 10,

A is (Y*G+C10) mod 10, B is (Y*G+C10) // 10,



T is (B*T) mod 10, 

E is (B*E) mod 10, 

G is (B*G) mod 10, 



R is (B+T) mod 10, C100 is (B+T) // 10, 

A is (A+E+C100) mod 10, C1000 is (A+E+C100) // 10,

E is (B+G+C1000) mod 10, B is (B+G+C1000) // 10,



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

