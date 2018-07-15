(*
New York is laid out in the Grid. Vertical and horizontal streets. Precise,
robotic, prosaic, mechanical. New Yorkers speak in coordinates, not
intersections: it's the corner of 14th and 7th. No more, no less.
*)

datatype SVG =
      goto of int * int
    | line of int * int

(*
But then there's Broadway, the street that flagrantly defies its rectilinear
framework, the street that careens recklessly across Manhattan like a little
kid on a bicycle.
*)

datatype step = m12 | m2 | m4 | m6 | m8 | m10
type path = step list

datatype move = l | ll | r | rr | u | s
type trip  = move list

(*
I love walking down Broadway. There's always something to see, something to
hear. It changes every day, and yet it's the same.
*)

fun wrap_svg_path (str : string) (xy : (real * real)) : string =
    "<path d=\"M " ^ (Real.toString (#1 xy)) ^ " " ^ (Real.toString (#2 xy)) ^
    " " ^ str ^ "\" stroke=\"black\" fill=\"transparent\"/>" ^ "\n"

fun wrap_svg_all (strs : string list) (wh : (int * int)) : string =
    "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" ^
    "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" " ^
    "width=\"" ^ (Int.toString (#1 wh)) ^
    "\" height=\"" ^ (Int.toString (#2 wh)) ^ "\">\n" ^
    (String.concatWith "\n" strs) ^
    "</svg>\n"

(*
Sometimes I walk down Broadway with a purpose, to get from Point A to Point B.
But sometimes I don't. Broadway encourages you to wander off it, to turn a
particularly compelling corner and wonder what you'll find. Broadway is a
supermarket with unlabeled aisles.
*)

fun path_of_trip (t : trip) (dir : int) : path =
    case t of
        [] => []
      | s::ts =>
        (List.nth ([m12, m2, m4, m6, m8, m10], dir mod 6))
            :: (path_of_trip ts dir)
      | l::ts => path_of_trip ts (dir - 1)
      | ll::ts => path_of_trip ts (dir - 2)
      | r::ts => path_of_trip ts (dir + 1)
      | rr::ts => path_of_trip ts (dir + 2)
      | u::ts => path_of_trip ts (dir + 3)

fun svg_of_step (m : step) : string =
    case m of
        m12 => "l 0 -10"
      | m2  => "l 8.66025 -5"
      | m4  => "l 8.66025 5"
      | m6  => "l 0 10"
      | m8  => "l -8.66025 5"
      | m10 => "l -8.66025 -5"

fun svg_of_path (p : path) : string =
    case p of
        [] => ""
      | m::[] => svg_of_step m
      | m::ms => (svg_of_step m) ^ " " ^ (svg_of_path ms)

fun svg_of_trip (t : trip) (dir : int) : string =
    svg_of_path (path_of_trip t dir)

(*
There is a lesson to be learned here, I think.
*)

fun snowflake (n : int) : trip =
    case n of
        0 => [s]
      | _ =>
        let val mu = (snowflake (n-1)) in
            mu @ [l] @ mu @ [rr] @ mu @ [l] @ mu
        end

(*
We spend our lives on the Grid; no, within it. Quiet, meticulous, prudent. "I
have measured out my life with coffee spoons," laments Prufrock. Coffee?
Perhaps. Perhaps just ground-up dollar bills filtered through time.
*)

fun invert_trip (t : trip) =
    case t of
        [] => []
      | s ::rest => (invert_trip rest) @ [s ]
      | l ::rest => (invert_trip rest) @ [r ]
      | ll::rest => (invert_trip rest) @ [rr]
      | r ::rest => (invert_trip rest) @ [l ]
      | rr::rest => (invert_trip rest) @ [ll]
      | u ::rest => (invert_trip rest) @ [u ]

val alpha  = [s, s, s, ll, s, r, s, rr, s, l, s, rr, s, ll, s, s, s] (* cup *)
val alpha' = invert_trip alpha

val beta   = List.rev [s, s, s, rr, s, ll, s, l, s, l, s, rr, s, r, s, l, s, s] (* chevron *)
val beta'  = invert_trip beta

val gamma  = [s, s, s, ll, s, r, s, r, s, r, s, r, s, ll, s, s, s]
val gamma' = invert_trip gamma

val delta  = [s, s, s, ll, s, r, s, rr, s, ll, s, rr, s, r, s, ll, s, s, s]
val delta' = invert_trip delta

val omega  = List.rev [s, r, s, ll, s, r, s, rr, s, ll, s, l, s, l, s, rr, s, r, s, l, l, s, rr, s, l, s]
val omega' = invert_trip omega

val kappa  = [s, l, s, rr, s, l, s, ll, s, r, s, rr, s, ll, s, rr, s, r, s, ll, s, r, s, ll, s, r, s]
val kappa' = invert_trip kappa

val theta = [s, s, s, s, s, s, s]

(*
We don't have the space to careen through this world like the reckless,
evanescant creatures that we are. Our aisles are labeled: "bread" or "cereal"
or "career" or "expectations."
*)

val edges = [omega, omega', omega]
val current_edge_idx = ref 0

fun next_edge (edge : bool) =
    ((current_edge_idx := (!current_edge_idx + 1) mod (length edges)) ;
    if edge then theta else List.nth (edges, !current_edge_idx))

fun make_truss_bottom (width : int) (edge : bool) : trip =
    case width of
        0 => (next_edge edge) @ [ll] @ (next_edge true)
      | _ => (next_edge edge)
           @ [ll]
           @ (next_edge false)
           @ [rr]
           @ (next_edge false)
           @ [rr]
           @ (next_edge false)
           @ [ll]
           @ (make_truss_bottom (width - 1) edge)

fun make_truss_top (width : int) (edge : bool) : trip =
    case width of
        0 => (next_edge false) @ [rr]
      | _ => (next_edge edge)
           @ [ll]
           @ (next_edge false)
           @ [rr]
           @ (make_truss_top (width - 1) false)

fun make_truss (width : int) (edge : bool) : trip =
    (make_truss_bottom (width * 2) edge) @ (make_truss_top (width * 2 - 1) true)

fun make_triangle' (size : int) (edge : bool) : trip =
    case size of
        0 => (make_truss_bottom 0 false)
      | _ => (make_truss size edge) @ (make_triangle' (size - 1) false)

fun make_wall (size : int) : trip =
    case size of
        0 => theta @ [ll]
      | _ => theta @ theta @ (make_wall (size - 1))

fun make_triangle (size : int) : trip =
    (make_wall size) @ (make_triangle' size true)

(*
And I worry, I worry that that's all there is, that there is no more room for
enchantment, that there are no Broadways through life, only the Grid.
*)

val puzzle = make_triangle 3

val svg = (wrap_svg_all [
    (wrap_svg_path (svg_of_trip puzzle 3) (10.0, 10.0))
] (500, 500))

val fd = TextIO.openOut "triangle3.svg"
val w = TextIO.output (fd, svg) handle e => (TextIO.closeOut fd; raise e)
val x = TextIO.closeOut fd

(*
And thus, this puzzle.
*)
