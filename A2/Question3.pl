area([A|[B|[C]]],Result):-
    [Ax|Ay] = A,
    [Bx|By] = B,  
    [Cx|Cy] = C,
    A1 is Bx-Ax,
    B1 is Cx-Ax,
    C1 is By-Ay,
    D1 is Cy-Ay,
    Result is (1/2)*((A1*D1)-(B1*C1)).