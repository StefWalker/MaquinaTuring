%! Programa de la máquina de Turing
%inst(q0, 1, q0, 0, der).
%inst(q0, v, qf, 1, detener).

inst(q0,1,q0,1,izq).
inst(q0,b,q1,0,der).
inst(q0,0,q1,0,izq).

inst(q1,b,q1,0,izq).
inst(q1,x,q1,x,izq).
inst(q1,0,q3,0,der).
inst(q1,1,q2,x,der).

inst(q3,0,q3,0,der).
inst(q3,1,q3,1,der).
inst(q3,x,q3,1,der).
inst(q3,b,q1,1,der).

inst(q2,0,q2,0,der).
inst(q2,1,q2,1,der).
inst(q2,x,q2,x,der).
inst(q2,b,q0,1,izq).

inst(q0,v,qf,.,detener).
inst(q1,v,qf,.,detener).
inst(q2,v,qf,.,detener).
inst(q3,v,qf,.,detener).

main :-
    open('myFile.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    turing(Lines,C),
    write(C), nl.

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).



% Simulador

turing(CintaActual, CintaFinal) :-
    ejecute(q0, [], CintaActual, Ls, Rs),
    reverse(Ls, Ls1),
    append(Ls1, Rs, CintaFinal).

ejecute(qf, Ls, Rs, Ls, Rs) :- !.
ejecute(Q0, Ls0, Rs0, Ls, Rs) :-
    simbolo(Rs0, SimboloLeido, RsRest),
    once(inst(Q0, SimboloLeido, Q1, NuevoSimb, Action)),
    accion(Action, Ls0, [NuevoSimb|RsRest], Ls1, Rs1),
    ejecute(Q1, Ls1, Rs1, Ls, Rs).

simbolo([], v, []).
simbolo([Simb|Rs], Simb, Rs).

accion(izq, Ls0, Rs0, Ls, Rs) :- izq(Ls0, Rs0, Ls, Rs).
accion(detener, Ls, Rs, Ls, Rs).
accion(der, Ls0, [Sym|Rs], [Sym|Ls0], Rs).

izq([], Rs0, [], [v|Rs0]).
izq([L|Ls], Rs, Ls, [L|Rs]).
