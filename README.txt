cygwin-install.sh
=================

NAME
----

cygwin-install.sh - install cygwin from git bash or other cygwin in a
repeatable manner.

SYNOPSIS
--------

cygwin-install.sh [-i INSTALL_ROOT]

DESCRIPTION
-----------

cygwin-install.sh is a bash script that will download and install cygwin from
its primary source.  This is meant to run git bash, so a recent bash version
(5+) and curl installation is assumed.

The installation location is ./cygwin/ by default.

After install, the script also write a Cygwin-mintty.bat file as mintty does
not seem to be launched from the installed Cygwin.bat file.  Additionally,
/etc/minttyrc is populated with configuration to set mintty to use a block
cursor with no blink.

No shortcuts, including start menu or desktop shortcuts, are created for the
cygwin install.

OPTIONS
-------

-i INSTALL_ROOT,--install-root INSTALL_ROOT
    Changes the installation root to the directory specified instead of ./cygwin/.

NOTES
-----

This is a pretty straightforward script.  The idea is based on vegardit's
cygwin-portable-installer as there was a lot of need for an installer that just
works.  Instead of assuming there is no possible bash environment, however, the
script assumes at least a git bash environment, as it is likely that if you are
programming on Windows, you have a git bash install to use for basic scripting.

BUGS
----

See bash(1).

SEE ALSO
--------

https://github.com/vegardit/cygwin-portable-installer
    vegardit's cygwin-portable-installer.  If you need something that only
    assuming a working Win32 environment, look here, though be aware that the
    script installs a lot of extras by default (such as bash-funk and ConEmu).
