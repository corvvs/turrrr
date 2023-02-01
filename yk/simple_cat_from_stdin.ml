(* open Yojson *)

let read_line _ = try [read_line ()] with End_of_file -> []

let rec collect_lines ls = match read_line () with
  | [] -> ls
  | x::_ -> collect_lines (x :: ls)

(* ocaml ではリストに対する push back 操作は推奨されない. *)
(* そのかわり, push front した後で前後反転する. *)
let _ = (List.iter print_endline) (List.rev (collect_lines []))
