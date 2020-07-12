minSavings(D, M):- M is 9000*D.
minIncome(D, M):- M is 25000+(8000*D).

savingsAdequate(Amount, D, Min):- minSavings(D, Min), Amount >= Min.
incomeAdequate(Amount, D, Min):- minIncome(D, Min), Amount >= Min.

save(What):- cash(C), saved(S), dependents(D), not savingsAdequate(S, D, Min), What is C.
save(What):- cash(C), earnings(E), saved(S), dependents(D), incomeAdequate(E, D, Min1), savingsAdequate(S, D, Min2), What is C/2.
save(What):- cash(C), earnings(E), saved(S), dependents(D), not incomeAdequate(E, D, Min1), savingsAdequate(S, D, Min2), What is 0.2*C.

invest(What):- cash(C), saved(S), dependents(D), not savingsAdequate(S, D, Min), What is 0.
invest(What):- cash(C), earnings(E), saved(S), dependents(D), incomeAdequate(E, D, Min1), savingsAdequate(S, D, Min2), What is C/2.
invest(What):- cash(C), earnings(E), saved(S), dependents(D), not incomeAdequate(E, D, Min1), savingsAdequate(S, D, Min2), What is 0.8*C.