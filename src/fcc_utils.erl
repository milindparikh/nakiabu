-module(fcc_utils).
-export([formbasefunctionname/2, formbasefunctionversion/3, formbasecalendarfunction/3]).
-export([is_time_older_than/2, add_days/2, subtract_days/2, is_time_sooner_than/2,day_difference/2, generatedayrange/2, returnerlangdate/1 ]).
-export([generate_decr_count/1, generate_incr_count/1]).

formbasecalendarfunction(Category, FunctionName, {Y, M, D}) ->
    Category++"_"++FunctionName++"_"++ integer_to_list(Y) ++"_"++integer_to_list(M)++"_"++integer_to_list(D).

formbasefunctionname(Category, FunctionName) ->    
    Category++"_"++FunctionName.

formbasefunctionversion(Category, FunctionName, Version) ->    
    formbasefunctionname(Category, FunctionName)++"_"++Version.


%% 12/01/2012 = dec 1 2012

returnerlangdate(StrDate) ->
    case regexp:split(StrDate, "/") of 
	{ok, [Month, Day, Year]} ->

	    {RY, _} = string:to_integer(Year),
	    {RM, _} = string:to_integer(Month),
	    {RD, _} = string:to_integer(Day),
	    {RY, RM, RD};
	{ok, [[]]} ->
	    empty
    end.

 
is_time_older_than({Date, Time}, Mark) ->
    is_time_older_than(calendar:datetime_to_gregorian_seconds({Date, Time})
        , Mark);
is_time_older_than(Time, {DateMark, TimeMark}) ->
    is_time_older_than(Time
        , calendar:datetime_to_gregorian_seconds({DateMark, TimeMark}));
is_time_older_than(Time, Mark) when is_integer(Time), is_integer(Mark) ->
    Time < Mark.


is_time_sooner_than({Date, Time}, Mark) ->
    is_time_sooner_than(calendar:datetime_to_gregorian_seconds({Date, Time})
        , Mark);
is_time_sooner_than(Time, {DateMark, TimeMark}) ->
    is_time_sooner_than(Time
        , calendar:datetime_to_gregorian_seconds({DateMark, TimeMark}));
is_time_sooner_than(Time, Mark) when is_integer(Time), is_integer(Mark) ->
    Time > Mark.


subtract_days(Date, {days, N}) ->
    New = calendar:date_to_gregorian_days(Date) - N
    , calendar:gregorian_days_to_date(New).

add_days(Date, {days, N}) ->
    New = calendar:date_to_gregorian_days(Date) + N
    , calendar:gregorian_days_to_date(New).

generatedayrange(StartDate, EndDate) ->
    [add_days(StartDate, {days, X}) || X <- lists:seq(0, day_difference(EndDate, StartDate))].

generate_incr_count(Num) ->
    lists:reverse(generate_decr_count(Num)).

generate_decr_count(0)->
    [0];
generate_decr_count(Num) ->
    [Num | generate_decr_count(Num-1)].

day_difference({D1, _}, D2) ->
    day_difference(D1, D2);
day_difference(D1, {D2, _}) ->
    day_difference(D1, D2);
day_difference(D1, D2) ->
    Days1 = calendar:date_to_gregorian_days(D1)
    , Days2 = calendar:date_to_gregorian_days(D2)
    , Days1 - Days2.
