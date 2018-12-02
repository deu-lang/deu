/**
 *  ASTUnOperator class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astunop;

import deu.ast.base;
import deu.lex.tokens : Token;
// import deu.ast.visitor;

class ASTUnOperator : ASTExpression {

    /// Expression
    ASTExpression expression;

    /// Operator
    Token* operator;

    /// Constructor
    this(ASTExpression expression, Token* operator) {
        this.expression = expression;
        this.operator = operator;
    }
}