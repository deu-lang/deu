/**
 *  Parser class used for parsing.
 *  see https://en.wikipedia.org/wiki/Parsing
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.parser;

import deu.lex.lexer;
import deu.lex.tokens;

import deu.errors;

import deu.ast.base;
import deu.ast.astnumber;
import deu.ast.astbinop;
import deu.ast.astunop;

// import deu.ast.astexpression;
import deu.ast.astdeclaration;
import deu.ast.astvar;
// import deu.ast.astunop;
// import deu.ast.astcompound;

import deu.utils;

class Parser
{

    /// List of tokens provided by lexers.
    Token*[] tokens;

    /// Current Token
    Token* currentToken;

    /// 
    uint counter;

    /// Constructing methods.
    this(Token*[] tokens)
    {
        this.counter = 0;
        this.tokens = tokens;
        this.currentToken = this.tokens[counter];
    }

    /// Get next token.
    void nextToken()
    {
        if (++this.counter < this.tokens.length)
            this.currentToken = this.tokens[this.counter];
        else
            this.currentToken = null;
    }

    /// Expect a tType.
    Token* expect(uint t)
    {
        if (this.currentToken.type == t)
        {
            Token* tmp = this.currentToken;
            nextToken();
            return tmp;
        }
        else
        {
            throw new DException("Expected '" ~ 
                to!string(cast(tType)t) ~ "', got '" ~ 
                to!string(cast(tType) this.currentToken.type) ~ "'.");
        }
    }

    /// Accept a given token and return it.
    Token* accept(uint t)
    {
        if (this.currentToken.type == t)
        {
            nextToken();
            return currentToken;
        }
        return null;
    }

    /// Accept any token and return it.
    Token* acceptAny()
    {
        Token* tmp = this.currentToken;
        nextToken();
        return tmp;
    }

    /// Expect token type t or line break.
    Token* expectLOR(uint t)
    {
        if (this.currentToken.type == t || this.currentToken.type == tType.EOL)
        {
            Token* tmp = this.currentToken;
            nextToken();
            return tmp;
        }
        else
        {
            throw new DException("Expected '" ~ 
                to!string(cast(tType) t) ~ "', got '" ~ 
                to!string(cast(tType) this.currentToken.type) ~ "'.");
        }
    }

    /// Accept token type t or line break.
    Token* acceptLOR(uint t)
    {
        Token* tok;

        tok = accept(t);
        if (tok /*  != OFFTOKEN */ )
            return tok;

        tok = accept(tType.EOL);
        if (tok /*  != OFFTOKEN */ )
            return tok;

        return accept(t);
    }

    /// Parse Factor.
    ASTExpression _pFactor()
    {
        /* Parse factor function */
        switch (this.currentToken.type)
        {
        case tType.PLUS:
            Token* accepted = expect(tType.PLUS);
            return new ASTUnOperator(_pFactor(), accepted);
        case tType.MINUS:
            Token* accepted = expect(tType.MINUS);
            return new ASTUnOperator(_pFactor(), accepted);

        case tType.INT:
        case tType.REAL:
            Token* accepted = acceptAny();
            if (this.currentToken.type == tType.DMULT)
            {
                Token* operator = acceptAny();
                return new ASTBinOperator(new ASTNumber(accepted), parseExpression(), operator);
            }
            return new ASTNumber(accepted);
            /+ case tType.STRING:
                Token accepted = expect(tType.STRING);
                return new ASTString(accepted); +/
            /+ case tType.BOOL:
                Token accepted = expect(tType.BOOL);
                return new ASTBool(accepted); +/

            // case tType.ID:
            //     Token* accepted = this.expect(tType.ID);
            //     return new ASTVar(accepted);

        case tType.LPAR:
            expect(tType.LPAR);
            ASTExpression node = parseExpression();
            expect(tType.RPAR);
            return node;
            /+ case tType.LST:
                return parseReference(); +/

        default:
            throw new DException("Expecting factor.");
        }
    }

    /// Inter Function Parse Term.
    ASTExpression _pTerm()
    {
        /* Parse term function */
        ASTExpression node = _pFactor();
        while (this.currentToken.type != tType.EOF
                && (this.currentToken.type == tType.MULT || this.currentToken.type == tType.DIV)) /+ ||
            this.currentToken.type == tType.DPLUS || this.currentToken.type == tType.DAND ||
            this.currentToken.type == tType.DOR)) +/
        {
            Token* token = acceptAny();
            node = new ASTBinOperator(node, _pFactor(), token);
        }

        return node;
    }

    /// Parse Expression
    ASTExpression parseExpression()
    {
        /* Parse expression function */
        ASTExpression node = _pTerm();
        while (this.currentToken && (this.currentToken.type == tType.PLUS
                || this.currentToken.type == tType.MINUS))
        {
            Token* token = acceptAny();
            node = new ASTBinOperator(node, _pTerm(), token);
        }
        return node;
    }

    /// Parse Let
    ASTDeclaration parseLet() {
        /// LetStatement: LET ID | EOL
        ///                      | SEMI
        ///                      | EQ expression

        this.expect(tType.LET);
        string id = to!string(this.expect(tType.ID).value);        
        ASTExpression expr;

        if(this.currentToken.type == tType.EQ) {
            this.expect(tType.EQ);
            expr = parseExpression();
        }

        // return null;
        return new ASTDeclaration(id, expr);
    }

    /// Parse statement
    AST parseStatement() {
        /// Statement: | expression
        ///            | let_statement
        ///            | if_statement

        switch(this.currentToken.type) {
            
            case tType.ID:
            case tType.REAL:
            case tType.INT:
                return parseExpression();

            default:
                return null;
        }

        // return null;
    }

    AST[] parse()
    {

        AST[] statements = [parseStatement()];

        // while (this.currentToken.type != tType.EOF)
        // {
            // statements ~= [this.parseExpression()];
            // statements ~= [this.parseStatement()];
        // }
        return statements;
    }
}
