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

(* mostly autogenerated by ocamltarzan: ocamltarzan -choice vof ast_js.ml *)

(* pad: I've added a few tweaks because of module limitations in ocamltarzan *)

open Cst_js
module Ast = Cst_js

module MPI = Meta_parse_info

let rec vof_info x = Meta_parse_info.vof_info_adjustable_precision x
and vof_tok v = vof_info v
and vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 and v2 = vof_info v2 in OCaml.VTuple [ v1; v2 ]
and vof_paren _of_a (v1, v2, v3) =
  if !MPI._current_precision.MPI.token_info then
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in OCaml.VTuple [ v1; v2; v3 ]
  else _of_a v2
and vof_brace _of_a (v1, v2, v3) =
  if !MPI._current_precision.MPI.token_info then
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in OCaml.VTuple [ v1; v2; v3 ]
  else _of_a v2
and vof_bracket _of_a (v1, v2, v3) =
  if !MPI._current_precision.MPI.token_info then
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in OCaml.VTuple [ v1; v2; v3 ]
  else _of_a v2
and vof_angle _of_a (v1, v2, v3) =
  let v1 = vof_tok v1
  and v2 = _of_a v2
  and v3 = vof_tok v3
  in OCaml.VTuple [ v1; v2; v3 ]
and vof_comma_list _of_a xs =
  if !MPI._current_precision.MPI.token_info
  then OCaml.vof_list (OCaml.vof_either _of_a vof_tok) xs
  else OCaml.vof_list _of_a (Ast.uncomma xs)

and vof_sc v = OCaml.vof_option vof_tok v

let vof_name v = vof_wrap OCaml.vof_string v
let vof_module_path v = vof_wrap OCaml.vof_string v

let rec vof_expr =
  function
  | L v1 -> let v1 = vof_litteral v1 in OCaml.VSum (("L", [ v1 ]))
  | V v1 -> let v1 = vof_name v1 in OCaml.VSum (("V", [ v1 ]))
  | Ellipsis v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Ellipsis", [ v1 ]))
  | DeepEllipsis v1 -> let v1 = vof_bracket vof_expr v1 in 
      OCaml.VSum (("DeepEllipsis", [ v1 ]))
  | This v1 -> let v1 = vof_tok v1 in OCaml.VSum (("This", [ v1 ]))
  | Super v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Super", [ v1 ]))
  | NewTarget ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = vof_tok v3
      in OCaml.VSum (("NewTarget", [ v1; v2; v3 ]))
  | U ((v1, v2)) ->
      let v1 = vof_wrap vof_unop v1
      and v2 = vof_expr v2
      in OCaml.VSum (("U", [ v1; v2 ]))
  | B ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_binop v2
      and v3 = vof_expr v3
      in OCaml.VSum (("B", [ v1; v2; v3 ]))
  | Bracket ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_bracket vof_expr v2
      in OCaml.VSum (("Bracket", [ v1; v2 ]))
  | Period ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_name v3
      in OCaml.VSum (("Period", [ v1; v2; v3 ]))
  | Object v1 ->
      let v1 =
        vof_brace
          (vof_comma_list
             (function
             | P_field (v1, v2, v3) ->
                 let v1 = vof_property_name v1
                 and v2 = vof_tok v2
                 and v3 = vof_expr v3
                 in OCaml.VSum (("P_field", [ v1; v2; v3 ]))
             | P_method v1 ->
                 let v1 = vof_func_decl v1
                 in OCaml.VSum (("P_method", [v1]))
             | P_shorthand v1 ->
              let v1 = vof_name v1 in OCaml.VSum (("P_shorthand", [ v1 ]))
             | P_spread (v1, v2) ->
                 let v1 = vof_tok v1 in
                 let v2 = vof_expr v2 in
                 OCaml.VSum (("P_spread", [v1;v2]))
             ))
          v1
      in OCaml.VSum (("Object", [ v1 ]))
  | Array v1 ->
      let v1 = vof_bracket (vof_comma_list vof_expr) v1
      in OCaml.VSum (("Array", [ v1 ]))
  | Apply ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_paren (vof_comma_list vof_expr) v2
      in OCaml.VSum (("Apply", [ v1; v2 ]))
  | Conditional ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      and v4 = vof_tok v4
      and v5 = vof_expr v5
      in OCaml.VSum (("Conditional", [ v1; v2; v3; v4; v5 ]))
  | Assign ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_assignment_operator v2
      and v3 = vof_expr v3
      in OCaml.VSum (("Assign", [ v1; v2; v3 ]))
  | Seq ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in OCaml.VSum (("Seq", [ v1; v2; v3 ]))
  | Function v1 ->
      let v1 = vof_func_decl v1 in OCaml.VSum (("Function", [ v1 ]))
  | Class v1 -> let v1 = vof_class_decl v1 in OCaml.VSum (("Class", [ v1 ]))
  | Arrow v1 -> let v1 = vof_arrow_func v1 in OCaml.VSum (("Arrow", [ v1 ]))
  | Paren v1 ->
      let v1 = vof_paren vof_expr v1 in OCaml.VSum (("Paren", [ v1 ]))
  | XhpHtml v1 ->
      let v1 = vof_xhp_html v1 in OCaml.VSum (("XhpHtml", [ v1 ]))
  | TemplateString ((v1, (v2, v3, v4))) ->
      let v1 = OCaml.vof_option vof_expr v1
      and v2 = vof_tok v2
      and v3 = OCaml.vof_list vof_encaps v3
      and v4 = vof_tok v4
      in OCaml.VSum (("Encaps", [ v1; v2; v3; v4 ]))
  | Yield ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = OCaml.vof_option vof_tok v2
      and v3 = OCaml.vof_option vof_expr v3
      in OCaml.VSum (("Yield", [ v1; v2; v3 ]))
  | Await ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      in OCaml.VSum (("Await", [ v1; v2 ]))

and vof_litteral =
  function
  | Bool v1 ->
      let v1 = vof_wrap OCaml.vof_bool v1 in OCaml.VSum (("Bool", [ v1 ]))
  | Num v1 ->
      let v1 = vof_wrap OCaml.vof_string v1 in OCaml.VSum (("Num", [ v1 ]))
  | String v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("String", [ v1 ]))
  | Regexp v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("Regexp", [ v1 ]))
  | Null v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Null", [ v1 ]))
