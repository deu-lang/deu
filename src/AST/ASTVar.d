/**
 *  ASTVar class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astvar;

import deu.ast.base;
// import deu.lex.tokens : Token, tType;
import deu.utils : to;

// import deu.ast.visitor;

class ASTVar : AST
{
    /// Identifier
    string id;

    /// Constructor
    this(string id)
    {
        this.id = id;
    }
    ///
    this(char[] id)
    {
        this(to!string (id));
    }
}
