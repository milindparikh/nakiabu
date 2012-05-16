-module(fcc_function_version_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/4]).
-export([init/1]).
-define(SERVER, ?MODULE).


start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(FunctionVersionName, StartDate, EndDate, SourceCode) ->
    supervisor:start_child(?SERVER, [FunctionVersionName, 
				     StartDate, 
				     EndDate, 
				     SourceCode]).

init([]) ->
    
    Element = {fcc_function_version_element, {fcc_function_version_element, start_link, []},
	       temporary, brutal_kill, worker, [fcc_function_version_element]},
    Children = [Element],
    RestartStrategy = {simple_one_for_one, 0,1},
    {ok, {RestartStrategy, Children}}.
