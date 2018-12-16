/**
 *  ASTFuncCall class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astfunccall;

import deu.ast.base;
import deu.utils;

class ASTFuncCall : ASTExpression
{
    /// Function name
    ASTExpression fname;
    /// Parameters
    ASTExpression[] params;
    /// Works as statement?
    bool isStatement;

    /// Constructor
    this(ASTExpression fname, ASTExpression[] params, bool isStatement = true)
    {
        this.fname = fname;
        this.params = params;
        this.isStatement = isStatement;
    }

    override bool semiEnd() {
        return true;
    }


    override string transpile() {
        return format("%s(%s)", fname.transpile(), transpileArguments());
    }
    
    ///
    string transpileArguments() {
        if(this.params.length == 0) {
            return "";
        }

        string output = "";
        
        foreach(pm; this.params) {
            output ~= pm.transpile() ~ ", ";
        }

        return output.backspace(2);
    }    

}
