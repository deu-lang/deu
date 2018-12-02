/**
 *  Utils script.
 *
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.utils;

public import std.stdio : write, writeln;
public import std.conv  : to;

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

public void log(T)(T arg, string file = __FILE__, size_t line = __LINE__) {
    writeln(OFF, "[", YELLOW, file, " at ", line, OFF, "]: ", arg);
}


public bool verbose = false;
public bool warn    = true;

public void pverbose(T)(lazy T arg) {
    if (verbose) {
        write(OFF, arg);
    }
}

public void pwarn(T)(lazy T arg) {
    if (warn) {
        write(PURPLE, BOLD, "Warning", OFF, ": ", arg);
    }
}

public void perror(T)(lazy T arg) {
    write(RED, BOLD, "Error", OFF, ": ", arg);
}

public string raw(string str) {
    string newstring = "";
    foreach(c; str) {
        if(c == '\n') {
            newstring ~= GOLD ~ "\\n" ~ OFF;
            continue;
        }
        if(c == '\t') {
            newstring ~= GOLD ~ "\\t" ~ OFF;
            continue;
        }
        
        newstring ~= c;
    }
    return newstring;
}

public string repr(string str, string ch) pure nothrow @safe
{
    if (str.length > 50) return ch;
    else return str;
}

string dir_to_file(string directory) {
    char[] dir = directory.dup();

    foreach_reverse(i, c ; dir) {
        if (c == '/') {
            return to!string(dir[i+1 .. $]);
        }
    }

    return "";
}

public uint[3] VERSION = [0, 0, 0];


/// unittest print
void uprint(T...)(T args, string file = __FILE__, size_t line = __LINE__) {
    write("[", CYAN, "unittest ", OFF, (file), " at ", line, "] ", args);
    // write("[", BLUE, "unittest ", OFF, (file), " at ", line, "] ", args);
}


bool unassert(bool cond, string msginfo = "", string file = __FILE__, uint line = __LINE__) {
    
    void uprint(T...)(T args) {
        write("[", BLUE, "unittest ", OFF, (file), " at ", line, "] ", args);
    }

    if (msginfo != "") {
        msginfo = ": " ~ msginfo;
    }

    if(!cond) {
        string pr = "\t" ~ YELLOW ~ dir_to_file(file) ~ OFF ~ "\t- " ~ RED ~ BOLD ~ "FAILED" ~ OFF;
        pr ~= msginfo ~ '\n';
        uprint(pr);
        return false;
    }

    return true;
}