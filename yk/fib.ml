let rec fib n = match n with
  | _ when n <= 1 -> n
  | _             -> fib(n - 1) + fib(n - 2)
;;

let _ = print_int (fib(6))
