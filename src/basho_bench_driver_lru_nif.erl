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
-module(basho_bench_driver_lru_nif).

-export([new/1,
         run/4]).

-include("basho_bench.hrl").

%% ====================================================================
%% API
%% ====================================================================

new(_Id) ->
    Table = cherly:start(1024 * 1024 * 200),
    {ok, Table}.

run(get, KeyGen, _ValueGen, Table) ->
    Key = KeyGen(),
    LKey = integer_to_list(Key),
    case cherly:get(Table, LKey) of
        none ->
            {ok, Table};
        _Val ->
            {ok, Table}
    end;
run(put, KeyGen, ValueGen, Table) ->
    Key = KeyGen(),
    LKey = integer_to_list(Key),
    cherly:put(Table, LKey, ValueGen()),
    {ok, Table};
run(delete, KeyGen, _ValueGen, Table) ->
    Key = KeyGen(),
    LKey = integer_to_list(Key),
    cherly:remove(Table, LKey),
    {ok, Table}.
    
