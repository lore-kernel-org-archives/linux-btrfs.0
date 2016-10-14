Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932618AbcJNRDu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 13:03:50 -0400
Subject: [PATCH] btrfs-progs: define FIEMAP_EXTENT_SHARED locally if needed
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, Abhay Sachan <lkp.abhay@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
 <454e3eda-1e46-4964-2ce5-f71893bd93e7@gmx.com>
 <20161012172657.GV11398@twin.jikos.cz>
 <eabfbf45-6cca-043d-b60b-34bede02dfc7@cn.fujitsu.com>
 <20161014154942.GB11398@twin.jikos.cz>
 <3caf7539-5eae-d085-1fc6-b48ce0ae99a2@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c9a18735-4127-2ab4-e93e-a32c50c49392@redhat.com>
Date: Fri, 14 Oct 2016 12:03:48 -0500
MIME-Version: 1.0
In-Reply-To: <3caf7539-5eae-d085-1fc6-b48ce0ae99a2@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As it stands today, btrfs-progs won't build if the installed
kernel headers don't define FIEMAP_EXTENT_SHARED.

But that doesn't tell us anything about the capabilities of
the /running/ kernel - so just define it locally if not found
in the fiemap header, and allow the build to proceed.

If run against an old kernel, worst case scenario is that
no shared extents will be reported via the du command.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

you can take it or leave it, but I had this locally 
anyway, so if it's helpful here you go :)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index a5b66e6..fa8f421 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -29,6 +29,11 @@
 #include <linux/fs.h>
 #include <linux/fiemap.h>
 
+/* Appeared upstream in 2.6.33 */
+#ifndef FIEMAP_EXTENT_SHARED
+#define FIEMAP_EXTENT_SHARED 0x00002000
+#endif
+
 #include "utils.h"
 #include "commands.h"
 #include "kerncompat.h"
diff --git a/configure.ac b/configure.ac
index 8fd8f42..9b87b24 100644
--- a/configure.ac
+++ b/configure.ac
@@ -144,8 +144,6 @@ if test "$DISABLE_BTRFSCONVERT" = 0 && test "x$convertfs" = "x"; then
 	AC_MSG_ERROR([no filesystems for convert, use --disable-convert instead])
 fi
 
-AX_CHECK_DEFINE([linux/fiemap.h], [FIEMAP_EXTENT_SHARED], [],
-		[AC_MSG_ERROR([no definition of FIEMAP_EXTENT_SHARED found])])
 
 dnl Define <NAME>_LIBS= and <NAME>_CFLAGS= by pkg-config
 dnl

