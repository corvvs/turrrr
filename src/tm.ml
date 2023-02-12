open Yojson
open Yojson.Safe
open Yojson.Basic.Util

let tx_cur = "\027[30m\027[42m"
let tx_rst = "\027[0m"
let print_width = 80
let tape_size = 40

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

type turing_machine_status = {
  state: string;
  head: int;
  tape: string array;
}

type turing_machine_definition = {
  name: string;
  alphabet: string list;
  blank: string;
  states: string list;
  initial: string;
  finals: string list;
  transitions: transitions;
}

type turing_machine = {
  definition: turing_machine_definition;
  status: turing_machine_status;
}

let stringify_tm_tape status =
  let x = status.head in
  Array.mapi (fun i a -> match i with
    | i when i == x -> (tx_cur ^ a ^ tx_rst)
    | _ -> a
  ) status.tape
  |> Array.fold_left (fun s a -> s ^ a) ""

let stringify_transition from_state transition =
  Printf.sprintf "(%s, %s) -> (%s, %s, %s)"
    from_state transition.read
    transition.to_state transition.write transition.action

let print_tm_transition def status transition =
  Printf.printf "[%s] %s\n" (stringify_tm_tape status) (stringify_transition status.state transition)


exception DefinitionError of string

(* 静的エラーのチェックに使うpredicate関数群 *)

(* 何を受け取っても unit を返す *)
let absorp a = ()

let str_must_not_be_blank error_message str = 
  if (String.length str) == 0 then raise (DefinitionError error_message) else str

let str_must_be_contained_in_list error_message list str =
  if not (List.exists (fun al -> al = str) list) then raise (DefinitionError error_message ) else str

let list_must_not_be_empty error_message list =
  if (List.length list) == 0 then raise (DefinitionError error_message) else list

let list_must_not_have_duplication error_message (list: string list) = list
  |> List.sort compare
  |> List.fold_left (fun s a -> if s = a then raise (DefinitionError error_message) else a) ""
  |> absorp; list
  




(* フィールドごとに静的エラーをチェックするvalidator関数群 *)

let validate_tm_name str = str
  |> str_must_not_be_blank "name is empty"

let validate_tm_alphabet list: string list = list
  |> list_must_not_be_empty "alphabet has no item"
  |> (List.iter
    (fun s ->
      if (String.length s) != 1
        then raise (DefinitionError ("alphabet is not a char: " ^ s))
        else ()
    )
  ); list
  |> list_must_not_have_duplication "detected duplication of `alphabet`"

let validate_tm_blank alphabet str = str
  |> str_must_not_be_blank "blank is empty"
  |> str_must_be_contained_in_list ("`alphabet` does not contain `blank`: " ^ str) alphabet

let validate_tm_states list: string list = list
  |> list_must_not_be_empty "states has no item"
  |> list_must_not_have_duplication "detected duplication of `states`"

let validate_tm_initial states str = str
  |> str_must_be_contained_in_list ("`states` does not contain `initial`: " ^ str) states

let validate_tm_finals states (list: string list): string list = list
  |> list_must_not_be_empty "finals has no item"
  |> List.iter (fun str -> (str_must_be_contained_in_list ("`states` does not contain `final`: " ^ str) states str |> absorp)); list
  |> list_must_not_have_duplication "detected duplication of `finals`"

let validate_tm_to_state alphabet states to_state = to_state
|> (fun ts -> str_must_be_contained_in_list ("`alphabet` does not contain `read`: " ^ ts.read) alphabet ts.read |> absorp; to_state)
|> (fun ts -> str_must_be_contained_in_list ("`states` does not contain `to_state`: " ^ ts.to_state) states ts.to_state |> absorp; to_state)
|> (fun ts -> str_must_be_contained_in_list ("`alphabet` does not contain `write`: " ^ ts.write) alphabet ts.write |> absorp; to_state)
|> (fun ts -> if not (ts.action = "RIGHT" || ts.action = "LEFT") then raise (DefinitionError ("action is neither LEFT nor RIGHT: " ^ ts.action)) else ts)

