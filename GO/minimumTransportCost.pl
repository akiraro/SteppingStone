run:- open('3by3_initial.txt',read,F), readAll(F,L), close(F),
    findX(L,LengthX),write("\nValue of X is "),write(LengthX),
    findArea(L,Area),findY(Area,LengthX,LengthY),write("\nValue of Y is "),writeln(LengthY),
    findEmptyCell(L,0,LengthX,EmptyCells),write("List of empty cell is : "),writeln(EmptyCells),
    %iterator(2,1,LengthX,L,Value),write("Value at (2,1) is "),writeln(Value),
    %getListX(1,3,LengthX,L,ListX),writeln(ListX),
    %getListY(4,1,LengthY,L,ListY),writeln(ListY),
    writeln("\nStart finding closed loop :"),
    addData((1,1)),stack((1,1)).
    %findClosedLoops((1,1),LengthX,LengthY,L,ClosedLoop),write("\nThe closed loop is :"),writeln(ClosedLoop).

% Stepping Stones Algorithm
% findClosedLoops((XEmptyCell,YEmptyCell), LengthX, List, Result)
findClosedLoops((X,Y),LengthX,LengthY,List,Result):-
    write("Checking coordinate for empty cell ("),write(X),write(","),write(Y),writeln(")"),
    iterateX((X,Y),(X,Y),LengthX,LengthY,List,Result),!.

