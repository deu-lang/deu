/**
 *  Utils script.
 *
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.utils;

public import std.stdio : write, writeln, File;
public import std.utf : toUTF8, toUTF16;
public import regex = std.regex;
public import std.conv : to;
public import std.format : format;

public string OFF = "\033[0m";
public string RED = "\033[0;31m";
public string GREEN = "\033[0;32m";
public string GOLD = "\033[0;33m";
public string BLUE = "\033[0;34m";
public string PURPLE = "\033[0;35m";
public string CYAN = "\033[0;36m";
public string YELLOW = "\033[0;93m";

public string BOLD = "\033[1m";
public string UNDER = "\033[4m";

public void log(T)(T arg, string file = __FILE__, size_t line = __LINE__)
{
    writeln(OFF, "[", YELLOW, file, " at ", line, OFF, "]: ", arg);
}

public bool verbose = false;
public bool warn = true;

public void pverbose(T)(lazy T arg)
{
    if (verbose)
    {
        write(OFF, arg);
    }
}

public void pwarn(T)(lazy T arg)
{
    if (warn)
    {
        write(PURPLE, BOLD, "Warning", OFF, ": ", arg);
    }
}

public void perror(T)(lazy T arg)
{
    write(RED, BOLD, "Error", OFF, ": ", arg, "\n");
}

public string raw(string str)
{
    string newstring = "";
    foreach (c; str)
    {
        if (c == '\n')
        {
            newstring ~= GOLD ~ "\\n" ~ OFF;
            continue;
        }
        if (c == '\t')
        {
            newstring ~= GOLD ~ "\\t" ~ OFF;
            continue;
        }

        newstring ~= c;
    }
    return newstring;
}

public string repr(string str, string ch)
{
    if (str.length > 50)
        return ch;
    else
        return str;
}

string pathGetFileName(string directory)
{
    return pathGetRegex(directory).captures[2];
}

string pathGetFileExtension(string directory)
{
    return pathGetRegex(directory).captures[3];
}

string pathGetRootName(string directory)
{
    return pathGetRegex(directory).captures[1];
}

regex.RegexMatch!string pathGetRegex(string path) {
    return regex.match(path, r"((?:[^/]*/)*)(.*)(\..*)");
    // return regex.match(path, r"((?:[^/]*/)*)(.*)");
}

public string backspace(string str, int c = 1) {
    return to!string(str[0 .. $ - c]);
}

public uint[3] VERSION = [0, 0, 1];

/// unittest print
void uprint(T...)(T args, bool _debug = false, string file = __FILE__, size_t line = __LINE__)
{
    if (_debug)
        write("[", CYAN, "unittest ", OFF, pathGetFileName(file), " at ", line, "] ", args);
    else
        write("[", CYAN, "unittest", OFF, "] ", args);
    // write("[", BLUE, "unittest ", OFF, (file), " at ", line, "] ", args);
}

bool unassert(bool cond, string msginfo = "", string file = __FILE__, uint line = __LINE__)
{

    // void uprint(T...)(T args) {
    //     write("[", CYAN, "unittest ", OFF, (file), " at ", line, "] ", args);
    // }

    if (!cond)
    {
        if (msginfo != "")
            msginfo = ": " ~ msginfo;

        string pr = "\t" ~ YELLOW ~ pathGetFileName(file) ~ OFF ~ "\t\t- "
            ~ RED ~ BOLD ~ "FAILED" ~ OFF;
        pr ~= msginfo ~ " at l" ~ to!string(line) ~ ".\n";
        uprint(pr);
        return false;
    }

    return true;
}