let validate_tm_transitions alphabet states (tras: transitions): transitions = tras
  |> TransitionMap.iter (fun key to_states ->
    str_must_be_contained_in_list ("from-state does not contain `states`: " ^ key) states key |> absorp;
    List.iter (fun to_state -> (validate_tm_to_state alphabet states to_state) |> absorp) to_states;
    (* to_states の read に重複がないことをチェック *)
    List.map (fun a -> a.read) to_states
      |> list_must_not_have_duplication "detected duplication of `read`"
      |> absorp
  );
  tras

(* 可能なら次の状態への遷移を行う *)
(* definition と status を取る *)
(* 現在状態がfinalsに含まれる場合, unitを返す *)
(* そうでない場合は新しいstatusを生成して返す *)
let get_next_staus def status =
  if
    List.exists (fun s -> s = status.state) def.finals
  then
    None
  else (
    let char = Array.get status.tape status.head in
    Printf.printf "char = |%s| %d\n" char (String.length char);
    let transition = TransitionMap.find status.state def.transitions
      |> List.find (fun transition -> (Printf.printf "read: |%s|\n" transition.read; transition.read = char)) in
    let new_tape = Array.copy status.tape in
      print_tm_transition def status transition;
      Array.set new_tape status.head transition.write;
      Some {
        state = transition.to_state;
        tape = new_tape;
        head = match transition.action with
          | "LEFT"  -> status.head - 1
          | _       -> status.head + 1
      }
  )



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

let create_tm_status (def: turing_machine_definition) (given_tape: string) = 
  let tape = Array.make tape_size def.blank in
  String.iteri (fun i c -> Array.set tape i (String.make 1 c)) given_tape;
  {
    state = def.initial;
    head = 0;
    tape = tape
  }

(* JSONデータを turing_machine に変換する *)
let create_tm (tape: string) (json: Yojson.Basic.t) =
  let blank       = member "blank" json   |> to_string in
  let initial     = member "initial" json |> to_string in
  let name        = member "name" json
    |> to_string
    |> validate_tm_name in
  let alphabet    = member "alphabet" json
    |> to_list
    |> List.map to_string
    |> validate_tm_alphabet in
  let blank       = blank
    |> validate_tm_blank alphabet in
  let states      = member "states" json
    |> to_list
    |> List.map to_string
    |> validate_tm_states in
  let initial     = initial
    |> validate_tm_initial states in
  let finals      = member "finals" json
    |> to_list
    |> List.map to_string
    |> validate_tm_finals states in
  let transitions = member "transitions" json
    |> to_transitions
    |> validate_tm_transitions alphabet states in
  {
    name = name;
    alphabet = alphabet;
    blank = blank;
    states = states;
    initial = initial;
    finals = finals;
    transitions = transitions
  } |> (fun def -> { definition = def; status = create_tm_status def tape })

(* 文字列 t に 文字列 s を n 回連結して返す *)
let rec repeat_string (s: string) (n: int) (t: string) = match n with
    | 0 -> t
    | _ -> repeat_string s (n - 1) (t ^ s)

let stringify_list (ss: string list) = List.fold_left (
  fun a b -> match a with
          | ""  -> b
          | _   -> a ^ ", " ^ b
) "" ss

let print_list_with_prefix prefix list = 
  print_endline (prefix ^ ": " ^  "[" ^ (stringify_list list) ^ "]")


let print_tm_name (tm: turing_machine_definition) = 
  let len = String.length tm.name in
  let width = len |> (fun a b -> a + b) 4 |> max (print_width - 2) in
  let wr = width / 2 in
  let wl = width - wr in
  let lenr = len / 2 in
  let lenl = len - lenr in
  List.iter print_endline [
    (repeat_string "*" (width + 2) "");
    ("*" ^ (repeat_string " " (wl - lenl) "") ^ tm.name ^ (repeat_string " " (wr - lenr) "") ^ "*");
    (repeat_string "*" (width + 2) "")
  ]

