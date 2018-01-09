Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751575AbeAIHqi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 02:46:38 -0500
From: Pavel Raiskup <praiskup@redhat.com>
To: bug-tar@gnu.org
Cc: Mark H Weaver <mhw@netris.org>, linux btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Re: [Bug-tar] Detection of sparse files is broken on btrfs
Date: Tue, 09 Jan 2018 08:46:36 +0100
Message-ID: <5923534.bzxSDfjug7@nb.usersys.redhat.com>
In-Reply-To: <87fu7hccci.fsf@netris.org>
References: <87fu7hccci.fsf@netris.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1537565.GD2qFbBCsi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1537565.GD2qFbBCsi
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, January 8, 2018 3:29:17 AM CET Mark H Weaver wrote:
> I propose that we revisit this bug and fix it.  We clearly cannot assume that
> st_blocks == 0 implies that the file contains only zeroes.

. only on btrfs, as far as we know, because of some race condition.  So
what about special casing that filesystem, where we can lseek() for holes
anyway?  Since I would prefer fixing btrfs, I'm CC'ing devels again.

I'm attaching tar patch (public domain, use as you wish) mostly for
discussion about the idea (I can or anybody finalize the ifdef-hell,
etc.).  Note this fixes the failing sparse03.at for me (Fedora 27 x86_64 +
btrfs).

references for btrfs guys:
https://www.mail-archive.com/bug-tar@gnu.org/msg05453.html
https://www.spinics.net/lists/linux-btrfs/msg56768.html

Pavel

--nextPart1537565.GD2qFbBCsi
Content-Disposition: attachment; filename="btrfs-wholesparse.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="btrfs-wholesparse.patch"

diff --git a/src/sparse.c b/src/sparse.c
index d41c0ea..d0a7a55 100644
--- a/src/sparse.c
+++ b/src/sparse.c
@@ -18,6 +18,7 @@
 #include <system.h>
 #include <inttostr.h>
 #include <quotearg.h>
+#include <sys/statfs.h>
 #include "common.h"
 
 struct tar_sparse_file;
@@ -261,12 +262,58 @@ sparse_scan_file_raw (struct tar_sparse_file *file)
   return tar_sparse_scan (file, scan_end, NULL);
 }
 
+enum sparse_fs_behavior
+  {
+    sparse_fs_behavior_init = 0,
+    sparse_fs_behavior_fine,
+    sparse_fs_behavior_uncertain
+  };
+
+static enum sparse_fs_behavior
+check_sparse_behavior (int fd)
+{
+  struct statfs buf;
+  if (fstatfs (fd, &buf))
+    return sparse_fs_behavior_fine;
+
+  if (buf.f_type == 0x9123683e)
+    return sparse_fs_behavior_uncertain; /* btrfs */
+
+  return sparse_fs_behavior_fine;
+}
+
+static bool
+wholesparse_detection_prohibited (struct tar_stat_info *st)
+{
+  static dev_t cached_device = 0;
+  static enum sparse_fs_behavior behavior;
+
+  if (behavior == sparse_fs_behavior_init
+      || cached_device != st->stat.st_dev)
+    {
+      cached_device = st->stat.st_dev;
+      behavior = check_sparse_behavior (st->fd);
+    }
+
+  return behavior == sparse_fs_behavior_uncertain;
+}
+
+
 static bool
 sparse_scan_file_wholesparse (struct tar_sparse_file *file)
 {
   struct tar_stat_info *st = file->stat_info;
   struct sp_array sp = {0, 0};
 
+  /* Some file-systems report st_blksize=0 for files which have some
+     inode-inlined data.  This is, per bug-tar@, rather unfortunate
+     behavior, but we need to deal with these filesystems somehow.  So,
+     let's prohibit the "wholesparse" detection method for such filesystems,
+     and let's hope that 'SEEK_HOLE/SEEK_DATA' works (if not, we fallback to
+     slow-but-safe 'raw' method anyway).  */
+  if (wholesparse_detection_prohibited (file->stat_info))
+    return false;
+
   /* Note that this function is called only for truly sparse files of size >= 1
      block size (checked via ST_IS_SPARSE before).  See the thread
      http://www.mail-archive.com/bug-tar@gnu.org/msg04209.html for more info */

--nextPart1537565.GD2qFbBCsi--



