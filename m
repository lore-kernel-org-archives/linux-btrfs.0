From: Brad Figg <brad.figg@canonical.com>
Subject: xfstests build and other questions/issues
Date: Wed, 16 Jun 2010 09:48:05 -0700
Message-ID: <4C190045.6000904@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000102040807070500090604"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000102040807070500090604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I've cloned:
    git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

When I build I get compile errors trying to build dmapi. Do I need
to build this? I've attached a log of the build (build.log).

If I ignore the build error and just go ahead and try to run the
tests my first question is, "What do I run?". Looking at the README
it looks like I want to run "./check".

However, when I run "./check" I get:
     common.rc: Error: $TEST_DEV (/dev/sda8) is not a MOUNTED xfs filesystem
     Filesystem    Type   1K-blocks      Used Available Use% Mounted on
     /dev/sda8    btrfs   114254248  75250032  39004216  66% /test


If any/all of this is covered by the wiki, please point me at it. I've
tried looking for it but have not found anything.

Is there a FAQ somewhere?

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com

--------------000102040807070500090604
Content-Type: text/plain;
 name="build.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="build.log"

cd . && /bin/bash /home/bradf/work/xfstests-dev/dmapi/missing --run aclocal-1.9 
/home/bradf/work/xfstests-dev/dmapi/missing: line 52: aclocal-1.9: command not found
WARNING: `aclocal-1.9' is missing on your system.  You should only need it if
         you modified `acinclude.m4' or `configure.ac'.  You might want
         to install the `Automake' and `Perl' packages.  Grab them from
         any GNU archive site.
 cd . && /bin/bash /home/bradf/work/xfstests-dev/dmapi/missing --run automake-1.9 --foreign 
/home/bradf/work/xfstests-dev/dmapi/missing: line 52: automake-1.9: command not found
WARNING: `automake-1.9' is missing on your system.  You should only need it if
         you modified `Makefile.am', `acinclude.m4' or `configure.ac'.
         You might want to install the `Automake' and `Perl' packages.
         Grab them from any GNU archive site.
