(* open Yojson
open Yojson.Safe
open Yojson.Basic.Util *)

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

type turing_machine = {
  name: string;
  alphabet: string list;
  blank: string;
  states: string list;
  initial: string;
  finals: string list;
  transitions: (turing_machine_transition list) TransitionMap.t;
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

let tmr: turing_machine = {
  name = "unary_sub";
	alphabet = [ "1"; "."; "-"; "=" ];
  blank = ".";
	states = [ "scanright"; "eraseone"; "subone"; "skip"; "HALT" ];
  initial = "scanright";
  finals = [ "HALT" ];
  transitions = tras;
}
