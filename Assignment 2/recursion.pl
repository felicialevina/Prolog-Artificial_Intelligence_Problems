/*Question 1*/

add(N, [], []).
add(0, InputList, []).
add(N, [ Head | Tail ], [ Head | Output] ) :- not N is 0, M is N - 1, add(M, Tail, Output).


/*Question 2*/

dictionary(one, 1).
dictionary(two, 2).
dictionary(three, 3).
dictionary(four, 4).
dictionary(five, 5).
dictionary(six, 6).
dictionary(seven, 7).
dictionary(eight, 8).
dictionary(nine, 9).
convert( [ ], [ ] ). 
convert( [ H | T ] , [ H2 | T2 ] ) :- dictionary(H, H2), convert(T, T2).


/*Question 3*/

grep(E, L, Occurences) :-  grep(E, L, Occurences, 1), not Occurences = [].
grep(E, [ ], [ ], Counter). 
grep(E, [H | L], [Counter | Occurences], Counter) :- E = H, C is Counter + 1, grep(E, L, Occurences, C).
grep(E, [H | L], Occurences, Counter) :- not E = H, C is Counter + 1, grep(E, L, Occurences, C).


