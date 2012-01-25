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
-module(basho_bench_driver_lru_ets).

-export([new/1,
         run/4]).

-include("basho_bench.hrl").

%% ====================================================================
%% API
%% ====================================================================

new(_Id) ->
    Table = etscache:new(1000000),
    {ok, Table}.

run(get, KeyGen, _ValueGen, Table) ->
    Key = KeyGen(),
    case etscache:get(Table, Key) of
        not_found ->
            {ok, Table};
        {ok, _Val} ->
            {ok, Table}
    end;
run(put, KeyGen, ValueGen, Table) ->
    etscache:put_new(Table, KeyGen(), ValueGen()),
    {ok, Table};
run(delete, _KeyGen, _ValueGen, Table) ->
    %ets:delete(Table, KeyGen()),
    {ok, Table}.
    