let print_tm_alphabet (tm: turing_machine_definition) =
  print_list_with_prefix "Alphabet" tm.alphabet

let print_tm_states (tm: turing_machine_definition) =
  print_list_with_prefix "States" tm.states

let print_tm_initial (tm: turing_machine_definition) =
  print_endline ("Initial: " ^ tm.initial)

let print_tm_finals (tm: turing_machine_definition) =
  print_list_with_prefix "Finals" tm.finals
  
let print_tm_transition (tm: turing_machine_definition) =
  TransitionMap.iter (fun from_state transition_list ->
    List.iter (fun transition ->
      print_endline (stringify_transition from_state transition)
    ) transition_list
  ) tm.transitions
  

let print_tm_prologue (tm: turing_machine) = 
  List.iter (fun f -> f tm.definition) [
    print_tm_name;
    print_tm_alphabet;
    print_tm_states;
    print_tm_initial;
    print_tm_finals;
    print_tm_transition
  ]; print_endline (repeat_string "*" print_width "");
  tm

(* 定義 def と初期状態 status を受け取り, 終状態を返す *)
let rec go_transition def status =
  match (get_next_staus def status) with
    | None            -> status
    | Some new_status -> go_transition def new_status



(* ch から1行読み取り, リストに入れて返す. EOF に達している場合は空のリストを返す. *)
let read_line_from_ch ch = try [input_line ch] with End_of_file -> []

(* ch の中身を行単位の逆順リストにして返す. *)
let rec collect_lines_from_ch ch ls = match read_line_from_ch ch with
  | [] -> ls
  | x::_ -> collect_lines_from_ch ch (x :: ls)

(* path で与えられたファイルから全行を読み取り, リストにして返す *)
let get_file_lines path = 
  let ch = (open_in path) in
  collect_lines_from_ch ch []
  |> (fun ls -> close_in ch; ls |> List.rev)

(* ocaml ではリストに対する push back 操作は推奨されない. *)
(* そのかわり, push front した後で前後反転する -> List.rev *)
let print_lines ls = List.iter print_endline ls

let argv_list = (Array.to_list Sys.argv)
let argv_len = List.length argv_list

(* ファイル path の中身を JSONとしてパース *)
let json_from_path path = path
  (* |> 演算子: `x |> f` とした時, x を f に適用し, その結果を返す. *)
  (* このとき x は f の「束縛されていない引数のうち最も左にあるもの」に束縛される *)
  (* たとえば, `f = fun x y -> x - y` だとすると, `1 |> f` は `fun y -> 1 - x` と等価な関数を返す. *)
  |> get_file_lines
  (* 文字列連結演算子は ^ *)
  |> List.fold_left (fun a b -> a ^ b ^ "\n") ""
  (* ここでJSONパース *)
  |> Yojson.Safe.from_string

let _ = if argv_len < 3 then (
  (* usage 表示 *)
  argv_list
    |> List.hd
    |> Printf.printf "usage: %s [JSON definition file] [tape]\n"
) else (
  (* argv[1] の中身を表示 *)
  let rest = List.tl argv_list in
  let path = List.hd rest in
  let tape = List.hd (List.tl rest) in
  try (
    (* JSONファイルを読み取る *)
    json_from_path path
      (* YoJson.Basic に変換 *)
      |> Yojson.Safe.to_basic
      (* チューリングマシンに変換 *)
      |> create_tm tape
      (* 初期表示 *)
      |> print_tm_prologue
      (* マシンを駆動 *)
      |> (fun tm -> go_transition tm.definition tm.status)
      (* 終状態を表示 *)
      |> (fun s ->
        Printf.printf "[%s]\ndone.\n" (stringify_tm_tape s)
      )
  ) with
    (* 例外を補足してエラーを表示 *)
    | DefinitionError msg -> 
      (Printf.fprintf stderr "DefinitionError: %s\n" msg; exit 1)
    | e -> let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
      (Printf.fprintf stderr "[generic error] %s\n%s\n" msg stack; exit 1)
)

