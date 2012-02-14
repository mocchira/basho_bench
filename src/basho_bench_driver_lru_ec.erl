%% -------------------------------------------------------------------
%%
%% basho_bench: Benchmarking Suite
%%
%% Copyright (c) 2009-2010 Basho Techonologies
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.    
%%
%% -------------------------------------------------------------------
-module(basho_bench_driver_lru_ec).

-export([new/1,
         run/4]).

-include("basho_bench.hrl").

%% ====================================================================
%% API
%% ====================================================================

new(Id) ->
    	application:start(ecache_app),
	case Id of
		1 ->
			% do print status
			{ok, true};
		_Other ->
			{ok, false}
	end.

run(get, KeyGen, _ValueGen, Table) ->
    Key = KeyGen(),
    LKey = integer_to_list(Key),
    case ecache_server:get(LKey) of
        undefined ->
            {ok, Table};
        _Val ->
            {ok, Table}
    end;
run(put, KeyGen, ValueGen, DoPrint) ->
    case DoPrint of
        true ->
            print_status(10000);
        false ->
            none
    end,
    Key = KeyGen(),
    LKey = integer_to_list(Key),
    ecache_server:set(LKey, ValueGen()),
    {ok, DoPrint};
run(delete, KeyGen, _ValueGen, Table) ->
    Key = KeyGen(),
    LKey = integer_to_list(Key),
    ecache_server:delete(LKey),
    {ok, Table}.

print_status(Count) ->
    status_counter(Count, fun() ->
                               S = ecache_server:stats(),
                               io:format("~p\n", [S])
                       end).

status_counter(Max, Fun) ->
    Curr = case erlang:get(status_counter) of
               undefined ->
                   -1;
               Value ->
                   Value
           end,
    Next = (Curr + 1) rem Max,
    erlang:put(status_counter, Next),
    case Next of
        0 -> Fun(), ok;
        _ -> ok
    end.    