cd . && /bin/bash /home/bradf/work/xfstests-dev/dmapi/missing --run autoconf
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_pic_works, ...): suspicious cache-id, must contain _cv_ to be cached
../../lib/autoconf/general.m4:1998: AC_CACHE_VAL is expanded from...
../../lib/autoconf/general.m4:2019: AC_CACHE_CHECK is expanded from...
aclocal.m4:621: AC_LIBTOOL_COMPILER_OPTION is expanded from...
aclocal.m4:4809: AC_LIBTOOL_PROG_COMPILER_PIC is expanded from...
aclocal.m4:2657: _LT_AC_LANG_C_CONFIG is expanded from...
aclocal.m4:2656: AC_LIBTOOL_LANG_C_CONFIG is expanded from...
aclocal.m4:86: AC_LIBTOOL_SETUP is expanded from...
aclocal.m4:66: _AC_PROG_LIBTOOL is expanded from...
aclocal.m4:31: AC_PROG_LIBTOOL is expanded from...
aclocal.m4:6309: AM_PROG_LIBTOOL is expanded from...
configure.ac:8: the top level
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_static_works, ...): suspicious cache-id, must contain _cv_ to be cached
aclocal.m4:666: AC_LIBTOOL_LINKER_OPTION is expanded from...
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_pic_works_CXX, ...): suspicious cache-id, must contain _cv_ to be cached
aclocal.m4:2734: _LT_AC_LANG_CXX_CONFIG is expanded from...
aclocal.m4:2733: AC_LIBTOOL_LANG_CXX_CONFIG is expanded from...
aclocal.m4:1793: _LT_AC_TAGCONFIG is expanded from...
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_static_works_CXX, ...): suspicious cache-id, must contain _cv_ to be cached
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_pic_works_F77, ...): suspicious cache-id, must contain _cv_ to be cached
aclocal.m4:3897: _LT_AC_LANG_F77_CONFIG is expanded from...
aclocal.m4:3896: AC_LIBTOOL_LANG_F77_CONFIG is expanded from...
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_static_works_F77, ...): suspicious cache-id, must contain _cv_ to be cached
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_pic_works_GCJ, ...): suspicious cache-id, must contain _cv_ to be cached
aclocal.m4:3999: _LT_AC_LANG_GCJ_CONFIG is expanded from...
aclocal.m4:3998: AC_LIBTOOL_LANG_GCJ_CONFIG is expanded from...
configure.ac:8: warning: AC_CACHE_VAL(lt_prog_compiler_static_works_GCJ, ...): suspicious cache-id, must contain _cv_ to be cached
/bin/bash ./config.status --recheck
running /bin/bash ./configure   --no-create --no-recursion
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking build system type... x86_64-unknown-linux
checking host system type... x86_64-unknown-linux
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for /usr/bin/ld option to reload object files... -r
checking for BSD-compatible nm... /usr/bin/nm -B
checking whether ln -s works... yes
checking how to recognise dependent libraries... pass_all
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking dlfcn.h usability... yes
checking dlfcn.h presence... yes
checking for dlfcn.h... yes
checking for g++... g++
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking dependency style of g++... gcc3
checking how to run the C++ preprocessor... g++ -E
checking for g77... no
checking for xlf... no
checking for f77... no
checking for frt... no
checking for pgf77... no
checking for cf77... no
checking for fort77... no
checking for fl32... no
checking for af77... no
checking for xlf90... no
checking for f90... no
checking for pgf90... no
checking for pghpf... no
checking for epcf90... no
checking for gfortran... no
checking for g95... no
checking for xlf95... no
checking for f95... no
checking for fort... no
checking for ifort... no
checking for ifc... no
checking for efc... no
checking for pgf95... no
checking for lf95... no
checking for ftn... no
checking whether we are using the GNU Fortran 77 compiler... no
checking whether  accepts -g... no
checking the maximum length of command line arguments... 32768
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for objdir... .libs
checking for ar... ar
checking for ranlib... ranlib
checking for strip... strip
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC
checking if gcc PIC flag -fPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
configure: creating libtool
appending configuration tag "CXX" to libtool
checking for ld used by g++... /usr/bin/ld -m elf_x86_64
checking if the linker (/usr/bin/ld -m elf_x86_64) is GNU ld... yes
checking whether the g++ linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking for g++ option to produce PIC... -fPIC
checking if g++ PIC flag -fPIC works... yes
checking if g++ static flag -static works... yes
checking if g++ supports -c -o file.o... yes
checking whether the g++ linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
appending configuration tag "F77" to libtool
checking for dm_init_service in -ldm... no
checking xfs/dmapi.h usability... no
checking xfs/dmapi.h presence... no
checking for xfs/dmapi.h... no
checking sys/dmi.h usability... no
checking sys/dmi.h presence... no
checking for sys/dmi.h... no
configure: creating ./config.status
 /bin/bash ./config.status
