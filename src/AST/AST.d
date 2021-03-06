/**
 *  Base AST class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.base;

interface AST {
    /// The answer to 'if working as statement, needs semicolon?'
    bool semiEnd();

    /// Translate deu code to D code.
    string transpile();
    /// Optimize content
    
}

/// Expressions are a type of statements that evaluate to a value.
interface ASTExpression : AST {}


/// Tab size for transpiling (2 spaces)
public static string TAB = "  ";