and vof_unop =
  function
  | U_new -> OCaml.VSum (("U_new", []))
  | U_delete -> OCaml.VSum (("U_delete", []))
  | U_void -> OCaml.VSum (("U_void", []))
  | U_typeof -> OCaml.VSum (("U_typeof", []))
  | U_bitnot -> OCaml.VSum (("U_bitnot", []))
  | U_pre_increment -> OCaml.VSum (("U_pre_increment", []))
  | U_pre_decrement -> OCaml.VSum (("U_pre_decrement", []))
  | U_post_increment -> OCaml.VSum (("U_post_increment", []))
  | U_post_decrement -> OCaml.VSum (("U_post_decrement", []))
  | U_plus -> OCaml.VSum (("U_plus", []))
  | U_minus -> OCaml.VSum (("U_minus", []))
  | U_not -> OCaml.VSum (("U_not", []))
  | U_spread -> OCaml.VSum (("U_spread", []))
and vof_binop =
  function
  | B_instanceof -> OCaml.VSum (("B_instanceof", []))
  | B_in -> OCaml.VSum (("B_in", []))
  | B_mul -> OCaml.VSum (("B_mul", []))
  | B_expo -> OCaml.VSum (("B_expo", []))
  | B_div -> OCaml.VSum (("B_div", []))
  | B_mod -> OCaml.VSum (("B_mod", []))
  | B_add -> OCaml.VSum (("B_add", []))
  | B_sub -> OCaml.VSum (("B_sub", []))
  | B_le -> OCaml.VSum (("B_le", []))
  | B_ge -> OCaml.VSum (("B_ge", []))
  | B_lt -> OCaml.VSum (("B_lt", []))
  | B_gt -> OCaml.VSum (("B_gt", []))
  | B_lsr -> OCaml.VSum (("B_lsr", []))
  | B_asr -> OCaml.VSum (("B_asr", []))
  | B_lsl -> OCaml.VSum (("B_lsl", []))
  | B_equal -> OCaml.VSum (("B_equal", []))
  | B_notequal -> OCaml.VSum (("B_notequal", []))
  | B_physequal -> OCaml.VSum (("B_physequal", []))
  | B_physnotequal -> OCaml.VSum (("B_physnotequal", []))
  | B_bitand -> OCaml.VSum (("B_bitand", []))
  | B_bitor -> OCaml.VSum (("B_bitor", []))
  | B_bitxor -> OCaml.VSum (("B_bitxor", []))
  | B_and -> OCaml.VSum (("B_and", []))
  | B_or -> OCaml.VSum (("B_or", []))
and vof_property_name =
  function
  | PN_Id v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("PN_Id", [ v1 ]))
  | PN_String v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("PN_String", [ v1 ]))
  | PN_Num v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("PN_Num", [ v1 ]))
  | PN_Computed v1 ->
      let v1 = vof_bracket vof_expr v1
      in OCaml.VSum (("PN_Computed", [ v1 ]))
