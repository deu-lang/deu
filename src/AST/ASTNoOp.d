/**
 *  ASTNo class. Represents literally 'do nothing'
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astno;

import deu.ast.base;

class ASTNo : AST
{
    override bool semiEnd() {
        return false;
    }

    override string transpile() {
        return "";
    }
}
