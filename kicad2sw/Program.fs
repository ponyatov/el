// For more information see https://aka.ms/fsharp-console-apps

type Expr =
    | Atom of string
    | Str of string
    | Int of int

printfn "Hello"