iterateX((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,Result):-
    writeln("\nFlagX"),
    getListX(1,Ycoord,LengthX,List,[(Ax,Ay)|Lx]),
    writeln([(Ax,Ay)|Lx]),
    getNotMember((Xcoord,Ycoord),[(Ax,Ay)|Lx],(Bx,By)),
    % getNotMember((Xcoord,Ycoord),[(Ax,Ay)|Lx],Result,(Bx,By)),
    write("("),write(Bx),write(","),write(By),writeln(")"),
    iterateY((Xempty,Yempty),(Bx,By),LengthX,LengthY,List,[(Bx,By)|Result]),!.


iterateY((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,[]):-
    Xempty = Xcoord,!.
iterateY((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,Result):-
    writeln("\nFlagY"),
    getListY(Xcoord,1,LengthY,List,[(Ax,Ay)|Ly]),
    writeln([(Ax,Ay)|Ly]),
    getNotMember((Xcoord,Ycoord),[(Ax,Ay)|Ly],(Bx,By)),
    % getNotMember((Xcoord,Ycoord),[(Ax,Ay)|Ly],Result,(Bx,By)),
    write("("),write(Bx),write(","),write(By),writeln(")"),
    iterateX((Xempty,Yempty),(Bx,By),LengthX,LengthY,List,[(Bx,By)|Result]),!.
iterateY((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,Result):-
    write("("),write(Xcoord),write(","),write(Ycoord),writeln(")"),
    iterateX((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,[(Xcoord,Ycoord)|Result]).


getNotMember((Xcoord,Ycoord),[A|List],Result):-
    (Xcoord,Ycoord) \= A,
    Result = A,
    writeln("second"),!.
getNotMember((Xcoord,Ycoord),[A|List],Result):-
    (Xcoord,Ycoord) == A,
    getNotMember((Xcoord,Ycoord),List,Result),
    writeln("third").


% getNotMember((Xcoord,Ycoord),[A|List],Stack,Result):-
%     write("trace: "),writeln(A),
%     write("stack: "),writeln(Stack),
%     member(A,Stack),
%     getNotMember((Xcoord,Ycoord),List,Stack,Result),
%     writeln("first"),!.
% getNotMember((Xcoord,Ycoord),[A|List],Stack,Result):-
%     (Xcoord,Ycoord) \= A,
%     Result = A,
%     writeln("second"),!.
% getNotMember((Xcoord,Ycoord),[A|List],Stack,Result):-
%     (Xcoord,Ycoord) == A,
%     getNotMember((Xcoord,Ycoord),List,Stack,Result),
%     writeln("third").


% Add New Data
% addData
addData((X,Y)):- asserta(stack((X,Y))).


% Iterator to find value at current coordinates
% iterator(Xcoord,Ycoord,LengthX,List,Result)
iterator(X,Y,LengthX,List,Result):- 
    Counter is ((Y*LengthX)+X),
    iterate(List,Counter,R),
    Result = R.

iterate([-|_],0,0):-!.% Base case : Get data at current position if it is (-)
iterate([Data|_],0,Data):- !. % Base case : Get data at current position
iterate([_|L],Counter,Result):-
    Con is Counter -1,
    iterate(L,Con,Result).


% Get list of Row
% getListX(Xcoord,Ycoord,LengthX,List,Result)
getListX(Xcoord,_,LengthX,_,[]):-
        Xcoord >= LengthX-1 ,!.
getListX(Xcoord,Ycoord,LengthX,List,[(Xcoord,Ycoord)|Result]):-
    iterator(Xcoord,Ycoord,LengthX,List,Value),
    Value \= 0,
    NewX is Xcoord +1,
    getListX(NewX,Ycoord,LengthX,List,Result),!.
getListX(Xcoord,Ycoord,LengthX,List,Result):-
    iterator(Xcoord,Ycoord,LengthX,List,Value),
    Value == 0,
    NewX is Xcoord +1,
    getListX(NewX,Ycoord,LengthX,List,Result),!.


% Get list of Column
% getListY(Xcoord,Ycoord,LengthY,List,Result)
getListY(_,Ycoord,LengthY,_,[]):-
    Ycoord >= LengthY-1 ,!.
getListY(Xcoord,Ycoord,LengthY,List,[(Xcoord,Ycoord)|Result]):-
    iterator(Xcoord,Ycoord,LengthY,List,Value),
    Value \= 0,
    NewY is Ycoord +1,
    getListY(Xcoord,NewY,LengthY,List,Result),!.
getListY(Xcoord,Ycoord,LengthY,List,Result):-
    iterator(Xcoord,Ycoord,LengthY,List,Value),
    Value == 0,
    NewY is Ycoord +1,
    getListY(Xcoord,NewY,LengthY,List,Result),!.


% Find list of empty cells
% findEmptyCell(List,Counter,LengthX,Result)
findEmptyCell([],_,_,[]):-!.
findEmptyCell(['-'|L], Counter,LengthX,[(X1,Y1)|Result]):-
    X1 is mod(Counter,LengthX),
    Y1 is div(Counter,LengthX),
    Con is Counter +1,
    findEmptyCell(L,Con,LengthX,Result),!.
findEmptyCell([_|L],Counter,LengthX,Result):- 
    Con is Counter +1 ,findEmptyCell(L,Con,LengthX,Result).

% find LengthX and LengthY using Area
findX(['Source1'|_],0):- !.
findX([_|L],R):-
    findX(L,R1),R is R1+1.

findArea([],1):- !.
findArea([_|L],R):- 
    findArea(L,R1),R is R1+1.
findY(Area,LengthX,Result):- 
    Result is Area/LengthX.



% Read text file into list of strings and numbers
readAll( InStream, [] ) :-
    at_end_of_stream(InStream), !.

readAll( InStream, [W|L] ) :-
    readWordNumber( InStream, W ), !,
    readAll( InStream, L ).

% read a white-space separated text or number
readWordNumber(InStream,W):-
	get_code(InStream,Char),
	checkCharAndReadRest(Char,Chars,InStream),
	codes2NumOrWord(W,Chars).

% Convert list of codes into a number if possible to string otherwise
codes2NumOrWord(N,Chars) :-
    atom_codes(W,Chars),
    atom_number(W,N),!.

codes2NumOrWord(W,Chars) :-
    atom_codes(W,Chars).
   
% Source: Learn Prolog Now!   
checkCharAndReadRest(10,[],_):-  !.
   
checkCharAndReadRest(32,[],_):-  !.
   
checkCharAndReadRest(9,[],_):-  !.   
   
checkCharAndReadRest(-1,[],_):-  !.
      
checkCharAndReadRest(Char,[Char|Chars],InStream):-
         get_code(InStream,NextChar),
         checkCharAndReadRest(NextChar,Chars,InStream).
