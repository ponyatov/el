// For more information see https://aka.ms/fsharp-console-apps

type Expr =
    | Atom of string
    | Str of string
    | Int of int

type Stmt =
    | Assign of string * Expr
    | Nop
    | Halt

open System.IO
open FSharp.Text.Lexing
open Lexer
open Parser

let evaluate (input:string) =
  let lexbuf = LexBuffer<char>.FromString input
  let output = Parser.parse Lexer.tokenize lexbuf
  string output

[<EntryPoint>]
let main (argv:string array) =

    for arg in argv do
        let pcb = File.ReadAllText arg
        // printfn "%s" pcb[0..47]
        try
            let result = evaluate pcb
            printfn "%s" result
        with ex -> printfn "%s" (ex.ToString())

    0 // return an integer exit code
