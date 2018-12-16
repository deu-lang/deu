/**
 *  ASTFunction class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astfunc;

import deu.ast.base, deu.ast.astdeclaration, deu.ast.astno, deu.ast.astreturn;
import deu.utils;

class ASTFunc : ASTExpression
{
    /// Name of the function.
    string fname;
    /// Parameters
    ASTDeclaration[] params;
    /// Statements
    AST[] statements;

    /// Constructor
    this(string fname, AST[] statements, ASTDeclaration[] params)
    {
        this.fname = fname;
        this.statements = statements;
        this.params = params;
    }

    override bool semiEnd() {
        return false;
    }

    /// Transpile the statements inside.
    string statementsTranspile()
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

    /// Transpile the parameters inside.
    string parametersTranspile()
    {
        string paramString = "";

        ASTDeclaration[] newD;

        foreach (de; this.params)
        {
            // if de is not null
            if (de)
            {
                paramString ~= de.transpile();
                newD ~= de;
            }
        }
        this.params = newD;

        return paramString;
    }

    override string transpile()
    {
        // return "auto " ~ this.fname ~ "(" ~ ~ ") {\n" ~ bodyString ~ "\n}";
        if (this.isMain())
        {
            return format(
                "%s %s(%s) {\n%s}\n\n",
                this.containsReturn() ? "int" : "void",
                this.fname,
                this.parametersTranspile(),
                this.statementsTranspile());
        }

        return format(
            "auto %s(%s) {\n%s}\n\n", 
            this.fname,
            this.parametersTranspile(), this.statementsTranspile());
    }

    /// true if has a return statement
    bool containsReturn()
    {
        foreach (st; this.statements)
        {
            if (st && cast(ASTReturn) st !is null)
                return true;
        }

        return false;
    }

    /// true if the name is 'main'
    bool isMain()
    {
        return this.fname == "main";
    }

}
