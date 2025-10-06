-module(cell_ffi).
-export([
    new_table/0, write/3, read/2, empty/2, drop/1
]).

new_table() ->
    ets:new(ethos_table, [set, public]).

read(Table, Key) ->
    try ets:lookup(Table, Key) of
        [{_, Item}] -> {ok, Item};
        _ -> {error, nil}
    catch error:badarg -> {error, nil}
    end.

write(Table, Key, Value) ->
    try
        ets:insert(Table, {Key, Value}),
        {ok, nil}
    catch error:badarg -> {error, nil}
    end.

empty(Table, Key) ->
    try
        ets:delete(Table, Key),
        {ok, nil}
    catch error:badarg -> {error, nil}
    end.

drop(Table) ->
    try
        ets:delete(Table),
        {ok, nil}
    catch error:badarg -> {error, nil}
    end.
