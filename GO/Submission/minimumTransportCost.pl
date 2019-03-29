
% The main predicate to run the whole program
% minimumTransportCost(InputFile,InitialFile,Cost)
minimumTransportCost(A,B,Cost):- 
    open(B,read,F), readAll(F,L), close(F),
    open(A,read,F1), readAll(F1,C), close(F1),
    findX(L,LengthX),
    findArea(L,Area),findY(Area,LengthX,LengthY),
    findEmptyCell(L,0,LengthX,EmptyCells),write("List of empty cell is : "),writeln(EmptyCells),
    writeln("\n ----- Stepping Stone Algorithm ----- "),
    findClosedLoops(EmptyCells,LengthX,LengthY,L,ClosedLoop),
    findCost(ClosedLoop,C,10000,LengthX,_,RC),
    modData(RC,L,LengthX,NewList),
    calculateCost(NewList,C,1,LengthX,LengthY,Result),
    writeln(""),
    Cost is Result,
    write_list_to_file("solution.txt", NewList).

% make,minimumTransportCost('3by3_inputdata.txt','3by3_initial.txt',Cost).

% Stepping Stones Algorithm
% findClosedLoops(EmptyCellList, LengthX, LengthY, List, Result)
findClosedLoops([],_,_,_,[]):-!.
findClosedLoops([(Ax,Ay)|L],LengthX,LengthY,List,[[(Ax,Ay)|Result]|KK]):-
    write("\n\nChecking coordinate for empty cell ("),write(Ax),write(","),write(Ay),writeln(") .........."),
    iterateX((Ax,Ay),(Ax,Ay),LengthX,LengthY,List,Result),
    write("\nThe closed loop for empty cell ("),write(Ax),write(","),write(Ay),write(")"),write(" is :"),writeln(Result),
    retractall(database((_,_))), %Clear up all the databases
    findClosedLoops(L,LengthX,LengthY,List,KK),!.


