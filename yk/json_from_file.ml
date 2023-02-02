open Yojson
open Yojson.Safe
open Yojson.Basic.Util

let read_line_from_ch ch = try [input_line ch] with End_of_file -> []

let rec collect_lines_from_ch ch ls = match read_line_from_ch ch with
  | [] -> ls
  | x::_ -> collect_lines_from_ch ch (x :: ls)

let iter_file_lines path proc = close_in (let ch = (open_in path) in proc ch; ch)

let get_file_lines path = 
  let ch = (open_in path) in
  let lines = collect_lines_from_ch ch [] in (close_in ch; lines)

(* ocaml ではリストに対する push back 操作は推奨されない. *)
(* そのかわり, push front した後で前後反転する -> List.rev *)
let print_lines ls = List.iter print_endline (List.rev ls)

(* ch に対して何かをする *)
let do_for_ch ch = print_lines (collect_lines_from_ch ch [])

let argv_list = (Array.to_list Sys.argv)
let argv_len = List.length argv_list
let _ = if argv_len < 2 then (
  (* usage 表示 *)
  (Printf.printf "usage: %s [some file]\n" (List.hd argv_list))
) else (
  (* argv[1] の中身を表示 *)
  let json = List.hd (List.tl argv_list)
    (* |> 演算子: `x |> f` とした時, x を f に適用し, その結果を返す. *)
    (* このとき x は f の「束縛されていない引数のうち最も左にあるもの」に束縛される *)
    (* たとえば, `f = fun x y -> x - y` だとすると, `1 |> f` は `fun y -> 1 - x` と等価な関数を返す. *)
    |> get_file_lines
    |> List.rev
    |> List.fold_left (fun a b -> a ^ b ^ "\n") ""
    |> from_string
  in json
    |> Yojson.Safe.to_basic
    |> member "name" (* Basic にしてから member でフィールド選択 *)
    |> Format.printf "Parsed to %a" Yojson.Basic.pp

)
