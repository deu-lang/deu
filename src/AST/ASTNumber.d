/**
 *  ASTNumber class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astnumber;

import deu.ast.base;
import deu.lex.tokens : Token, tType;
import deu.utils : to;

// import deu.ast.visitor;

class ASTNumber : ASTExpression
{

    // Refactor this later!
    /// Value of the object.
    union
    {
        size_t intvalue;
        float flvalue;
    }

    /// Is float
    bool isFloat = true;

    /// Constructor
    this(float value = 0, bool isFloat = true)
    {
        this.intvalue = to!size_t(value);
        this.flvalue = value;
        this.isFloat = isFloat;
    }

    this(Token* tok)
    {
        this(to!float(tok.value), tok.type == tType.REAL);
    }
}
