% Example use
% open('3by3_inputdata.txt',read,F), readAll(F,L), close(F).

% Read text file into list of strings and numbers
readAll( InStream, [] ) :-
    at_end_of_stream(InStream), !.

readAll( InStream, [W|L] ) :-
    readWordNumber( InStream, W ), !, 
    write(W), write(' '), % Just for sanity 
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
