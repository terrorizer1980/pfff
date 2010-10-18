(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

open Common

open Archi_code

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(* 
 * The "inference" of the architecture category from a filename
 * used to be slow. The "parser" used to be a 'match' with a long serie
 * of '_ when f =~ ...' but it was getting really slow when
 * applied on thousands of filenames. Then we provided a fast-path
 * for files that do not match any category, but it was still slow
 * when most of the files have a category (for instance because
 * most of the files in a project are under something like lib/ or intern/).
 * Then we used ocamllex and that was fine! 
 *)

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

let is_auto_generated file =
  let (d,b,e) = Common.dbe_of_filename_noext_ok file in
  match e with
  | "ml"->
      Sys.file_exists (Common.filename_of_dbe (d,b, "mll"))
      || 
      Sys.file_exists (Common.filename_of_dbe (d,b, "mly"))
  | "mli" ->
      Sys.file_exists (Common.filename_of_dbe (d,b, "mly"))

  | "tex" ->
      Sys.file_exists (Common.filename_of_dbe (d,b ^ ".tex", "nw"))

  | "info" ->
      Sys.file_exists (Common.filename_of_dbe (d,b, "texi"))

  (* Makefile.in *)
  | "in" ->
      Sys.file_exists (Common.filename_of_dbe (d,b, "am"))

  | "c" ->
      Sys.file_exists (Common.filename_of_dbe (d,b, "y")) ||
      Sys.file_exists (Common.filename_of_dbe (d,b, "l")) ||
      (* bigloo *)
      Sys.file_exists (Common.filename_of_dbe (d,b, "scm"))
 

  | _ -> false

let re_auto_generated = Str.regexp
  ".*\\.\\(ml\\|mli\\|tex\\|info\\|in\\|c\\)"

(*****************************************************************************)
(* Filename->archi *)
(*****************************************************************************)

let _hmemo_categ_dir = Hashtbl.create 101 

(* Why taking the root ? Because if the data are in /tmp/data/soft/... then
 * you would get the rule for tmp and data :( should not consider
 * directories too far away.
 * Why not passing a readable path then ? Because most of the functions
 * in common expect full path.
 *)
let source_archi_of_filename3 ~root f = 

  let base = Filename.basename f in

  let b = "/" ^ Common.lowercase base ^ "/" in

  (* we try to give the most specialized category by first considering
   * the extension of the file, then its basename, and then its
   * directory component starting from the last one (hence the List.rev)
   *)

  let lexbuf = Lexing.from_string b in
  let categ = Archi_code_lexer.category lexbuf in

  if base ==~ re_auto_generated && is_auto_generated f
  then AutoGenerated
  else 
   if categ <> Regular
   then categ
   else
    let d = Filename.dirname f in

    (* try the directory, caching the result.
     *
     * note: should perhaps put (root, d) as the key for the memoized call
     * because when we start from a nested dir and go up, 
     * the root has changed and so what was considered Regular
     * could not be considered Intern. But then
     * when we click to go down, we can't reuse the cached
     * archi and the color may actually change which can be confusing.
     * 
     *)
    Common.memoized _hmemo_categ_dir d (fun () ->

      let d = Common.filename_without_leading_path root d in
      let d = Common.lowercase d in

      let xs = Common.split "/" d in
      let xs = List.rev xs in
      let str = "/" ^ Common.join "/" xs ^ "/" in
      
      let lexbuf = Lexing.from_string str in
      let categ = Archi_code_lexer.category lexbuf in
      categ
    )


let source_archi_of_filename ~root f = 
  Common.profile_code "Archi.source_of_filename" (fun () ->
    source_archi_of_filename3 ~root f)
