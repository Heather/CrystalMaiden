use v6;

use Shell::Command;

module Module::Rebuild;

class Module::Rebuild::Result is Cool { }
    
sub rebuild() is export {
    run ('emerge'
            ,'--oneshot'
            ,'--keep-going'
            ,qx/ equery d perl6 /\
                .split(/\n/)\
                .map({ $_ ?? "=$_" !! () }))} 