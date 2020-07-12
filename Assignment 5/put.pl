/******************** database ********************/
block(block1).
block(block2).
block(block3).
block(block4).
block(block5).
block(block6).
block(block7).
block(block8).
block(block9).
block(block10).

size(block1, small).
size(block2, medium).
size(block3, large).
size(block4, small).
size(block5, large).
size(block6, large).
size(block7, medium).
size(block8, small).
size(block9, small).
size(block10, large).

color(block1, red).
color(block2, orange).
color(block3, pink).
color(block4, yellow).
color(block5, red).
color(block6, green).
color(block7, blue).
color(block8, green).
color(block9, yellow).
color(block10, pink).

shape(block1, cube).
shape(block2, wedge).
shape(block3, cube).
shape(block4, pyramid).
shape(block5, cube).
shape(block6, cube).
shape(block7, cube).
shape(block8, pyramid).
shape(block9, cube).
shape(block10, wedge).

/*Precondition Axioms*/
poss(putOn(Block,X), S) :- shape(X, cube), clear(Block,S), clear(X,S).
poss(putOn(Block,X), S) :-  not block(X), clear(Block,S), clear(X,S).

/*Fluent 1*/
locatedOn(block1, area1, []).
locatedOn(block2, area2, []).
locatedOn(block3, area3, []).
locatedOn(block4, block3, []).
locatedOn(block5, area4, []).
locatedOn(block6, block5, []).
locatedOn(block7, area5, []).
locatedOn(block8, area6, []).
locatedOn(block9, area7, []).
locatedOn(block10, block9, []).

/*Successor State Axioms*/
locatedOn(Block, X, [putOn(Block,X)|S]) :- locatedOn(Block,Y,S), not X=Y, poss(putOn(Block,X), S).
locatedOn(Block, X, [A|S]) :- not (A = putOn(Block, Y), poss(putOn(Block,Y), S), not X = Y), locatedOn(Block,X,S).

/*Fluent 2*/
clear(block1, [ ]). 
clear(block2, [ ]).
clear(block4, [ ]).
clear(block6, [ ]). 
clear(block7, [ ]).
clear(block8, [ ]).
clear(block10, [ ]). 
clear(area8, [ ]).

/*Successor State Axioms*/
clear(X,[putOn(Block,Y)|S]) :- not X = Y, locatedOn(Block,X,S).
clear(X,[A|S]) :- not A = putOn(Block, X), clear(X,S).

/*predicate do*/
do([put|List], S1, S2) :- what(List, Ref, S2).

justLeftOf(area1, area2, []).
justLeftOf(area2, area3, []).
justLeftOf(area3, area4, []).
justLeftOf(area4, area5, []).
justLeftOf(area5, area6, []).
justLeftOf(area6, area7, []).
justLeftOf(area7, area8, []).

beside(X,Y,S) :- locatedOn(X, area1, S), locatedOn(Y, area2, S).
beside(X,Y,S) :- locatedOn(X, area2, S), locatedOn(Y, area3, S).
beside(X,Y,S) :- locatedOn(X, area3, S), locatedOn(Y, area4, S).
beside(X,Y,S) :- locatedOn(X, area4, S), locatedOn(Y, area5, S).
beside(X,Y,S) :- locatedOn(X, area5, S), locatedOn(Y, area6, S).
beside(X,Y,S) :- locatedOn(X, area6, S), locatedOn(Y, area7, S).
beside(X,Y,S) :- locatedOn(X, area7, S), locatedOn(Y, area8, S).
beside(X,Y,S) :- locatedOn(X, area2, S), locatedOn(Y, area1, S).
beside(X,Y,S) :- locatedOn(X, area3, S), locatedOn(Y, area2, S).
beside(X,Y,S) :- locatedOn(X, area4, S), locatedOn(Y, area3, S).
beside(X,Y,S) :- locatedOn(X, area5, S), locatedOn(Y, area4, S).
beside(X,Y,S) :- locatedOn(X, area6, S), locatedOn(Y, area5, S).
beside(X,Y,S) :- locatedOn(X, area7, S), locatedOn(Y, area6, S).
beside(X,Y,S) :- locatedOn(X, area8, S), locatedOn(Y, area7, S).

above(X,Y,S) :- locatedOn(X,Y,S).
above(X,Y,S) :- locatedOn(X,Z,S), above(Z,Y,S).

leftOf(X,Y,S) :- above(X,Z,S), leftOf(Z,Y,S). 
leftOf(X,Y,S) :- above(Y,Z,S), leftOf(X,Z,S). 
leftOf(X,Y,S) :- justLeftOf(X,Y,S). 
leftOf(X,Y,S) :- justLeftOf(X,Z,S), leftOf(Z,Y,S).

rightOf(X,Y,S) :- leftOf(Y,X,S). 

/******************** lexicon ********************/
article(a). 
article(an).
article(any). 
article(the).