and vof_assignment_operator =
  function
  | A_eq -> OCaml.VSum (("A_eq", []))
  | A_mul -> OCaml.VSum (("A_mul", []))
  | A_div -> OCaml.VSum (("A_div", []))
  | A_mod -> OCaml.VSum (("A_mod", []))
  | A_add -> OCaml.VSum (("A_add", []))
  | A_sub -> OCaml.VSum (("A_sub", []))
  | A_lsl -> OCaml.VSum (("A_lsl", []))
  | A_lsr -> OCaml.VSum (("A_lsr", []))
  | A_asr -> OCaml.VSum (("A_asr", []))
  | A_and -> OCaml.VSum (("A_and", []))
  | A_xor -> OCaml.VSum (("A_xor", []))
  | A_or -> OCaml.VSum (("A_or", []))
and vof_xhp_tag x = OCaml.vof_string x
and vof_xhp_html =
  function
  | Xhp ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_wrap vof_xhp_tag v1
      and v2 = OCaml.vof_list vof_xhp_attribute v2
      and v3 = vof_tok v3
      and v4 = OCaml.vof_list vof_xhp_body v4
      and v5 = vof_wrap (OCaml.vof_option vof_xhp_tag) v5
      in OCaml.VSum (("Xhp", [ v1; v2; v3; v4; v5 ]))
  | XhpSingleton ((v1, v2, v3)) ->
      let v1 = vof_wrap vof_xhp_tag v1
      and v2 = OCaml.vof_list vof_xhp_attribute v2
      and v3 = vof_tok v3
      in OCaml.VSum (("XhpSingleton", [ v1; v2; v3 ]))
and vof_xhp_attribute =
  function
  | XhpAttrValue ((v1, v2, v3)) ->
      let v1 = vof_xhp_attr_name v1
      and v2 = vof_tok v2
      and v3 = vof_xhp_attr_value v3
      in OCaml.VSum (("XhpAttrValue", [ v1; v2; v3 ]))
  | XhpAttrNoValue ((v1)) ->
      let v1 = vof_xhp_attr_name v1
      in OCaml.VSum (("XhpAttrNoValue", [ v1 ]))
  | XhpAttrSpread v1 ->
      let v1 =
        vof_brace
          (fun (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_expr v2
             in OCaml.VTuple [ v1; v2 ])
          v1
      in OCaml.VSum (("XhpAttrSpread", [ v1 ]))
and vof_xhp_attr_name v = vof_wrap OCaml.vof_string v
and vof_xhp_attr_value =
  function
  | XhpAttrString v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("XhpAttrString", [ v1 ]))
  | XhpAttrExpr v1 ->
      let v1 = vof_brace vof_expr v1 in OCaml.VSum (("XhpAttrExpr", [ v1 ]))
and vof_xhp_body =
  function
  | XhpText v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("XhpText", [ v1 ]))
  | XhpExpr v1 ->
      let v1 = vof_brace (OCaml.vof_option vof_expr) v1 in OCaml.VSum (("XhpExpr", [ v1 ]))
  | XhpNested v1 ->
      let v1 = vof_xhp_html v1 in OCaml.VSum (("XhpNested", [ v1 ]))
and vof_encaps =
  function
  | EncapsString v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("EncapsString", [ v1 ]))
  | EncapsExpr ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      and v3 = vof_tok v3
      in OCaml.VSum (("EncapsExpr", [ v1; v2; v3 ]))

