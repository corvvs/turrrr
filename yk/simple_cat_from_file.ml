let read_line_from_ch ch = try [input_line ch] with End_of_file -> []

let rec collect_lines_from_ch ch ls = match read_line_from_ch ch with
  | [] -> ls
  | x::_ -> collect_lines_from_ch ch (x :: ls)

let iter_file_lines path proc = close_in (let ch = (open_in path) in proc ch; ch)

(* ocaml ではリストに対する push back 操作は推奨されない. *)
(* そのかわり, push front した後で前後反転する. *)
let print_lines ls = List.iter print_endline (List.rev ls)

(* ch に対して何かをする *)
let do_for_ch ch = print_lines (collect_lines_from_ch ch [])

let argv_list = (Array.to_list Sys.argv)
let argv_len = List.length argv_list
let _ = if argv_len < 2 then (
  (* usage 表示 *)
  Printf.printf "usage: %s [some file]\n" (List.hd argv_list)
) else (
  (* argv[1] の中身を表示 *)
  iter_file_lines (List.hd (List.tl argv_list)) do_for_ch
)
