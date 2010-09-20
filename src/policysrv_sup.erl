-module(policysrv_sup).
-behaviour(supervisor).

-export([init/1, start_link/0]).


start_link() ->
  supervisor:start_link(?MODULE, []).


init([]) ->
  Srv = {policysrv, {policysrv, start_link, []},
	       permanent, 2000, worker, [policysrv]},
  {ok,{{one_for_all,0,1}, [Srv]}}.