and vof_st =
  function
  | VarsDecl ((v1, v2, v3)) ->
      let v1 = vof_wrap vof_var_kind v1
      and v2 = vof_comma_list vof_var_binding v2
      and v3 = vof_sc v3
      in OCaml.VSum (("Variable", [ v1; v2; v3 ]))
  | Block v1 ->
      let v1 = vof_brace (OCaml.vof_list vof_item) v1
      in OCaml.VSum (("Block", [ v1 ]))
  | Nop v1 -> let v1 = vof_sc v1 in OCaml.VSum (("Nop", [ v1 ]))
  | ExprStmt ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_sc v2
      in OCaml.VSum (("ExprStmt", [ v1; v2 ]))
  | If ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_st v3
      and v4 =
        OCaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_st v2
             in OCaml.VTuple [ v1; v2 ])
          v4
      in OCaml.VSum (("If", [ v1; v2; v3; v4 ]))
  | Do ((v1, v2, v3, v4, v5)) ->
      let v1 = vof_tok v1
      and v2 = vof_st v2
      and v3 = vof_tok v3
      and v4 = vof_paren vof_expr v4
      and v5 = vof_sc v5
      in OCaml.VSum (("Do", [ v1; v2; v3; v4; v5 ]))
  | While ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_st v3
      in OCaml.VSum (("While", [ v1; v2; v3 ]))
  | For ((v1, v2, v3, v4, v5, v6, v7, v8, v9)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = OCaml.vof_option vof_lhs_or_vars v3
      and v4 = vof_tok v4
      and v5 = OCaml.vof_option vof_expr v5
      and v6 = vof_tok v6
      and v7 = OCaml.vof_option vof_expr v7
      and v8 = vof_tok v8
      and v9 = vof_st v9
      in OCaml.VSum (("For", [ v1; v2; v3; v4; v5; v6; v7; v8; v9 ]))
  | ForIn ((v1, v2, v3, v4, v5, v6, v7)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = vof_lhs_or_var v3
      and v4 = vof_tok v4
      and v5 = vof_expr v5
      and v6 = vof_tok v6
      and v7 = vof_st v7
      in OCaml.VSum (("ForIn", [ v1; v2; v3; v4; v5; v6; v7 ]))
  | ForOf ((v1, v2, v3, v4, v5, v6, v7)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = vof_lhs_or_var v3
      and v4 = vof_tok v4
      and v5 = vof_expr v5
      and v6 = vof_tok v6
      and v7 = vof_st v7
      in OCaml.VSum (("ForOf", [ v1; v2; v3; v4; v5; v6; v7 ]))
  | Switch ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_brace (OCaml.vof_list vof_case_clause) v3
      in OCaml.VSum (("Switch", [ v1; v2; v3 ]))
  | Continue ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = OCaml.vof_option vof_label v2
      and v3 = vof_sc v3
      in OCaml.VSum (("Continue", [ v1; v2; v3 ]))
  | Break ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = OCaml.vof_option vof_label v2
      and v3 = vof_sc v3
      in OCaml.VSum (("Break", [ v1; v2; v3 ]))
  | Return ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = OCaml.vof_option vof_expr v2
      and v3 = vof_sc v3
      in OCaml.VSum (("Return", [ v1; v2; v3 ]))
  | With ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_paren vof_expr v2
      and v3 = vof_st v3
      in OCaml.VSum (("With", [ v1; v2; v3 ]))
  | Labeled ((v1, v2, v3)) ->
      let v1 = vof_label v1
      and v2 = vof_tok v2
      and v3 = vof_st v3
      in OCaml.VSum (("Labeled", [ v1; v2; v3 ]))
  | Throw ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      and v3 = vof_sc v3
      in OCaml.VSum (("Throw", [ v1; v2; v3 ]))
  | Try ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_st v2
      and v3 =
        OCaml.vof_option
          (fun (v1, v2, v3) ->
             let v1 = vof_tok v1
             and v2 = vof_paren vof_arg v2
             and v3 = vof_st v3
             in OCaml.VTuple [ v1; v2; v3 ])
          v3
      and v4 =
        OCaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_st v2
             in OCaml.VTuple [ v1; v2 ])
          v4
      in OCaml.VSum (("Try", [ v1; v2; v3; v4 ]))
and vof_label v = vof_wrap OCaml.vof_string v
and vof_lhs_or_vars =
  function
  | LHS1 v1 -> let v1 = vof_expr v1 in OCaml.VSum (("LHS1", [ v1 ]))
  | ForVars ((v1, v2)) ->
      let v1 = vof_wrap vof_var_kind v1
      and v2 = vof_comma_list vof_var_binding v2
      in OCaml.VSum (("ForVars", [ v1; v2 ]))
and vof_lhs_or_var =
  function
  | LHS2 v1 -> let v1 = vof_expr v1 in OCaml.VSum (("LHS2", [ v1 ]))
  | ForVar ((v1, v2)) ->
      let v1 = vof_wrap vof_var_kind v1
      and v2 = vof_var_binding v2
      in OCaml.VSum (("ForVar", [ v1; v2 ]))
and vof_case_clause =
  function
  | Default ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = OCaml.vof_list vof_item v3
      in OCaml.VSum (("Default", [ v1; v2; v3 ]))
  | Case ((v1, v2, v3, v4)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      and v3 = vof_tok v3
      and v4 = OCaml.vof_list vof_item v4
      in OCaml.VSum (("Case", [ v1; v2; v3; v4 ]))
and vof_arg v = vof_wrap OCaml.vof_string v
and vof_type_ =
  function
  | TTodo -> OCaml.VSum (("TTodo", []))
  | TName v1 ->
      let v1 = vof_nominal_type v1 in
      OCaml.VSum (("TName", [ v1 ]))
  | TQuestion ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_type_ v2
      in OCaml.VSum (("TQuestion", [ v1; v2 ]))
  | TFun ((v1, v2, v3)) ->
      let v1 =
        vof_paren
          (vof_comma_list
             (fun (v1, v2) ->
               let v1 = vof_param_name v1
               and v2 = vof_annotation v2
               in OCaml.VTuple [ v1; v2 ]))
          v1
      and v2 = vof_tok v2
      and v3 = vof_type_ v3
      in OCaml.VSum (("TFun", [ v1; v2; v3 ]))
  | TObj v1 ->
      let v1 =
        vof_brace
          (OCaml.vof_list
             (fun (v1, v2, v3) ->
                let v1 = vof_property_name v1
                and v2 = vof_annotation v2
                and v3 = vof_sc v3
                in OCaml.VTuple [ v1; v2; v3 ]))
          v1
      in OCaml.VSum (("TObj", [ v1 ]))
and vof_param_name = function
  | RequiredParam(v1) ->
      let v1 = vof_name v1
      in OCaml.VSum (("RequiredParam", [v1]))
  | OptionalParam(v1,v2) ->
      let v1 = vof_name v1
      and v2 = vof_tok v2
      in OCaml.VSum (("OptionalParam", [v1; v2]))
  | RestParam(v1,v2) ->
      let v1 = vof_tok v1
      and v2 = vof_name v2
      in OCaml.VSum (("RestParam", [v1; v2]))

and vof_annotation = function
  | TAnnot(v1, v2) ->
      let v1 = vof_tok v1
      and v2 = vof_type_ v2
      in OCaml.VSum (("TAnnot", [v1; v2]))
  | TFunAnnot(v1,v2,v3,v4) ->
      let v1 = OCaml.vof_option
        (vof_angle (vof_comma_list vof_name)) v1 in
      let v2 =
        vof_paren
          (vof_comma_list
             (fun (v1, v2) ->
               let v1 = vof_param_name v1
               and v2 = vof_annotation v2
               in OCaml.VTuple [ v1; v2 ]))
          v2
      and v3 = vof_tok v3
      and v4 = vof_type_ v4
      in OCaml.VSum (("TFunAnnot", [ v1; v2; v3; v4 ]))

and vof_nominal_type ((v1,v2)) =
  let v1 = vof_expr v1 in
  let v2 = OCaml.vof_option (vof_angle (vof_comma_list vof_type_)) v2 in
  OCaml.VTuple [ v1; v2 ]
and vof_type_opt v =
  OCaml.vof_option vof_annotation v
and vof_func_decl {
                  f_kind = v_f_kind;
                  f_properties = v_f_properties;
                  f_params = v_f_params;
                  f_body = v_f_body;
                  f_type_params = v_f_type_params;
                  f_return_type = v_f_return_type
                } =
  let bnds = [] in
  let arg = vof_type_opt v_f_return_type in
  let bnd = ("f_return_type", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_type_parameters v_f_type_params in
  let bnd = ("f_type_params", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_brace (OCaml.vof_list vof_item) v_f_body in
  let bnd = ("f_body", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_paren (vof_comma_list vof_parameter_binding) v_f_params in
  let bnd = ("f_params", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_func_property v_f_properties in
  let bnd = ("f_properties", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_func_kind v_f_kind in
  let bnd = ("f_kind", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_type_parameters v = vof_angle (vof_comma_list vof_type_parameter) v
and vof_type_parameter v = vof_name v

and vof_func_kind =
  function
  | F_func ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = OCaml.vof_option vof_name v2
      in OCaml.VSum (("F_func", [ v1; v2 ]))
  | F_method v1 ->
      let v1 = vof_property_name v1 in OCaml.VSum (("F_method", [ v1 ]))
  | F_get ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_property_name v2
      in OCaml.VSum (("F_get", [ v1; v2 ]))
  | F_set ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_property_name v2
      in OCaml.VSum (("F_set", [ v1; v2 ]))
and vof_func_property =
  function
  | Generator v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Generator", [ v1 ]))
  | Async v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Async", [ v1 ]))
and vof_parameter_binding =
  function
  | ParamClassic v1 ->
      let v1 = vof_parameter v1 in OCaml.VSum (("ParamClassic", [ v1 ]))
  | ParamPattern v1 ->
      let v1 = vof_parameter_pattern v1
      in OCaml.VSum (("ParamPattern", [ v1 ]))
  | ParamEllipsis v1 ->
      let v1 = vof_tok v1 in OCaml.VSum (("ParamEllipsis", [ v1 ]))

and
  vof_parameter_pattern {
                          ppat = v_ppat;
                          ppat_type = v_ppat_type;
                          ppat_default = v_ppat_default
                        } =
  let bnds = [] in
  let arg =
    OCaml.vof_option
      (fun (v1, v2) ->
         let v1 = vof_tok v1 and v2 = vof_expr v2 in OCaml.VTuple [ v1; v2 ])
      v_ppat_default in
  let bnd = ("ppat_default", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_opt v_ppat_type in
  let bnd = ("ppat_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_pattern v_ppat in
  let bnd = ("ppat", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_parameter { p_name = v_p_name; p_type = v_p_type; p_default = v_default;
  p_dots = v_dots } =
  let bnds = [] in
  let arg = vof_type_opt v_p_type in
  let bnd = ("p_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_p_name in
  let bnd = ("p_name", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_default v_default in
  let bnd = ("p_default", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_tok v_dots in
  let bnd = ("p_dots", arg) in
  let bnds = bnd :: bnds in
  OCaml.VDict bnds
and vof_default = function
  | DNone (v1) -> let v1 = vof_tok v1 in OCaml.VSum (("DNone", [v1]))
  | DSome (v1,v2) -> let v1 = vof_tok v1 and v2 = vof_expr v2 in OCaml.VSum (("DSome", [v1; v2]))

and
  vof_arrow_func { a_async = v_a_async;
                   a_params = v_a_params; a_return_type = v_a_return_type;
                   a_tok = v_a_tok; a_body = v_a_body
                 } =
  let bnds = [] in
  let arg = vof_async v_a_async in
  let bnd = ("a_async", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_arrow_body v_a_body in
  let bnd = ("a_body", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_tok v_a_tok in
  let bnd = ("a_tok", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_opt v_a_return_type in
  let bnd = ("a_return_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_arrow_params v_a_params in
  let bnd = ("a_params", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
  and vof_async tok = OCaml.VSum(("AAsync", [OCaml.vof_option vof_tok tok]))
and vof_arrow_params =
  function
  | ASingleParam v1 ->
      let v1 = vof_parameter_binding v1 in OCaml.VSum (("ASingleParam", [ v1 ]))
  | AParams v1 ->
      let v1 = vof_paren (vof_comma_list vof_parameter_binding) v1
      in OCaml.VSum (("AParams", [ v1 ]))
and vof_arrow_body =
  function
  | AExpr v1 -> let v1 = vof_expr v1 in OCaml.VSum (("AExpr", [ v1 ]))
  | ABody v1 ->
      let v1 = vof_brace (OCaml.vof_list vof_item) v1
      in OCaml.VSum (("ABody", [ v1 ]))
and vof_var_kind =
  function
  | Var -> OCaml.VSum (("Var", []))
  | Const -> OCaml.VSum (("Const", []))
  | Let -> OCaml.VSum (("Let", []))

and vof_var_binding =
  function
  | VarClassic v1 ->
      let v1 = vof_variable_declaration v1
      in OCaml.VSum (("VarClassic", [ v1 ]))
  | VarPattern v1 ->
      let v1 = vof_variable_declaration_pattern v1
      in OCaml.VSum (("VarPattern", [ v1 ]))

and
  vof_variable_declaration_pattern {
                                     vpat = v_vpat;
                                     vpat_init = v_vpat_init;
                                     vpat_type = v_vpat_type
                                   } =
  let bnds = [] in
  let arg = vof_type_opt v_vpat_type in
  let bnd = ("vpat_type", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_init v_vpat_init in
  let bnd = ("vpat_init", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_pattern v_vpat in
  let bnd = ("vpat", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_init (v1, v2) =
  let v1 = vof_tok v1 and v2 = vof_expr v2 in OCaml.VTuple [ v1; v2 ]

and vof_pattern =
  function
  | PatObj v1 ->
      let v1 = vof_brace (vof_comma_list vof_pattern) v1
      in OCaml.VSum (("PatObj", [ v1 ]))
  | PatArr v1 ->
      let v1 = vof_bracket (vof_comma_list vof_pattern) v1
      in OCaml.VSum (("PatArr", [ v1 ]))
  | PatId ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = OCaml.vof_option vof_init v2
      in OCaml.VSum (("PatId", [ v1; v2 ]))
  | PatProp ((v1, v2, v3)) ->
      let v1 = vof_property_name v1
      and v2 = vof_tok v2
      and v3 = vof_pattern v3
      in OCaml.VSum (("PatProp", [ v1; v2; v3 ]))
  | PatDots ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_pattern v2
      in OCaml.VSum (("PatDots", [ v1; v2 ]))
  | PatNest ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = OCaml.vof_option vof_init v2
      in OCaml.VSum (("PatNest", [ v1; v2 ]))

and vof_variable_declaration {
                             v_name = v_v_name;
                             v_init = v_v_init;
                             v_type = v_v_type
                           } =
  let bnds = [] in
  let arg = vof_type_opt v_v_type in
  let bnd = ("v_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    OCaml.vof_option
      (fun (v1, v2) ->
         let v1 = vof_tok v1 and v2 = vof_expr v2 in OCaml.VTuple [ v1; v2 ])
      v_v_init in
  let bnd = ("v_init", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_v_name in
  let bnd = ("v_name", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_item =
  function
  | ItemTodo v1 -> let v1 = vof_tok v1 in OCaml.VSum (("ItemTodo", [v1]))
  | St v1 -> let v1 = vof_st v1 in OCaml.VSum (("St", [ v1 ]))
  | FunDecl v1 ->
      let v1 = vof_func_decl v1 in OCaml.VSum (("FunDecl", [ v1 ]))
  | ClassDecl v1 ->
      let v1 = vof_class_decl v1 in OCaml.VSum (("ClassDecl", [ v1 ]))
  | InterfaceDecl v1 ->
      let v1 = vof_interface_decl v1 in OCaml.VSum (("InterfaceDecl", [ v1 ]))

and  vof_class_decl {
                   c_tok = v_c_tok;
                   c_name = v_c_name;
                   c_type_params = v_c_type_params;
                   c_extends = v_c_extends;
                   c_body = v_c_body
                 } =
  let bnds = [] in
  let arg = vof_brace (OCaml.vof_list vof_class_stmt) v_c_body in
  let bnd = ("c_body", arg) in
  let bnds = bnd :: bnds in
  let arg =
    OCaml.vof_option
      (fun (v1, v2) ->
         let v1 = vof_tok v1
         and v2 = vof_nominal_type v2
         in OCaml.VTuple [ v1; v2 ])
      v_c_extends in
  let bnd = ("c_extends", arg) in
  let bnds = bnd :: bnds in
  let arg =
    OCaml.vof_option
      (vof_angle (vof_comma_list vof_name)) v_c_type_params
  in
  let bnd = ("c_type_params", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_name v_c_name in
  let bnd = ("c_name", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_tok v_c_tok in
  let bnd = ("c_tok", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
and  vof_interface_decl {
                   i_tok = v_i_tok;
                   i_name = v_i_name;
                   i_type_params = v_i_type_params;
                   i_type = v_i_type;
                 } =
  let bnds = [] in
  let arg = vof_type_ v_i_type in
  let bnd = ("i_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    OCaml.vof_option
      (vof_angle (vof_comma_list vof_name)) v_i_type_params
  in
  let bnd = ("i_type_params", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_i_name in
  let bnd = ("i_name", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_tok v_i_tok in
  let bnd = ("i_tok", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and  vof_field_decl {
                   fld_static = v_fld_static;
                   fld_name = v_fld_name;
                   fld_type = v_fld_type;
                   fld_init = v_fld_init
                 } =
  let bnds = [] in
  let arg = OCaml.vof_option vof_init v_fld_init in
  let bnd = ("fld_init", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_opt v_fld_type in
  let bnd = ("fld_type", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_property_name v_fld_name in
  let bnd = ("fld_name", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_static_opt v_fld_static in
  let bnd = ("fld_static", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_static_opt v = OCaml.vof_option vof_tok v

and vof_class_stmt =
  function
  | C_field ((v1, v2)) ->
      let v1 = vof_field_decl v1
      and v2 = vof_sc v2
      in OCaml.VSum (("C_field", [ v1; v2 ]))
  | C_method ((v1, v2)) ->
      let v1 = OCaml.vof_option vof_tok v1
      and v2 = vof_func_decl v2
      in OCaml.VSum (("C_method", [ v1; v2 ]))
  | C_extrasemicolon v1 ->
      let v1 = vof_sc v1 in OCaml.VSum (("C_extrasemicolon", [ v1 ]))
  | CEllipsis v1 ->
      let v1 = vof_tok v1 in OCaml.VSum (("CEllipsis", [ v1 ]))

and vof_import =
  function
  | ImportFrom v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) ->
             let v1 = vof_import_clause v1
             and v2 =
               (match v2 with
                | (v1, v2) ->
                    let v1 = vof_tok v1
                    and v2 = vof_module_path v2
                    in OCaml.VTuple [ v1; v2 ])
             in OCaml.VTuple [ v1; v2 ])
      in OCaml.VSum (("ImportFrom", [ v1 ]))
  | ImportEffect v1 ->
      let v1 = vof_module_path v1 in OCaml.VSum (("ImportEffect", [ v1 ]))
and vof_import_clause (v1, v2) =
  let v1 = OCaml.vof_option vof_import_default v1
  and v2 = OCaml.vof_option vof_name_import v2
  in OCaml.VTuple [ v1; v2 ]
and vof_name_import =
  function
  | ImportNamespace ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_tok v2
      and v3 = vof_name v3
      in OCaml.VSum (("ImportNamespace", [ v1; v2; v3 ]))
  | ImportNames v1 ->
      let v1 = vof_brace (vof_comma_list vof_import_name) v1
      in OCaml.VSum (("ImportNames", [ v1 ]))
  | ImportTypes (v1, v2) ->
      let v1 = vof_tok v1 in
      let v2 = vof_brace (vof_comma_list vof_import_name) v2
      in OCaml.VSum (("ImportTypes", [ v1; v2 ]))
and vof_import_default v = vof_name v
and vof_import_name (v1, v2) =
  let v1 = vof_name v1
  and v2 =
    OCaml.vof_option
      (fun (v1, v2) ->
         let v1 = vof_tok v1 and v2 = vof_name v2 in OCaml.VTuple [ v1; v2 ])
      v2
  in OCaml.VTuple [ v1; v2 ]

and vof_export =
  function
  | ExportDecl v1 ->
      let v1 = vof_item v1 in OCaml.VSum (("ExportDecl", [ v1 ]))
  | ExportDefaultDecl ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_item v2
      in OCaml.VSum (("ExportDefaultDecl", [ v1; v2 ]))
  | ExportDefaultExpr ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      and v3 = vof_sc v3
      in OCaml.VSum (("ExportDefaultExpr", [ v1; v2; v3 ]))
  | ExportNames ((v1, v2)) ->
      let v1 = vof_brace (vof_comma_list vof_import_name) v1
      and v2 = vof_sc v2
      in OCaml.VSum (("ExportNames", [ v1; v2 ]))
  | ReExportNamespace ((v1, v2, v3)) ->
      let v1 = vof_tok v1
      and v2 =
        (match v2 with
         | (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_module_path v2
             in OCaml.VTuple [ v1; v2 ])
      and v3 = vof_sc v3
      in OCaml.VSum (("ReExportNamespace", [ v1; v2; v3 ]))
  | ReExportNames ((v1, v2, v3)) ->
      let v1 = vof_brace (vof_comma_list vof_import_name) v1
      and v2 =
        (match v2 with
         | (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_module_path v2
             in OCaml.VTuple [ v1; v2 ])
      and v3 = vof_sc v3
      in OCaml.VSum (("ReExportNames", [ v1; v2; v3 ]))

and vof_module_item =
  function
  | Import v1 ->
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = vof_tok v1
             and v2 = vof_import v2
             and v3 = vof_sc v3
             in OCaml.VTuple [ v1; v2; v3 ])
      in OCaml.VSum (("Import", [ v1 ]))
  | Export v1 ->
      let v1 =
        (match v1 with
         | (v1, v2) ->
             let v1 = vof_tok v1
             and v2 = vof_export v2
             in OCaml.VTuple [ v1; v2 ])
      in OCaml.VSum (("Export", [ v1 ]))

  | It v1 -> let v1 = vof_item v1 in OCaml.VSum (("It", [ v1 ]))

and vof_program v = OCaml.vof_list vof_module_item v

let vof_any =
  function
  | Expr v1 -> let v1 = vof_expr v1 in OCaml.VSum (("Expr", [ v1 ]))
  | Stmt v1 -> let v1 = vof_st v1 in OCaml.VSum (("Stmt", [ v1 ]))
  | ModuleItem v1 -> let v1 = vof_module_item v1 in 
      OCaml.VSum (("ModuleItem",[v1 ]))
  | ModuleItems v1 -> let v1 = OCaml.vof_list vof_module_item v1 in 
      OCaml.VSum (("ModuleItems",[v1 ]))
  | Pattern v1 -> let v1 = vof_pattern v1 in OCaml.VSum (("Pattern",[v1 ]))
  | Program v1 -> let v1 = vof_program v1 in OCaml.VSum (("Program",[v1]))


(* end auto generation *)
