use v6;

use Shell::Command;

module Module::Rebuild;

class Module::Rebuild::Result is Cool {
    }
    
sub rebuild() is export {
    print %*CUSTOM_LIB<site>
    }