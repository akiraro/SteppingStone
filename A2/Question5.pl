treeEx(X) :-
    X = t(73,
            t(31,t(5,nil,nil),nil),
            t(101,t(83,nil,t(97,nil,nil)),nil)).


single(t(_,nil,nil),[]).
single(t(Root,Left,nil),[Root|L]):-
    single(Left,L),!.
single(t(Root,nil,Right),[Root|L]):-
    single(Right,L),!.
single(t(_,Left,Right),Res):-
    single(Left,L),
    single(Right,L1),
    append(L,L1,Res).


singleFill(t(Root,Left,nil),Value,t(Root,Left,t(Value,nil,nil))):-!.
singleFill(t(Root,nil,Right),Value,t(Root,t(Value,nil,nil),Right)):-!.
singleFill(t(Root,Left,Right),Value,t(Root,L1,L2)):-
    singleFill(Left,Value,L1),
    singleFill(Right,Value,L2).