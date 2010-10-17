From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: dkms build problem
Date: Sun, 17 Oct 2010 16:48:39 +0200
Message-ID: <4CBB0CC7.7000307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi,

I tried to follow this howto
https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Building_latest_btrfs_against_a_recent_kernel_with_DKMS
from the btrfs wiki to build my own btrfs module using dkms  on my
gentoo running kernel version 2.6.35.7.
But when trying to build the dkms module I have run into the following
compile error; see my make.log below. If you have any suggestions on
what I should try to fix this, i.e., other kernel version(s), patches
to kernel/btrfs-unstable, other compiler version(s), and so on, I am
willing to try out everything in order to help fix this. If this is a
known error, and the decision is to not fix it, as btrfs compiles well
within the regular kernel sources from kernel.org, then I would add a
comment about that in the corresponding section of the btrfs wiki.

Kind regards,
Andreas Philipp

make.log:
DKMS make.log for btrfs-git for kernel 2.6.35.7 (x86_64)
Sun Oct 17 16:35:28 CEST 2010
make: Entering directory `/usr/src/linux-2.6.35.7'
  LD      /var/lib/dkms/btrfs/git/build/built-in.o
  CC [M]  /var/lib/dkms/btrfs/git/build/super.o
/var/lib/dkms/btrfs/git/build/super.c: In function ?btrfs_fill_super?:
/var/lib/dkms/btrfs/git/build/super.c:448: warning: assignment from
incompatible pointer type
  CC [M]  /var/lib/dkms/btrfs/git/build/ctree.o
  CC [M]  /var/lib/dkms/btrfs/git/build/extent-tree.o
/var/lib/dkms/btrfs/git/build/extent-tree.c: In function
?btrfs_issue_discard?:
/var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error:
?DISCARD_FL_BARRIER? undeclared (first use in this function)
/var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error: (Each
undeclared identifier is reported only once
/var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error: for each
function it appears in.)
make[1]: *** [/var/lib/dkms/btrfs/git/build/extent-tree.o] Error 1
make: *** [_module_/var/lib/dkms/btrfs/git/build] Error 2
make: Leaving directory `/usr/src/linux-2.6.35.7'
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJMuwzFAAoJEJIcBJ3+Xkgims8P/1rX9HpYUyVBAD/wfzFaDqKH
Jq9GnI1bW9hXJMoo2l9CtVt1rSvuTFiTkK4bxuBXyt1A4eoSZ8M4exVZsYLH1+ef
+9BoJmXENnI4gDaga0N6wobjocBpvlBHYm+b2h6pP7AJFEKMXgrOra5khUc7wd3N
/Izr3Cewb9CQIr040PDOMoZCEV0iQOoSQf4ECOE3qcizq8VUqeCIiBLcH3cwTpxW
BD4AMCe/ArgirmhtPwHv2zn1RR6+vsen7oPT7tWLW86y7S4UeWGxJHRK1eTOaXlY
givWYxcHX9UvVcvCoBVvrOz2d9B5ZQM+XgTe5DztTh58cZApt7SJe4Z3Icrq4dpb
7BMmXcUwPbWRbc0/LhiCtq7J88pcDthmrNIyoengIwCoBVJu0AxTkm3s+wDh8zTy
4okNEfvl0n5l97X19hp77qeaK+ObnENAqgY2VI/yoNPnM/TbCRGyHyF9l6O3O8i/
C3QDb4U7ECPtjG8mpk1yQARqJ2hReRNslfhrMAK4BL/6cCwYx9MdslfgfwDqt+5o
VyB0E5g6+6SK7p3uuLpS92B4bDYT9Wt02YdXrbAFc5R61YUYGdSb+tr73L8a845f
Ups/FAblLSZ5TSgrBF8fmY5AJqWQl4suXNZCl8wMzeMBT5jv8adjR5dBEEtDLeSC
tHD1ignOphVos7+32ZRV
=4doD
-----END PGP SIGNATURE-----

