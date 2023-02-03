open Yojson
open Yojson.Safe
open Yojson.Basic.Util

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

let _ = if argv_len < 2 then (
  (* usage 表示 *)
  argv_list
    |> List.hd
    |> Printf.printf "usage: %s [some file]\n"
) else (
  (* argv[1] の中身を表示 *)
  let json = json_from_path (List.hd (List.tl argv_list)) in json
    |> Yojson.Safe.to_basic
    |> member "name" (* Basic にしてから member でフィールド選択 *)
    |> Format.printf "Parsed to %a\n" Yojson.Basic.pp

)
