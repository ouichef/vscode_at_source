# VscodeAtSource

This will open VSCode at the source location of a method. 
This uses `object.method(:method_name).source_location` and 
VSCode's `code` command in $PATH, so make sure you have that set up. 