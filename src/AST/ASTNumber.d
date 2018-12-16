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
import deu.utils;

class ASTNumber : ASTExpression
{

    // Refactor this later!
    /// Value of the object.
    union
    {
        int intvalue;
        float flvalue;
    }

    /// Is float
    bool isFloat = true;

    /// Constructor
    this(float value = 0, bool isFloat = true)
    {
        if (isFloat)
            this.flvalue = value;
        else
            this.intvalue = to!int(value);
        this.isFloat = isFloat;
    }

    this(Token* tok)
    {
        this(to!float(tok.value), tok.type == tType.REAL);
    }

    override bool semiEnd() {
        /// Not applicable tho
        return true;
    }

    override string transpile()
    {
        return to!string(isFloat ? flvalue : intvalue);
    }

}
