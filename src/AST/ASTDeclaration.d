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
import deu.lex.tokens : Token, tType;
import deu.utils : to;

// import deu.ast.visitor;

class ASTDeclaration : AST
{
    /// Identifier
    string id;
    /// Value
    ASTExpression value;

    /// Constructor
    this(string id, ASTExpression value)
    {
        this.id = id;
        this.value = value;
    }
}
