/**
 *  ASTProgram class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astprogram;

import deu.ast.base;
import deu.ast.astno;
import deu.utils;

class ASTProgram : AST
{
    private AST[] statements;

    /// Constructor
    this(AST[] statements)
    {
        this.statements = statements;
    }

    /// Translate the entire program to D
    string generateProgram() {
        string output = "import std.stdio : printf;\nimport std.conv : to;\n\n";
        return output ~ this.transpile();
    }

    /// Append to the statement list and return its length.
    size_t append(AST st) {
        this.statements ~= st;
        return this.statements.length;
    }

    string getStatementsString() {
        return to!string(this.statements);
    }

    override bool semiEnd() {
        return false;
    }

    override string transpile() {
        string output = "";
        foreach(st; statements) {
            if(cast(ASTNo)st !is null)
                continue;
            output ~= st.transpile();
            // log("'"~ output~ "'");
        }
        return output;
    }
    

}
