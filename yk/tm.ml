open Yojson
open Yojson.Safe
open Yojson.Basic.Util


type turing_machine_transition = {
  read: string;
  to_state: string;
  write: string;
  action: string; (* 本当は LEFT | RIGHT でコンストラクタを使うべき *)
}

(* Map.Make(some_type) は, **some_typeをキーとする**空のMapを作る. *)
(* some_typeをバリューとするわけではない!!! *)
(* バリューがなんなのかは値を入れるまで確定しない. *)
module TransitionMap = Map.Make(String)

type transitions = (turing_machine_transition list) TransitionMap.t

type turing_machine = {
  name: string;
  alphabet: string list;
  blank: string;
  states: string list;
  initial: string;
  finals: string list;
  transitions: transitions;
}

let tras = TransitionMap.empty
    |> TransitionMap.add "scanright" [
    { read = "."; to_state = "scanright"; write = "."; action = "RIGHT"};
    { read = "1"; to_state = "scanright"; write = "1"; action = "RIGHT"};
    { read = "-"; to_state = "scanright"; write = "-"; action = "RIGHT"};
    { read = "="; to_state = "eraseone" ; write = "."; action = "LEFT" }
  ] |> TransitionMap.add "eraseone" [
    { read = "1"; to_state = "subone"; write = "="; action = "LEFT"};
    { read = "-"; to_state = "HALT"; write = "."; action = "LEFT"}
  ] |> TransitionMap.add "subone" [
    { read = "1"; to_state = "subone"; write = "1"; action = "LEFT"};
    { read = "-"; to_state = "skip"; write = "-"; action = "LEFT"}
  ] |> TransitionMap.add "subone" [
    { read = "."; to_state = "skip"; write = "."; action = "LEFT"};
    { read = "1"; to_state = "scanright"; write = "."; action = "RIGHT"}
  ]

(* JSONの "transitions" の部分を受け取り, それを transitions 型の値に変換する *)
let to_transitions json_transitions: transitions = json_transitions
    (* まず連想リストに変換 *)
    |> to_assoc
    (* 連想リストの各要素を順番に空の transitions に add していく. *)
    |> List.fold_left (
        (* transitions と 状態/リスト のペアを受け取り, リストを turing_machine_transition に変換して add する関数. *)
        (* 第2引数はタプルだが, それをマッチングで分解している *)
        fun tras (state_from, json_transition_list) ->
            to_list json_transition_list
            (* 1つの遷移 turing_machine_transition に対応する JSON を受け取り, turing_machine_transition に変換する *)
            |> List.map (fun json_transition: turing_machine_transition -> {
              read      = member "read"     json_transition |> to_string;
              to_state  = member "to_state" json_transition |> to_string;
              write     = member "write"    json_transition |> to_string;
              action    = member "action"   json_transition |> to_string
            })
            (* (fun f a b c -> f a c b) は, 3引数関数の第2引数と第3引数を入れ替えるもの *)
            (* TransitionMap.add は第2引数が追加されるvalueだが, これを第3引数におきたい. *)
            |> (fun f a b c -> f a c b) TransitionMap.add state_from tras
      ) (TransitionMap.empty: transitions)

let create_tm (json: Yojson.Basic.t) = {
  name = member "name" json
    |> to_string;
  alphabet = member "alphabet" json
    |> to_list
    |> List.map to_string;
  blank = member "blank" json
    |> to_string;
  states = member "states" json
    |> to_list
    |> List.map to_string;
  initial = member "initial" json
    |> to_string;
  finals = member "finals" json
    |> to_list
    |> List.map to_string;
  transitions = member "transitions" json
    |> to_transitions
}

(* let tmr: turing_machine = {
  name = "unary_sub";
	alphabet = [ "1"; "."; "-"; "=" ];
  blank = ".";
	states = [ "scanright"; "eraseone"; "subone"; "skip"; "HALT" ];
  initial = "scanright";
  finals = [ "HALT" ];
  transitions = tras;
} *)
