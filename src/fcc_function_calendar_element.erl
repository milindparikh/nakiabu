-module(fcc_function_calendar_element).
-behaviour(gen_server).
-export([start_link/2, create/2, addversion/2, getversion/1]).
-export([init/1, terminate/2, code_change/3, handle_call/3, handle_cast/2, handle_info/2]).

-define(SERVER, ?MODULE).
-record(state, {genericfunctionanddate, version}).


start_link(GenericFunctionAndDate, Version) ->
    gen_server:start_link(?MODULE, [GenericFunctionAndDate, 
				    Version
				    ], []).

create(GenericFunctionAndDate, Version) ->
    fcc_function_calendar_sup:start_child(GenericFunctionAndDate, Version
					).

addversion(Pid,Version)-> 
    gen_server:cast(Pid, {addversion, Version}).
getversion(Pid) ->
    gen_server:call(Pid, getversion).



init([GenericFunctionAndDate, Version]) ->
    {ok,
     #state {
       genericfunctionanddate = GenericFunctionAndDate,
       version = [Version]
      }}.


handle_call(getversion, _From, State) ->
    #state{version = Version} = State,
    {reply, {ok, Version}, State}.

handle_cast({addversion, Version}, #state{version = CurVersion} = State) ->
    
    NewVersion = [Version|CurVersion],
    {noreply, State#state{version = NewVersion}}.


handle_info(timeout, State ) ->
    {stop, normal, State}.

terminate(_Reason, _State) ->
    fcc_store:delete(self()),
    ok.
code_change(_OldVsn, State, _NewVsn) ->
    {ok, State}.

