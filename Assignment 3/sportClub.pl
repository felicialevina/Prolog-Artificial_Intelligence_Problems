/*domain*/
pos(0).
pos(1).
pos(2).
pos(3).
pos(4).

solve([A,B,C,D,E,F]) :-
/*1st contraint*/ 
pos(A), pos(B), not B=0, not A=2, notEqual(A,B),

/*2nd constraint*/ 
not B=2, not B=4,

/*3rd and 6th constraint are done together because Frank and Colleen's conditions are connected to each other*/ 
pos(C), pos(F), not F=2, not F=3, not F=4, notEqual(F,A), notEqual(F,B), conF(F, C), conC(C, B, F), notEqual(F, C), notEqual(C, A), notEqual(C, B),

/*4th constraint*/ 
pos(E), pos(D), incompatibleD(E, F, D), notEqual(D, A), notEqual(D, B), notEqual(D, C), notEqual(D, E), notEqual(D, F),

/*5th constraint*/ 
incompatibleE(A, B, E), notEqual(E, A), notEqual(E, B), notEqual(E, C), notEqual(E, F).


/*We make a predicate for Frank's condition of only being the president if Coleen is not the Vice President*/
conF(F, C) :- F is 1, not C=2.


/*We make a predicate for Coleen's condition of only working with Bart if Frank is also elected*/
/*If Bart is elected and Frank is not elected, then Coleen is not elected*/
conC(P, Q, R) :- Q>0, R=0, P=0.

/*If Bart is elected and Frank is also elected, then Coleen is elected*/
conC(P, Q, R) :- Q>0, R>0, not P=0.


/*We make a predicate for Eva's condition of not working if both Arthur and Bart are elected*/
/*If Arthur is not elected and Bart is elected, then Eva is elected*/
incompatibleE(X, Y, Z) :- X is 0, Y>0, not Z=0, not Z=Y.

/*If Arthur is elected and Bart is not elected, then Eva is elected*/
incompatibleE(X, Y, Z) :- X>0, Y is 0, not Z=0, not Z=X.

/*If Arthur is elected and Bart is elected, then Eva is not elected*/
incompatibleE(X, Y, Z) :- X>0, Y>0, Z=0.


/*Donna's condition of not working with either Eva or Frank*/
/*If both Eva and Frank are elected, then Donna is not elected*/
incompatibleD(L, M, N) :- L>0, M>0, N=0.

/*If Eva is not elected but Frank is elected, then Donna is not elected*/
incompatibleD(L, M, N) :- L=0, M>0, N=0.

/*If Eva is elected but Frank is not elected, then Donna is not elected*/
incompatibleD(L, M, N) :- L>0, M=0, N=0.

/*If both Eva and Frank are not elected, then Donna is elected*/
incompatibleD(L, M, N) :- L=0, M=0, not N=0.

/*We make a predicate notEqual predicate for the hidden constraint that if one of the four positions are taken then another person cannot take the same position*/
notEqual(J, K) :- not J is 0, not J=K.
notEqual(J, K) :- J is 0.

/*printing the solution*/
print_solution([A,B,C,D,E,F]):-
solve([A,B,C,D,E,F]),
write('Arthur is '), getPos(A), nl,
write('Bart is '), getPos(B), nl,
write('Colleen is '), getPos(C), nl,
write('Donna is '), getPos(D), nl,
write('Eva is '), getPos(E), nl,
write('Frank is '), getPos(F), nl.

/*We make a predicate getPos to print the positions*/
getPos(X) :- X=:=0, write('Not elected').
getPos(X) :- X=:=1, write('President').
getPos(X) :- X=:=2, write('Vice President').
getPos(X) :- X=:=3, write('Treasurer').
getPos(X) :- X=:=4, write('Secretary').

/*

Output of queries:

?- solve(List).
List = [0, 3, 4, 0, 2, 1]
Yes (0.00s cpu, solution 1, maybe more)
No (0.00s cpu)

?- X is cputime, solve(List), Y is cputime, Z is Y - X.
X = 0.03125
List = [0, 3, 4, 0, 2, 1]
Y = 0.03125
Z = 0.0
Yes (0.00s cpu, solution 1, maybe more)
No (0.00s cpu)

?- print_solution(List).
List = [0, 3, 4, 0, 2, 1]
Yes (0.00s cpu, solution 1, maybe more)
No (0.00s cpu)

Output message:
Arthur is Not elected
Bart is Treasurer
Colleen is Secretary
Donna is Not elected
Eva is Vice President
Frank is President

?- X is cputime, print_solution(List), Y is cputime, Z is Y - X.
X = 0.03125
List = [0, 3, 4, 0, 2, 1]
Y = 0.03125
Z = 0.0
Yes (0.00s cpu, solution 1, maybe more)
No (0.00s cpu)

*/
