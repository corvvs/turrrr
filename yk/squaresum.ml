let rec squaresum n = match n with
  | 0 -> 0
  | _ -> n * n + squaresum (n - 1);;

let _ = print_int (squaresum(3))