config.status: creating Makefile
config.status: WARNING:  'Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/Makefile
config.status: WARNING:  'src/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/common/Makefile
config.status: WARNING:  'src/common/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/common/cmd/Makefile
config.status: WARNING:  'src/common/cmd/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/common/lib/Makefile
config.status: WARNING:  'src/common/lib/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/suite1/Makefile
config.status: WARNING:  'src/suite1/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/suite1/cmd/Makefile
config.status: WARNING:  'src/suite1/cmd/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/sample_hsm/Makefile
config.status: WARNING:  'src/sample_hsm/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/simple/Makefile
config.status: WARNING:  'src/simple/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/suite2/Makefile
config.status: WARNING:  'src/suite2/Makefile.in' seems to ignore the --datarootdir setting
config.status: creating src/suite2/src/Makefile
config.status: WARNING:  'src/suite2/src/Makefile.in' seems to ignore the --datarootdir setting
config.status: executing depfiles commands
Making all in src
make[1]: Entering directory `/home/bradf/work/xfstests-dev/dmapi/src'
Making all in common
make[2]: Entering directory `/home/bradf/work/xfstests-dev/dmapi/src/common'
Making all in lib
make[3]: Entering directory `/home/bradf/work/xfstests-dev/dmapi/src/common/lib'
if /bin/sh ../../../libtool --mode=compile --tag=CC gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" -DPACKAGE=\"dmapi_tests\" -DVERSION=\"1.1\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -I. -I.   -I../../../src/common  -g -O2 -MT find_session.lo -MD -MP -MF ".deps/find_session.Tpo" -c -o find_session.lo find_session.c; \
	then mv -f ".deps/find_session.Tpo" ".deps/find_session.Plo"; else rm -f ".deps/find_session.Tpo"; exit 1; fi
mkdir .libs
 gcc -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" -DPACKAGE=\"dmapi_tests\" -DVERSION=\"1.1\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -I. -I. -I../../../src/common -g -O2 -MT find_session.lo -MD -MP -MF .deps/find_session.Tpo -c find_session.c  -fPIC -DPIC -o .libs/find_session.o
In file included from ../../../src/common/lib/hsm.h:35,
                 from find_session.c:19:
../../../src/common/lib/dmport.h:315:19: error: dmapi.h: No such file or directory
In file included from ../../../src/common/lib/hsm.h:35,
                 from find_session.c:19:
../../../src/common/lib/dmport.h:339: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:347: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:357: error: expected ')' before 'oldsid'
../../../src/common/lib/dmport.h:363: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:370: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:374: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:387: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:395: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:406: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:419: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:433: error: expected declaration specifiers or '...' before 'dm_config_t'
../../../src/common/lib/dmport.h:434: error: expected declaration specifiers or '...' before 'dm_size_t'
../../../src/common/lib/dmport.h:441: error: expected declaration specifiers or '...' before 'dm_eventset_t'
../../../src/common/lib/dmport.h:446: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:458: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:469: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:479: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:488: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:497: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:507: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:517: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:524: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:534: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:545: error: expected declaration specifiers or '...' before 'dm_sessid_t'
../../../src/common/lib/dmport.h:550: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:573: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'dm_handle_is_valid'
../../../src/common/lib/dmport.h:588: error: expected declaration specifiers or '...' before 'dm_fsid_t'
../../../src/common/lib/dmport.h:594: error: expected declaration specifiers or '...' before 'dm_igen_t'
../../../src/common/lib/dmport.h:600: error: expected declaration specifiers or '...' before 'dm_ino_t'
../../../src/common/lib/dmport.h:614: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:626: error: expected ')' before '*' token
../../../src/common/lib/dmport.h:632: error: expected ')' before '*' token
../../../src/common/lib/dmport.h:640: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:650: error: expected ')' before 'srcsid'
../../../src/common/lib/dmport.h:657: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:664: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:671: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:690: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:696: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:707: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:716: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:724: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:730: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'dm_read_invis'
../../../src/common/lib/dmport.h:741: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:748: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:757: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:766: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:775: error: expected ')' before 'targetsid'
../../../src/common/lib/dmport.h:782: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:791: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:802: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:811: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:820: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:829: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:839: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:848: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:859: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:866: error: expected ')' before 'sid'
../../../src/common/lib/dmport.h:872: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'dm_write_invis'
In file included from find_session.c:19:
../../../src/common/lib/hsm.h:68: error: expected specifier-qualifier-list before 'dm_eventtype_t'
../../../src/common/lib/hsm.h:77: error: expected specifier-qualifier-list before 'dm_right_t'
../../../src/common/lib/hsm.h:87: error: expected declaration specifiers or '...' before 'dm_off_t'
../../../src/common/lib/hsm.h:90: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:91: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:93: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:95: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:98: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:106: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:110: error: expected ')' before 'sid'
../../../src/common/lib/hsm.h:123: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:128: error: expected ')' before 'emask'
../../../src/common/lib/hsm.h:134: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:137: error: expected ')' before '*' token
../../../src/common/lib/hsm.h:140: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ev_name_to_value'
../../../src/common/lib/hsm.h:145: error: expected ')' before 'event'
../../../src/common/lib/hsm.h:150: error: expected declaration specifiers or '...' before 'dm_right_t'
../../../src/common/lib/hsm.h:154: error: expected ')' before 'right'
find_session.c: In function 'session_compare':
find_session.c:60: error: 'dm_sessid_t' undeclared (first use in this function)
find_session.c:60: error: (Each undeclared identifier is reported only once
find_session.c:60: error: for each function it appears in.)
find_session.c:60: error: expected expression before ')' token
find_session.c:60: error: expected expression before ')' token
find_session.c: At top level:
find_session.c:65: error: expected ')' before '*' token
make[3]: *** [find_session.lo] Error 1
make[3]: Leaving directory `/home/bradf/work/xfstests-dev/dmapi/src/common/lib'
make[2]: *** [all-recursive] Error 1
make[2]: Leaving directory `/home/bradf/work/xfstests-dev/dmapi/src/common'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/bradf/work/xfstests-dev/dmapi/src'
make: *** [all-recursive] Error 1

--------------000102040807070500090604--
