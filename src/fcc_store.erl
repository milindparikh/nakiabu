-module(fcc_store).
-export([init/0, insert/3, lookup/2, delete/2]).

-define(FUNCTION_VERSION_TBL, function_version_tbl).
-define(FUNCTION_CALENDAR_TBL, function_calendar_tbl).


init()->
    ets:new(?FUNCTION_VERSION_TBL, [public, named_table]),
    ets:new(?FUNCTION_CALENDAR_TBL, [public, named_table]),
    ok.
insert(function_version, Key, Pid)->
    ets:insert(?FUNCTION_VERSION_TBL, {Key, Pid});
insert(function_calendar, Key, Pid)->
    ets:insert(?FUNCTION_CALENDAR_TBL, {Key, Pid}).

lookup (function_version, Key) ->
    case ets:lookup(?FUNCTION_VERSION_TBL, Key) of 
	[{Key, Pid}] ->
	     {ok, Pid};
	[] -> {error, not_found}
    end;
lookup (function_calendar, Key) ->
    case ets:lookup(?FUNCTION_CALENDAR_TBL, Key) of 
	[{Key, Pid}] ->
	     {ok, Pid};
	[] -> {error, not_found}
    end.

delete(function_version, Pid) ->
    ets:delete(?FUNCTION_VERSION_TBL, {'_', Pid});
delete(function_calendar, Pid) ->
    ets:delete(?FUNCTION_CALENDAR_TBL, {'_', Pid}).


