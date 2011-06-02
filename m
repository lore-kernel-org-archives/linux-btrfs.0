From: "Fajar A. Nugraha" <list@fajar.net>
Subject: btrfs-progs-unstable tmp branch build error
Date: Thu, 2 Jun 2011 07:35:37 +0700
Message-ID: <BANLkTi=pYaAUreDRsLGC-5j_xzowDA02Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When building from tmp branch I got this error:

mkfs.c: In function =91main=92:
mkfs.c:730:6: error: =91ret=92 may be used uninitialized in this functi=
on
mkfs.c:841:43: error: =91parent_dir_entry=92 may be used uninitialized =
in
this function
make: *** [mkfs.o] Error 1


"git blame" shows the last commit for both lines was
commit e3736c698e8b490bea1375576b718a2de6e89603
Author: Donggeun Kim <dg77.kim@samsung.com>
Date:   Thu Jul 8 09:17:59 2010 +0000

    btrfs-progs: Add new feature to mkfs.btrfs to make file system
image file from source directory


Removing "-Werror" flag from Makefile made it compile succesfully thoug=
h.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
