/**
 *  ASTIf class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astif;

import deu.ast.base, deu.ast.astno;
import deu.utils : to, format;

class ASTIf : AST
{
    /// Expression to evaluate.
    ASTExpression expr;
    /// Statements to execute if expr is true.
    AST[] statements;

    ///
    this(ASTExpression expr, AST[] statements)
    {
        this.expr = expr;
        this.statements = statements;
    }

    override bool semiEnd() {
        return false;
    }

    /// Transpile the statements inside.
    string transpileStatements()
    {
        string bodyString = "";

        AST[] newST;

        foreach (st; this.statements)
        {
            // if st is not null
            if (st && cast(ASTNo) st is null)
            {
                bodyString ~= TAB ~ st.transpile() ~ (st.semiEnd() ? ";" : "") ~ "\n";
                newST ~= st;
            }
        }
        this.statements = newST;

        return bodyString;
    }

    override string transpile() {
        return format("if(%s) {\n%s}\n", expr.transpile(), this.transpileStatements());
    }


}