iterateX((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,[(Bx,By)|Result]):-
    writeln("\nFlagX"),
    getListX(1,Ycoord,LengthX,List,[(Ax,Ay)|Lx]),
    writeln([(Ax,Ay)|Lx]),
    getNotMember((Xcoord,Ycoord),[(Ax,Ay)|Lx],(Bx,By)),
    write("("),write(Bx),write(","),write(By),writeln(")"),
    addData((Bx,By)),
    iterateY((Xempty,Yempty),(Bx,By),LengthX,LengthY,List,Result).


iterateY((Xempty,_),(Xcoord,_),_,_,_,[]):-
    Xempty = Xcoord,!.
iterateY((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,[(Bx,By)|Result]):-
    writeln("\nFlagY"),
    getListY(Xcoord,1,LengthX,List,[(Ax,Ay)|Ly]),
    writeln([(Ax,Ay)|Ly]),
    getNotMember((Xcoord,Ycoord),[(Ax,Ay)|Ly],(Bx,By)),
    write("("),write(Bx),write(","),write(By),writeln(")"),
    addData((Bx,By)),
    iterateX((Xempty,Yempty),(Bx,By),LengthX,LengthY,List,Result),!.
iterateY((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,[(Xcoord,Ycoord)|Result]):-
    write("("),write(Xcoord),write(","),write(Ycoord),writeln(")"),
    addData((Xcoord,Ycoord)),
    iterateX((Xempty,Yempty),(Xcoord,Ycoord),LengthX,LengthY,List,Result).

getNotMember((_,_),[A|[]],A).
getNotMember((Xcoord,Ycoord),[A|_],Result):-
    (Xcoord,Ycoord) \= A,
    not(database(A)),
    Result = A,
    writeln("second"),!.
getNotMember((Xcoord,Ycoord),[A|List],Result):-
    (Xcoord,Ycoord) == A,
    writeln("third"),
    getNotMember((Xcoord,Ycoord),List,Result),!.
getNotMember((Xcoord,Ycoord),[_|List],Result):-
    writeln("hess"),
    getNotMember((Xcoord,Ycoord),List,Result),!.
getNotMember(_,_,_):-
    writeln("hell"),!.


% Add New Data
% addData
addData((X,Y)):- asserta(database((X,Y))).
database((0,0)).

% Find Marginal Cost
% findCost(ListPath,ListCost,CurrentLowest,LengthX,Dummy,ResultCost)
findCost([],_,_,_,Dummy,Dummy):-!.
findCost([A|LP],LC,CL,LengthX,Dummy,RC):-
    write("\nFinding Cost for :"),
    writeln(A),
    calculate(A,LC,LengthX,Res),
    Res < CL,
    CL1 = Res,
    write("Marginal Cost is : "),
    writeln(CL1),
    writeln("Setting this path as new lowest"),
    findCost(LP,LC,CL1,LengthX,A,RC),!.

findCost([A|LP],LC,CL,LengthX,Dummy,RC):-
    calculate(A,LC,LengthX,Res),
    write("Marginal Cost is : "),
    writeln(Res),
    findCost(LP,LC,CL,LengthX,Dummy,RC),!.

calculate([(Ax,Ay)|L],LC,LengthX,Result):-
    iterator(Ax,Ay,LengthX,LC,Acc),
    calculateNeg(L,LC,LengthX,Acc,Result).

calculatePos([],_,_,Acc,Result):-
    Result is Acc,!.
calculatePos([(Ax,Ay)|L],LC,LengthX,Acc,Result):-
    iterator(Ax,Ay,LengthX,LC,Res),
    R1 is Acc + Res,
    calculateNeg(L,LC,LengthX,R1,Result).

calculateNeg([(Ax,Ay)|L],LC,LengthX,Acc,Result):-
    iterator(Ax,Ay,LengthX,LC,Res),
    R1 is Acc - Res,
    calculatePos(L,LC,LengthX,R1,Result).

% Modify Data
% modData(List,LengthX)
modData([(Ax,Ay)|L],SupplyList,LengthX,R):-
    getLowestSupply(L,SupplyList,LengthX,10000,Res),!,
    write("Lowest Supply is :"),writeln(Res),
    accessData([(Ax,Ay)|L],SupplyList,Res,LengthX,R,1).

accessData([],Result,_,_,Result,_):-!.
accessData([A|[B|L]],SupplyList,Data,LengthX,Res,LOL):-
    A == B,
    accessData(L,SupplyList,Data,LengthX,Res,LOL),!.
accessData([(Ax,Ay)|L],SupplyList,Data,LengthX,Res,LOL):-
    modifier(Ax,Ay,LengthX,SupplyList,Data,R1,LOL),
    LOL1 is LOL * -1,
    accessData(L,R1,Data,LengthX,Res,LOL1),!.


modifier(X,Y,LengthX,List,Data,Result,LOL):- 
    Counter is ((Y*LengthX)+X),
    modify(List,Counter,Data,R1,LOL),
    Result = R1.

modify([],_,_,[],_):-!.
modify([-|L],0,Data,[Data|Result],LOL):-   % Base case : Replace when reach at the empty cell
    modify(L,100000,Data,Result,LOL),!.
modify([A|L],0,Data,[R1|Result],LOL):-   % Base case : Replace when reach at the coordinates
    R1 is A + (Data*LOL),
    modify(L,100000,Data,Result,LOL),!.
modify([A|L],Counter,Data,[A|Result],LOL):-
    Con is Counter -1,
    modify(L,Con,Data,Result,LOL),!.


getLowestSupply([],_,_,Dummy,Result):-
    Result is Dummy,!.
getLowestSupply([(Ax,Ay)|L],SupplyList,LengthX,Dummy,Result):-
    iterator(Ax,Ay,LengthX,SupplyList,Res),
    Res<Dummy,
    getLowestSupply(L,SupplyList,LengthX,Res,Result).
getLowestSupply([(Ax,Ay)|L],SupplyList,LengthX,Dummy,Result):-
    iterator(Ax,Ay,LengthX,SupplyList,Res),
    getLowestSupply(L,SupplyList,LengthX,Dummy,Result).
    

% Calculate new total cost
% calculateCost()
calculateCost(A,B,Counter,LengthX,LengthY,Result):-
    Counter < (LengthY-1),
    getListX(1,Counter,LengthX,A,Res),
    Cont is Counter +1,
    calcAcc(Res,A,B,LengthX,Val),
    calculateCost(A,B,Cont,LengthX,LengthY,Ree),
    Result is  Val + Ree,!.
calculateCost(_,_,_,_,_,0).


calcAcc([],_,_,_,0).
calcAcc([(Ax,Ay)|List],Sup,Cost,LengthX,Result):-
    iterator(Ax,Ay,LengthX,Sup,Res1),
    iterator(Ax,Ay,LengthX,Cost,Res2),
    R3 is Res1*Res2,
    calcAcc(List,Sup,Cost,LengthX,Ree),
    Result = R3 + Ree.


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


loop_through_list(File, List) :-
    member(Element, List),
    write(File, Element),
    write(File, ' '),
    fail.
    
write_list_to_file(Filename,List) :-
    open(Filename, write, File),
    \+ loop_through_list(File, List),
    close(File).


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
