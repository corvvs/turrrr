(* quadratic.ml: 2次方程式 ax^2 + bx + c = 0 *)
(* 自乗 *)
let square(x) = x *. x
(* 判別式 *)
let discriminant(a, b, c) = square(b) -. 4.0 *. a *. c
(* 解の公式 *)
let quadratic1(a, b, c) = (-. b +. sqrt(discriminant(a,b,c))) /. (2.0 *. a)
let quadratic2(a, b, c) = (-. b -. sqrt(discriminant(a,b,c))) /. (2.0 *. a)