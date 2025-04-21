%%% Codigo hecho por Juan Pablo Parra El-Masri
%%% Fecha: 17/04/2025
%%% Paradigmas de lenguajes de Programación - Universidad EAFIT.


% def. vehicles.
vehicle(toyota, rav4, suv, 28000, 2022).
vehicle(toyota, camry, sedan, 25000, 2023).
vehicle(ford, mustang, sport, 45000, 2023).
vehicle(ford, f150, pickup, 35000, 2021).
vehicle(bmw, x5, suv, 60000, 2021).
vehicle(bmw, m3, sedan, 70000, 2024).
vehicle(honda, crv, suv, 32000, 2022).
vehicle(honda, civic, sedan, 22000, 2023).
vehicle(chevrolet, silverado, pickup, 40000, 2020).
vehicle(chevrolet, corvette, sport, 80000, 2024).

% budget check (filter)
meet_budget(Reference, BudgetMax) :-
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.

% getting brand refs.
list_by_brand(Brand, Refs) :-
    findall(Ref, vehicle(Brand, Ref, _, _, _), Refs).

% gen price limit inv.
generate_report(Brand, Type, Budget, Result) :-
    findall((Ref, Price), 
            vehicle(Brand, Ref, Type, Price, _), 
            Filtered),
    include_prices(Filtered, Prices, Refs),
    sum_list(Prices, Total),
    (Total =< Budget ->
        Result = [vehicles(Refs), total(Total)]
    ;
        sort_by_price(Filtered, Sorted),
        accumulate_vehicles(Sorted, Budget, Selected, Accumulated),
        (Accumulated > 0 -> 
            Result = [vehicles(Selected), total(Accumulated)]
        ; 
            Result = [vehicles([]), total(0)] % Caso sin vehículos
        )
    ).
% Extrae precios y referencias
include_prices([], [], []).
include_prices([(Ref, Price)|T], [Price|P], [Ref|R]) :-
    include_prices(T, P, R).

% Ordena por precio ascendente
sort_by_price(List, Sorted) :-
    predsort(compare_price, List, Sorted).

compare_price(Order, (_, P1), (_, P2)) :-
    compare(Order, P1, P2).

% Acumula vehículos hasta no exceder el límite
accumulate_vehicles([], _, [], 0).
accumulate_vehicles([(Ref, Price)|T], Limit, [Ref|Selected], Total) :-
    Price =< Limit,
    NewLimit is Limit - Price,
    accumulate_vehicles(T, NewLimit, Selected, SubTotal),
    Total is Price + SubTotal.

% Caso 1: Toyota SUV < $30k
test_case_1(Result) :-
    findall(Ref, (vehicle(toyota, Ref, suv, Price, _), Price < 30000), Result).

% Caso 2: Ford agrupado por tipo y año
test_case_2(Result) :-
    bagof((Type, Year, Ref), vehicle(ford, Ref, Type, _, Year), Result).

% Caso 3: Total Sedán <= $500k
test_case_3(Result) :-
    generate_report(_, sedan, 500000, Result).

%---------------consultas de prueba:

%%%----todos los suv menores de 35k usd
% findall((Brand, Ref), 
%        (vehicle(Brand, Ref, suv, Price, _), Price < 35000), 
%       Result).
 
%%%----- todos los fords
% list_by_brand(ford, Refs).

%%%-----bmw tipo y año
% bagof((Type, Year, Ref), vehicle(bmw, Ref, Type, _, Year), Result).

%%%---- lista Honda SUV con presupuesto de $100,000
% generate_report(honda, suv, 100000, Report).

%%%-----Total de inventario pick sin exceder $1,000,000
% generate_report(_, pickup, 1000000, Result).

%%%---- Vehículo más caro del catálogo
% findall(Price, vehicle(_, _, _, Price, _), Prices), max_list(Prices, Max), vehicle(B, R, T, Max, Y).

% %%-------Vehículos fabricados en 2023
% findall((Brand, Ref), vehicle(Brand, Ref, _, _, 2023), Result).

%%%-------Tipos disponibles para Toyota
% setof(Type, Ref^Price^Year^vehicle(toyota, Ref, Type, Price, Year), Types).

%%%------Vehículos entre 25k-40k
% findall((Brand, Ref), (vehicle(Brand, Ref, _, Price, _), Price >= 25000, Price =< 40000), Result).




