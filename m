From: Gabor MICSKO <gabor.micsko@gmail.com>
Subject: compile error on Ubuntu 8.10
Date: Wed, 26 Nov 2008 08:30:13 +0100
Message-ID: <1227684613.19460.99.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

FYI:

Hi,

if i try to compile the latest "hox fix" version of kernel module

http://www.kernel.org/hg/index.cgi/btrfs/kernel/archive/tip.tar.bz2

( kernel-417d87e57364.tar.bz2 )

on the recently released Ubuntu 8.10 "Interpid Ibex", i get the
following error messages:

/home/trey/devel/btrfs/kernel-417d87e57364/file.c: In function
'btrfs_file_write':
/home/trey/devel/btrfs/kernel-417d87e57364/file.c:881: error: implicit
declaration of function 'remove_suid'
make[2]: *** [/home/trey/devel/btrfs/kernel-417d87e57364/file.o] Error 1
make[1]: *** [_module_/home/trey/devel/btrfs/kernel-417d87e57364] Error
2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-7-generic'
make: *** [all] Error 2

Solution - at least - for me:

--- compat.h.orig	2008-11-26 08:16:51.000000000 +0100
+++ compat.h	2008-11-26 08:17:04.000000000 +0100
@@ -22,7 +22,7 @@
  * than nothing.
  */
 #ifdef CONFIG_SECURITY_APPARMOR
-# define REMOVE_SUID_PATH 1
+/* # define REMOVE_SUID_PATH 1 */
 #endif 
 
 #endif /* _COMPAT_H_ */


