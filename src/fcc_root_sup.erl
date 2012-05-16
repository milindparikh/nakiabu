-module(fcc_root_sup).
-behaviour(supervisor).

%% API 
-export([start_link/0]).
%% Supcb 
-export([init/1]).

-define (SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    FunctionCalendarSup = {fcc_function_calendar_sup, {fcc_function_calendar_sup, start_link, []}, permanent, 2000, supervisor, [fcc_function_calendar_sup]},

    FunctionVersionSup = {fcc_function_version_sup, {fcc_function_version_sup, start_link, []}, permanent, 2000, supervisor, [fcc_function_version_sup]},

    
    Children = [FunctionCalendarSup,FunctionVersionSup ],
    RestartStrategy = {one_for_one, 4, 3600},
    {ok, {RestartStrategy, Children}}.

