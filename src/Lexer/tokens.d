/**
 *  Tokens script.
 *
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.lex.tokens;

import deu.utils;

enum tType
{
    EOF = 0, // End of file
    EOL, // End of line

    PLUS,  // `+'
    MINUS, // `-'
    MULT,  // `*'
    DMULT, // `**' 
    DIV,   // `/'

    LPAR, // `('
    RPAR, // `)'
    EQ,   // `='
    SEMI, // `;'

    INT,  // Integer
    REAL, // Float
    ID,   // Identifiers

    LET, // 'let'

    MAX
}

struct Token
{
    tType type;
    char[] value;

    string line;

    ulong position;
    ulong linepos;

    string toString()
    {
        return to!string(type) ~ ":\t\"" ~ repr() ~ "\", at " ~ 
               to!string(linepos) ~ ":" ~ to!string(position) ~ " (" ~ line ~ ")";
        // return "<" ~ to!string(type) ~ ": " ~ to!string(value) ~ ">";
    }

    private string repr()
    {
        if (type == tType.REAL || type == tType.INT)
        {
            return BLUE ~ to!string(value) ~ OFF;
        }

        return GREEN ~ raw(to!string(value)) ~ OFF;
    }
}

///
static void print(Token*[] tokens)
{
    import std.stdio;

    write(repr(tokens));
}

///
static string repr(Token*[] tokens)
{
    string str = "";

    foreach (t; tokens)
    {
        str = str ~ "- " ~ t.toString() ~ "\n";
    }
    return str;
}

///
static bool is_keyword(char[] id)
{
    return (id == "let");
}

static tType get_keywordType(char[] id)
{
    switch (id)
    {
    case ['l', 'e', 't']:
        return tType.LET;

    default:
        import deu.errors, deu.utils;

        throw new DException("Unknown keyword '" ~ to!string(id) ~ "'.");
    }
}

string getLine(char[] input, ulong position)
{
    string line = "";

    for (; position < input.length; position++)
    {
        if (input[position] == '\n')
        {
            break;
        }
        line ~= input[position];
    }

    return line;
}
