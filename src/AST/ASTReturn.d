/**
 *  ASTReturn class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astreturn;

import deu.ast.base;
import deu.utils;

class ASTReturn : AST
{
    /// Expression to return.
    ASTExpression expr;

    /// Constructor
    this(ASTExpression expr)
    {
        this.expr = expr;
    }

    override bool semiEnd() {
        return true;
    }


    override string transpile() {
        return format(
            "return %s",
            this.expr.transpile()
        );
    }
}
