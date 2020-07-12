/*Question 1*/

cons([ ], null).
cons([Head | Tail], next(Head, X)) :- atomic(Head), cons(Tail, X).

 

/*Question 2*/ 

cons([Head | Tail], next(X, Y)) :-  cons(Head, X), cons(Tail,Y), not Head = []. 


/*Question 3*/

linked2List(null, [ ]).  
linked2List(next(Head,X), [Head | Tail]) :-  atomic(Head), linked2List(X, Tail), not Head = null.
linked2List(next(X, Y), [M | N]) :- linked2List(X, M), linked2List(Y, N), not X = null.


