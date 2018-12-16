/**
 *  ASTDeclaration class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astdeclaration;

import deu.ast.base;
import deu.utils : to, format;

class ASTDeclaration : AST
{
    /// Identifier
    string id;
    /// Value
    ASTExpression value;
    ///
    string type;
    ///
    bool isFunctionParameter;

    /// Constructor
    this(string id, ASTExpression value, string type, bool isFunctionParameter = false)
    {
        this.id = id;
        this.value = value;
        this.type = type;
        this.isFunctionParameter = isFunctionParameter;
    }

    override bool semiEnd() {
        return true;
    }

    override string transpile() {
        if(isFunctionParameter) {
            if(value is null) return format("%s %s", this.type, this.id);
            return format("%s %s = %s", this.type, this.id, value.transpile());
        } else {
            if(type == "") return format("auto %s = %s", this.id, value.transpile());
            return format("%s %s = %s", this.type, this.id, value.transpile());
        }
    }
    

}
