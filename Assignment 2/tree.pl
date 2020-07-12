/*Question 1*/

replace(X, Y, tree(X, void, void), tree(Y, void,void)). 
replace(X, Y, tree(Z, void, void), tree(Z, void, void)):- not Z = X.
replace(X, Y, tree(X, Left, Right), tree(Y, Left2, Right2)) :- replace(X, Y, Left, Left2), replace(X, Y, Right,Right2).
replace(X, Y, tree(Z, Left, Right), tree(Z, Left2, Right2)) :- not Z = X, replace(X, Y, Left, Left2), replace(X, Y, Right, Right2).



/*Question 2*/

expand(X, void, tree(X, void, void)).
expand(X, tree(X, Left, Right), tree(X, Left, Right)).
expand(X, tree(Root, Left, Right), tree(Root, Left2, Right)) :- X < Root, expand(X, Left, Left2).
expand(X, tree(Root, Left, Right), tree(Root, Left, Right2)) :- X > Root, expand(X, Right, Right2).


