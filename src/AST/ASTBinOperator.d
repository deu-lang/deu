/**
 *  ASTBinOperator class.
 *  see https://en.wikipedia.org/wiki/Abstract_syntax_tree
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.ast.astbinop;

import deu.ast.base;
import deu.lex.tokens : Token, tType;
import deu.utils : to;

class ASTBinOperator : ASTExpression {

    /// Left-Expression
    ASTExpression leftExpression;
    /// Right-Expression
    ASTExpression rightExpression;

    /// Operator
    OP operator;

    /// Constructor
    this(ASTExpression leftExpression, ASTExpression rightExpression, OP operator) {
        this.leftExpression = leftExpression;
        this.rightExpression = rightExpression;
        this.operator = operator;
    }
    ///
    this(ASTExpression leftExpression, ASTExpression rightExpression, Token* operator) {
        this(leftExpression, rightExpression, getOPfromToken(*operator));
    }

    override bool semiEnd() {
        return true;
    }

    override string transpile() {
        string op = "";
        switch(this.operator) {
            case OP.PLUS:
                op = "+";
                break;
            case OP.MINUS:
                op = "-";
                break;
            case OP.MULT:
                op = "*";
                break;
            case OP.DIV:
                op = "/";
                break;
            case OP.LST:
                op = "<";
                break;
            case OP.GRT:
                op = ">";
                break;
            case OP.LTE:
                op = "<=";
                break;
            case OP.GTE:
                op = ">=";
                break;
            default:
                import deu.errors;
                throw new DException("Unknown operator " ~ to!string(this.operator) ~ ".");
        }

        return leftExpression.transpile() ~ op ~ rightExpression.transpile();
    }

    
}

/// TODO: remove astbinop and change it to builtin functions
enum OP {
    PLUS,
    MINUS,
    MULT,
    DIV,
    LST,
    GRT,
    LTE,
    GTE
}

OP getOPfromToken(Token tok) {
    switch(tok.type) {
    case tType.PLUS:
        return OP.PLUS;
    case tType.MINUS:
        return OP.MINUS;
    case tType.MULT:
        return OP.MULT;
    case tType.DIV:
        return OP.DIV;
    case tType.LTE:
        return OP.LTE;
    case tType.GTE:
        return OP.GTE;
    case tType.LST:
        return OP.LST;
    case tType.GRT:
        return OP.GRT;
    default:
        import deu.errors;
        throw new DException("Cannot get operator from type " ~ to!string(tok.type));
    }
}