From: Francis Galiegue <fgaliegue@gmail.com>
Subject: [PATCH] btrfsck.c: #include <sys/stat.h> to avoid compile failures with glibc >= 2.12
Date: Sat,  4 Sep 2010 12:16:18 +0200
Message-ID: <1283595378-28405-1-git-send-email-fgaliegue@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Francis Galiegue <fgaliegue@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Avoid these warnings during compile:

----
btrfsck.c: In function =E2=80=98maybe_free_inode_rec=E2=80=99:
btrfsck.c:323: warning: implicit declaration of function =E2=80=98S_ISD=
IR=E2=80=99
btrfsck.c:328: warning: implicit declaration of function =E2=80=98S_ISR=
EG=E2=80=99
btrfsck.c:328: warning: implicit declaration of function =E2=80=98S_ISL=
NK=E2=80=99
----

leading to a link failure:

----
btrfsck.o: In function `maybe_free_inode_rec':
btrfsck.c:(.text+0x110e): undefined reference to `S_ISDIR'
btrfsck.c:(.text+0x113b): undefined reference to `S_ISREG'
btrfsck.c:(.text+0x11eb): undefined reference to `S_ISREG'
btrfsck.c:(.text+0x1252): undefined reference to `S_ISLNK'
btrfsck.c:(.text+0x1289): undefined reference to `S_ISLNK'
----
---
 btrfsck.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 73f1836..c1f47a1 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
+#include <sys/stat.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
--=20
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
