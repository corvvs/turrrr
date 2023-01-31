let rec gcd x y = match (x, y) with
  | _ when x < y  -> gcd y x
  | (a,0)         -> a
  | _             -> gcd y (x mod y)
;;

let _ = print_int (gcd 5 42)
