/**
 *  ASTBinOperator class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astbinop;

import deu.ast.base;
import deu.lex.tokens : Token;
// import deu.ast.visitor;

class ASTBinOperator : ASTExpression {

    /// Left-Expression
    ASTExpression leftExpression;
    /// Right-Expression
    ASTExpression rightExpression;

    /// Operator
    Token* operator;

    /// Constructor
    this(ASTExpression leftExpression, ASTExpression rightExpression, Token* operator) {
        this.leftExpression = leftExpression;
        this.rightExpression = rightExpression;
        this.operator = operator;
    }
}