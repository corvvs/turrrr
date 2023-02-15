let i = 0

let rec loop_func (i, m, sum) =
  if i > m then i
  else loop_func (i + 1, m, sum + i)

let in_test (n) = 
  let a = 10 in 
  n + a

let break_test (flag) = 
  if flag then 10
  else
  let n = 4 in
  n

let rec fact n =
  if n = 1 then 1
  else n * fact (n - 1)

let pow_n n = 
  2. ** (float_of_int n)

let pow_n_to_int n = 
  int_of_float (2. ** (float_of_int n))

let () = print_int (loop_func (i, 10, 0)); print_newline()
let () = print_float (log (float_of_int 10)); print_newline()
let () = print_int (in_test 2); print_newline()
let () = print_string ("in_test 2"); print_newline()
let () = print_int (break_test true); print_newline()
let () = print_int (break_test false); print_newline()
let () = print_int (fact 10); print_newline()
let () = print_int (fact 11); print_newline()
let () = print_int (fact 12); print_newline()
let () = print_int (fact 13); print_newline()
let () = print_int (fact 14); print_newline()
let () = print_int (fact 15); print_newline()
let () = print_int (fact 16); print_newline()
let () = print_int (fact 17); print_newline()
let () = print_int (fact 18); print_newline()
let () = print_int (fact 19); print_newline()
let () = print_int (fact 20); print_newline()
let () = print_float (pow_n 40); print_newline()
let () = print_int (pow_n_to_int 40); print_newline()
