From: C Anthony Risinger <anthony@extof.me>
Subject: missing include from btrfsck.c?
Date: Wed, 9 Jun 2010 19:11:37 -0500
Message-ID: <AANLkTikZeG26t38KwkTYZITlKpHGkCKPKDHwSU5eJNRx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

i'm not a C developer, but i like to think i know enough to be
dangerous (pragmatic) :-D

building from git master failed with:

=2E.........
=2E.........
gcc -Wp,-MMD,./.btrfsck.o.d,-MT,btrfsck.o -Wall -D_FILE_OFFSET_BITS=3D6=
4
-D_FORTIFY_SOURCE=3D2 -g -Werror -Os -c btrfsck.c
cc1: warnings being treated as errors
btrfsck.c: In function =91maybe_free_inode_rec=92:
btrfsck.c:323:2: error: implicit declaration of function =91S_ISDIR=92
btrfsck.c:328:2: error: implicit declaration of function =91S_ISREG=92
btrfsck.c:328:2: error: implicit declaration of function =91S_ISLNK=92
make: *** [btrfsck.o] Error 1

grepping the source turned up several other files successfully using
those functions.  after a quick serach, it looked to be a part of
stat... and the other files were all including <sys/stat.h>. i'm not
sure if it's my gcc being paranoid (archlinux), but adding:

#include <sys/stat.h>

to btrfsck.c fixed the issue for me.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
