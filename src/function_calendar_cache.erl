-module(function_calendar_cache).
-export([addfunction/6, 
	 addfunction/5, 
	 lookupfunction/2, 
	 lookupfunction/3, 
	 lookupfunctionversion/2,
	 lookupfunctionversion/3]).

-define(DEFAULT_CATEGORY, "G").

addfunction( _FunctionName, _Version, 
	    _StartDate, _EndDate, _SourceCode) ->
    addfunction(?DEFAULT_CATEGORY, _FunctionName, _Version, 
		 _StartDate, _EndDate, _SourceCode).

addfunction(Category, FunctionName, Version, 
	    StartDate, EndDate, SourceCode) ->
%% store function in persistent store
%% spawn a category_function_version process
    FunctionVersion = fcc_utils:formbasefunctionversion(
			Category, FunctionName, Version
		       ),

    case fcc_store:lookup(function_version, FunctionVersion) of 
	{error, _} ->
	    {ok, Pid} = fcc_function_version_element:create(FunctionVersion,
							   StartDate,
							   EndDate, 
							   SourceCode),
	    fcc_store:insert(function_version, FunctionVersion, Pid),
		
	    addorcreatefunctioncalendar (Category, FunctionName, StartDate, EndDate, Version)
    end,
    ok.


addorcreatefunctioncalendar(Category, FunctionName, StartDate, EndDate, Version) ->

    ESD = fcc_utils:returnerlangdate(StartDate),
    case fcc_utils:returnerlangdate(EndDate) of 
	empty ->
	    EED = ESD;
	{Y, M, D} ->
	    EED = {Y, M, D}
    end,
    [addorcreatefunctioncalendar(fcc_utils:formbasecalendarfunction(
				   Category, FunctionName, Date), Version) || 
	Date <- fcc_utils:generatedayrange(ESD, EED)],
    ok.


addorcreatefunctioncalendar(FunctionCalendar, Version) ->
    case fcc_store:lookup(function_calendar, FunctionCalendar) of 
	{error, _} ->
	    {ok, Pid} = fcc_function_calendar_element:create(FunctionCalendar,
							   Version),
	    fcc_store:insert(function_calendar, FunctionCalendar, Pid);

	{ok, Pid} ->
	    fcc_function_calendar_element:addversion(Pid,
						     Version)
    end.


    

lookupfunctionversion( FunctionName, Version) ->
    lookupfunctionversion(?DEFAULT_CATEGORY, FunctionName, Version).

lookupfunctionversion(Category, FunctionName, Version) ->
    FunctionVersion = fcc_utils:formbasefunctionversion(
			Category, FunctionName, Version
		       ),
    
    case fcc_store:lookup(FunctionVersion) of 
	{ok, Pid} ->
	    Pid
    end.
    

lookupfunction(_FunctionName, _TargetDate) ->
    lookupfunction(?DEFAULT_CATEGORY, _FunctionName, _TargetDate).
lookupfunction(Category, FunctionName, _TargetDate) ->
    {ok, Pid} = fcc_store:lookup(
      function_calendar,
      fcc_utils:formbasecalendarfunction(Category, FunctionName, fcc_utils:returnerlangdate(_TargetDate))),
    fcc_function_calendar_element:getversion(Pid).





