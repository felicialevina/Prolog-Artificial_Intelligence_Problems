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

size(block1, large).
size(block2, medium).
size(block3, large).
size(block4, medium).
size(block5, large).
size(block6, large).
size(block7, medium).
size(block8, medium).
size(block9, small).
size(block10, small).

color(block1, blue).
color(block2, orange).
color(block3, green).
color(block4, yellow).
color(block5, green).
color(block6, red).
color(block7, pink).
color(block8, blue).
color(block9, green).
color(block10, red).

shape(block1, wedge).
shape(block2, wedge).
shape(block3, cube).
shape(block4, pyramid).
shape(block5, cube).
shape(block6, cube).
shape(block7, wedge).
shape(block8, cube).
shape(block9, wedge).
shape(block10, pyramid).

locatedOn(block1, area1).
locatedOn(block2, area2).
locatedOn(block3, area3).
locatedOn(block4, block3).
locatedOn(block5, area4).
locatedOn(block6, block5).
locatedOn(block7, block6).
locatedOn(block8, area5).
locatedOn(block9, block8).
locatedOn(block10, area6).

justLeftOf(area1, area2).
justLeftOf(area2, area3).
justLeftOf(area3, area4).
justLeftOf(area4, area5).
justLeftOf(area5, area6).

beside(X,Y) :- locatedOn(X, area1), locatedOn(Y, area2).
beside(X,Y) :- locatedOn(X, area2), locatedOn(Y, area3).
beside(X,Y) :- locatedOn(X, area3), locatedOn(Y, area4).
beside(X,Y) :- locatedOn(X, area4), locatedOn(Y, area5).
beside(X,Y) :- locatedOn(X, area5), locatedOn(Y, area6).
beside(X,Y) :- locatedOn(X, area2), locatedOn(Y, area1).
beside(X,Y) :- locatedOn(X, area3), locatedOn(Y, area2).
beside(X,Y) :- locatedOn(X, area4), locatedOn(Y, area3).
beside(X,Y) :- locatedOn(X, area5), locatedOn(Y, area4).
beside(X,Y) :- locatedOn(X, area6), locatedOn(Y, area5).

above(X,Y) :- locatedOn(X,Y).
above(X,Y) :- locatedOn(X,Z), above(Z,Y).

leftOf(X,Y) :- above(X,Z), leftOf(Z,Y). 
leftOf(X,Y) :- above(Y,Z), leftOf(X,Z). 
leftOf(X,Y) :- justLeftOf(X,Y). 
leftOf(X,Y) :- justLeftOf(X,Z), leftOf(Z,Y).

rightOf(X,Y) :- leftOf(Y, X). 

/******************** lexicon ********************/
article(a). 
article(an).
article(any). 
article(the).

common_noun(block,X) :- block(X). 
common_noun(table,Y) :- locatedOn(X,Y), block(X), not block(Y). 

common_noun(wedge,X) :- block(X), shape(X, wedge). 
common_noun(cube,X) :- block(X), shape(X, cube). 
common_noun(pyramid,X) :- block(X), shape(X, pyramid). 

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

preposition(above,X,Y) :- above(X,Y). 
preposition(over,X,Y) :- above(X,Y).
preposition(on,X,Y):- above(X,Y). 

preposition(below,X,Y) :- above(Y,X).
preposition(under,X,Y) :- above(Y,X).
preposition(beneath,X,Y) :- above(Y,X). 
preposition(underneath,X,Y) :- above(Y,X). 

preposition(beside,X,Y) :- beside(X,Y).

preposition(between,X,Y) :- rightOf(X,Y).
preposition(and,X,Y) :- leftOf(X,Y).

/******************** parser ********************/

what(Words, Ref) :- np(Words, Ref).

/* Noun phrase can start with an article - if it is starts with "the" call np3, if it doesn't start with "the", call np2*/

np([Art|Rest], What) :- Art = the, article(Art), np3(Rest,What).
np([Art|Rest], What) :- not Art = the, article(Art), np2(Rest, What).

/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

np2([Adj|Rest],What) :- adjective(Adj,What), np2(Rest, What).
np2([Noun|Rest], What) :- common_noun(Noun, What), mods(Rest,What).

/* If a noun phrase starts with an article "the", 
then the program must check that there is no other object that has the same adjective(s) 
(it must be unique) except if it's "the table"*/

np3([Adj|Rest],What1) :- adjective(Adj,What1), np2(Rest, What1), not (adjective(Adj, What2), np2(Rest, What2), not What1 = What2).
np3([Noun|Rest], What1) :- common_noun(Noun, What1), not (common_noun(Noun, What2), not What1 = What2), mods(Rest,What1).
np3([Noun|Rest], What) :- Noun = table, common_noun(table, What), mods(Rest,What).

/*Noun phrase for "between", it has to check if left block is on the left of center block & right block is on the right of center block. 
mods([], What) is used to make sure that the program doesn't check if the right block is on the right of the left block (it must check center block instead)*/
  
np4([Art|Rest], What) :- article(Art), np5(Rest, What).

np5([Adj|Rest],What) :- adjective(Adj,What), np5(Rest, What).
np5([Noun|Rest], What) :- common_noun(Noun, What), mods([],What).

/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, What) :-
	appendLists(Start, End, Words),
	prepPhrase(Start, What),	mods(End, What).

prepPhrase([Prep|Rest], What) :- not Prep = between, 
	preposition(Prep, What, Ref), np(Rest, Ref).

/* If the Preposition word is "between", find any object that is on the left side of the main block (What), check if this left object matches all adjective(s) of the (left) block being searched. 
Find the description of the right object with the predicate findRest2(Rest, Rest2),  find any object that is on the right side of the main block (What), check if this right object matches all adjective(s) of the (right) block being searched.*/

prepPhrase([Prep|Rest], What) :- Prep = between,
	preposition(Prep, What, Ref), np4(Rest, Ref), findRest2(Rest, Rest2), preposition(and, What, Ref2), np4(Rest2, Ref2).

appendLists([], L, L).
appendLists([H|L1], L2, [H|L3]) :-  appendLists(L1, L2, L3).

/* Predicate to find the description of Right Block (all adjective(s) after the word "and" is the description for right block)*/

findRest2([Head|Tail], Result) :- Head = and, Result = Tail.
findRest2([Head|Tail], Result) :- not Head = and, findRest2(Tail, Result).