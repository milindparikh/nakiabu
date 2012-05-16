-module(fcc_function_calendar_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/2]).
-export([init/1]).
-define(SERVER, ?MODULE).


start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(GenericFunctionAndDate, Version) ->
    supervisor:start_child(?SERVER, [GenericFunctionAndDate, 
				     Version]).

init([]) ->
    
    Element = {fcc_function_calendar_element, {fcc_function_calendar_element, start_link, []},
	       temporary, brutal_kill, worker, [fcc_function_calendar_element]},
    Children = [Element],
    RestartStrategy = {simple_one_for_one, 0,1},
    {ok, {RestartStrategy, Children}}.
