From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: dkms build error
Date: Mon, 31 May 2010 09:20:22 +0200
Message-ID: <4C036336.6090708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Unfortunately, I did not succeed to compile a btrfs module via dkms fro=
m
btrfs-unstable (commit 9aeead73782c4b8e2a91def36dbf95db28605c95) for ke=
rnel
version 2.6.34-git16. For the exact error message, please see the make.=
log
attached. If I replace the symlink to btrfs-unstable/fs/btrfs by a suml=
ink
to the corresponding subdirectory of the kernel tree everything works w=
ell.

Thanks,
Andreas Philipp

aph@thor ~ $ cat /var/lib/dkms/btrfs/git/build/make.log
DKMS make.log for btrfs-git for kernel 2.6.34-git16 (x86_64)
Sun May 30 20:37:43 CEST 2010
make: Entering directory `/usr/src/linux-2.6.34-git16'
  LD      /var/lib/dkms/btrfs/git/build/built-in.o
  CC [M]  /var/lib/dkms/btrfs/git/build/super.o
/var/lib/dkms/btrfs/git/build/super.c: In function =91btrfs_fill_super=92=
:
/var/lib/dkms/btrfs/git/build/super.c:446: warning: assignment from inc=
ompatible pointer type
  CC [M]  /var/lib/dkms/btrfs/git/build/ctree.o
  CC [M]  /var/lib/dkms/btrfs/git/build/extent-tree.o
/var/lib/dkms/btrfs/git/build/extent-tree.c: In function =91btrfs_issue=
_discard=92:
/var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error: =91DISCARD_FL_=
BARRIER=92 undeclared (first use in this function)
/var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error: (Each undeclar=
ed identifier is reported only once
/var/lib/dkms/btrfs/git/build/extent-tree.c:1699: error: for each funct=
ion it appears in.)
make[1]: *** [/var/lib/dkms/btrfs/git/build/extent-tree.o] Error 1
make: *** [_module_/var/lib/dkms/btrfs/git/build] Error 2
make: Leaving directory `/usr/src/linux-2.6.34-git16'


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
