/**
 *  ASTString class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.aststr;

import deu.ast.base;
import deu.lex.tokens : Token, tType;
import deu.utils : to, toUTF8, backspace;

class ASTString : ASTExpression
{
    string value;

    /// Constructor
    this(string value)
    {
        this.value = value;
    }

    this(Token* tok)
    {
        this(to!string(tok.value));
    }

    override bool semiEnd() {
        // Not aplicable tho
        return true;
    }

    override string transpile() {
        return "\"" ~ value.backspace() ~ "\"";
    }


}
