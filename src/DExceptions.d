/**
 *  Exception Functions.
 *  see https://en.wikipedia.org/wiki/Exception_handling
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.errors;


/// Used to Manage Exceptions
class DException : Exception {
    
    this(string msg, ulong LINE = __LINE__, string FILE = __FILE__) {
        super(msg, FILE, LINE);
    }
}
