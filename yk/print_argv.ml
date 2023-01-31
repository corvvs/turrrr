(* argvの1つ目以外を出力 *)
(List.iter print_endline) (match (Array.to_list Sys.argv) with
  | []    -> []
  | s::ss -> ss)
