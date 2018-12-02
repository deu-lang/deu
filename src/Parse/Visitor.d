/**
 *  Visitor class.
 *  see https://en.wikipedia.org/wiki/Visitor_pattern
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.visitor;

import deu.errors;

import deu.ast.base;
import deu.ast.astbinop;
import deu.ast.astunop;
// import deu.ast.astcompound;
import deu.ast.astdeclaration;
import deu.ast.astvar;
import deu.ast.astnumber;

import deu.lex.tokens : tType;
import deu.utils;

class ASTVisitor {
       
}