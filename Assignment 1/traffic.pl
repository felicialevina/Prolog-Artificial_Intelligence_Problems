at(honda,11,-26).
at(subaru,-3,34).
at(bmw,-22,-19).
at(ford,21,14).

light(green,11,-26).
light(green,-3,34).
light(red,-22,-19).
light(red,21,14).

distance(X1, X2, Y1, Y2, D) :- D is sqrt(((X1-X2)*(X1-X2))+((Y1-Y2)*(Y1-Y2))).

eastbound(X,Y):- X > -200, X < -20, Y > -20, Y < 0.
southbound(X,Y):- X > -20, X < 0, Y > 20, Y < 200.
northbound(X,Y):- X > 0, X < 20, Y > -200, Y < -20.
westbound(X,Y):- X > 20, X < 200, Y > 0, Y < 20.

oppDir(X1,Y1,X2,Y2):- eastbound(X1,Y1), westbound(X2,Y2).
oppDir(X1,Y1,X2,Y2):- northbound(X1,Y1), southbound(X2,Y2).
oppDir(X1,Y1,X2,Y2):- westbound(X1,Y1), eastbound(X2,Y2).
oppDir(X1,Y1,X2,Y2):- southbound(X1,Y1), northbound(X2,Y2).

perpendicDir(X1,Y1,X2,Y2):- eastbound(X1,Y1), southbound(X2,Y2).
perpendicDir(X1,Y1,X2,Y2):- westbound(X1,Y1), northbound(X2,Y2).
perpendicDir(X1,Y1,X2,Y2):- southbound(X1,Y1), westbound(X2,Y2).
perpendicDir(X1,Y1,X2,Y2):- northbound(X1,Y1), eastbound(X2,Y2).

canDriveStraight(Car,X,Y):- at(Car,X,Y), light(green,X,Y).

canTurnRight(Car,X,Y):- canDriveStraight(Car,X,Y).
canTurnRight(Car,X,Y) :- at(Car,X,Y), light(red,X,Y), at(Car2,A,B), perpendicDir(X,Y,A,B), distance(X, Y, A, B, D), not Car=Car2, D>=45.

canTurnLeft(Car,X,Y) :- at(Car,X,Y), light(green,X,Y), at(Car2,A,B), oppDir(X,Y,A,B), distance(X,Y,A,B,D), not Car=Car2, D>=80.