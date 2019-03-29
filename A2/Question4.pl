skip(A,B,L):-
    skipYes(A,B,L).

skipYes([],_,[]):-!.
skipYes([Ax|A],B,L):-
    member(Ax,B),
    skipNo(A,B,L),!.
skipYes([Ax|A],B,L):-
    skipYes(A,B,L),!.

skipNo([],_,[]):-!.
skipNo([Ax|A],B,[Ax|L]):-
    member(Ax,B),
    skipYes(A,B,L),!.
skipNo([Ax|A],B,[Ax|L]):-
    skipNo(A,B,L),!.




turn(A,B,L):-
    reverseYes(A,B,[],[],L).

reverseYes([],_,_,Acc,L):-
    reverse(Acc,Res),
    L = Res,!.
reverseYes([Ax|List],B,Acc,Acc2,L):-
    member(Ax,B),
    append([Ax],Acc,Res),
    reverse(Res,Res3),
    append(Res3,Acc2,Res2),
    turnNo(List,B,Res2,L),!.
reverseYes([Ax|List],B,Acc,Acc2,L):-
    reverseYes(List,B,[Ax|Acc],Acc2,L),!.

turnNo([],_,Acc,L):-
    reverse(Acc,Res),
    L = Res,!.
turnNo([Ax|List],B,Acc,L):-
    member(Ax,B),
    reverseYes(List,B,[],[Ax|Acc],L).
turnNo([Ax|List],B,Acc,L):-
    turnNo(List,B,[Ax|Acc],L).