common_noun(block,X) :- block(X). 
common_noun(wedge,X) :- block(X), shape(X, wedge). 
common_noun(cube,X) :- block(X), shape(X, cube). 
common_noun(pyramid,X) :- block(X), shape(X, pyramid). 
common_noun(table,Y,S) :- locatedOn(X,Y,S), block(X), not block(Y) . 

adjective(large,X) :- size(X, large).
adjective(huge,X) :- size(X, large).
adjective(big,X) :- size(X, large).
adjective(gigantic,X) :- size(X, large).

adjective(medium,X) :- size(X, medium).
adjective(average,X) :- size(X, medium).

adjective(small,X) :- size(X, small). 
adjective(little, X) :- size(X, small).
adjective(tiny, X) :- size(X, small). 
adjective(mini, X) :- size(X, small).

adjective(red,X) :- color(X, red). 
adjective(blue,X) :- color(X, blue). 
adjective(yellow,X) :- color(X, yellow). 
adjective(green,X) :- color(X, green). 
adjective(pink,X) :- color(X, pink). 
adjective(orange,X) :- color(X, orange). 

preposition(above,X,Y,S) :- above(X,Y,S). 
preposition(over,X,Y,S) :- above(X,Y,S).
preposition(on,X,Y,S):- above(X,Y,S). 

preposition(below,X,Y,S) :- above(Y,X,S).
preposition(under,X,Y,S) :- above(Y,X,S).
preposition(beneath,X,Y,S) :- above(Y,X,S). 
preposition(underneath,X,Y,S) :- above(Y,X,S). 

preposition(beside,X,Y,S) :- beside(X,Y,S).

preposition(between,X,Y,S) :- rightOf(X,Y,S).
preposition(and,X,Y,S) :- leftOf(X,Y,S).


/******************** parser ********************/

what(Words, Ref, S) :- np(Words, Ref, S).

/* Noun phrase can start with an article - if it is starts with "the" call np3, if it doesn't start with "the", call np2*/

np([Art|Rest], What, S) :- Art = the, article(Art), np3(Rest,What,S).
np([Art|Rest], What, S) :- not Art = the, article(Art), np2(Rest, What,S).

/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

np2([Adj|Rest],What,S) :- adjective(Adj,What), np2(Rest, What,S).
np2([Noun|Rest], What,S) :- not Noun = table, common_noun(Noun, What), mods(Rest,What,S).
np2([Noun|Rest], What,S) :- Noun = table, common_noun(Noun, What,S), mods(Rest,What,S).


/* If a noun phrase starts with an article "the", 
then the program must check that there is no other object that has the same adjective(s) 
(it must be unique) except if it's "the table"*/

np3([Adj|Rest],What1,S) :- adjective(Adj,What1), np2(Rest, What1,S), not (adjective(Adj, What2), np2(Rest, What2,S), not What1 = What2).
np3([Noun|Rest], What1,S) :- common_noun(Noun, What1), not (common_noun(Noun, What2), not What1 = What2), mods(Rest,What1,S).
np3([Noun|Rest], What,S) :- Noun = table, common_noun(table, What,S), mods(Rest,What,S).

/*Noun phrase for "between", it has to check if left block is on the left of center block & right block is on the right of center block. 
mods([], What) is used to make sure that the program doesn't check if the right block is on the right of the left block (it must check center block instead)*/
  
np4([Art|Rest], What,S) :- article(Art), np5(Rest, What,S).

np5([Adj|Rest],What,S) :- adjective(Adj,What), np5(Rest, What,S).
np5([Noun|Rest], What,S) :- common_noun(Noun, What), mods([],What,S).

/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _, S).
mods(Words,What,S) :-
	appendLists(Start, End, Words),
	prepPhrase(Start, What,S),	mods(End, What,S).

/* If the Preposition word is "between", find any object that is on the left side of the main block (What), check if this left object matches all adjective(s) of the (left) block being searched. 
Find the description of the right object with the predicate findRest2(Rest, Rest2),  find any object that is on the right side of the main block (What), check if this right object matches all adjective(s) of the (right) block being searched.*/

prepPhrase([Prep|Rest], What, S) :- not Prep = between, np(Rest, Ref, S),
	preposition(Prep, What, Ref, S).

prepPhrase([Prep|Rest], What, S) :- Prep = between,
	preposition(Prep, What, Ref,S), np4(Rest, Ref,S), findRest2(Rest, Rest2), preposition(and, What, Ref2,S), np4(Rest2, Ref2,S).


appendLists([], L, L).
appendLists([H|L1], L2, [H|L3]) :-  appendLists(L1, L2, L3).

/* Predicate to find the description of Right Block (all adjective(s) after the word "and" is the description for right block)*/

findRest2([Head|Tail], Result) :- Head = and, Result = Tail.
findRest2([Head|Tail], Result) :- not Head = and, findRest2(Tail, Result).