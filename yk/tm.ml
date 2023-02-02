(* open Yojson
open Yojson.Safe
open Yojson.Basic.Util *)

type turing_machine_transition = {
  read: string;
  to_state: string;
  write: string;
  action: string; (* 本当は LEFT | RIGHT でコンストラクタを使うべき *)
}

module TransitionPair = 
  struct
    type key = string
    type t = turing_machine_transition
    let compare x y = Stdlib.compare x y
  end

module TransitionMap = Map.Make(TransitionPair)

type turing_machine = {
  name: string;
  alphabet: string list;
  blank: string;
  states: string list;
  initial: string;
  finals: string list;
  transitions: TransitionMap.key TransitionMap.t;
}

let tmr: turing_machine = {
  name = "unary_sub";
	alphabet = [ "1"; "."; "-"; "=" ];
  blank = ".";
	states = [ "scanright"; "eraseone"; "subone"; "skip"; "HALT" ];
  initial = "scanright";
  finals = [ "HALT" ];
  transitions = TransitionMap.empty;
}
