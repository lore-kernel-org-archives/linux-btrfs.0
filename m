Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:32772 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBQAYV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 19:24:21 -0500
Received: by mail-we0-f169.google.com with SMTP id t61so10282391wes.0
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 16:24:20 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add test for btrfs send issuing duplicated rmdir ops
Date: Mon, 17 Feb 2014 00:23:56 +0000
Message-Id: <1392596636-6624-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392584574-10317-1-git-send-email-fdmanana@gmail.com>
References: <1392584574-10317-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs incremental send issue where an rmdir
instruction was sent multiple times for the same target directory.
The number of times depended on the number of hardlinks against
the same inode inside the target directory. That inode must have
had the highest number of all the inodes that were children of the
directory. This made the btrfs receive command fail immediately once
it received the second rmdir instruction.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: send, don't send rmdir for same target multiple times

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Make use of the new _run_btrfs_util_prog() function.

 tests/btrfs/042     |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/042.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 126 insertions(+)
 create mode 100755 tests/btrfs/042
 create mode 100644 tests/btrfs/042.out

diff --git a/tests/btrfs/042 b/tests/btrfs/042
new file mode 100755
index 0000000..1e40755
--- /dev/null
+++ b/tests/btrfs/042
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FS QA Test No. btrfs/042
+#
+# Regression test for btrfs incremental send issue where an rmdir
+# instruction was sent multiple times for the same target directory.
+# The number of times depended on the number of hardlinks against
+# the same inode inside the target directory. That inode must have
+# had the highest number of all the inodes that were children of the
+# directory. This made the btrfs receive command fail immediately once
+# it received the second rmdir instruction.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: send, don't send rmdir for same target multiple times
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=`mktemp -d`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+FSSUM_PROG=$here/src/fssum
+[ -x $FSSUM_PROG ] || _notrun "fssum not built"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/a/b/c
+echo 'hello world' > $SCRATCH_MNT/a/b/c/hel.txt
+echo 'ola mundo' > $SCRATCH_MNT/a/b/c/foo.txt
+ln $SCRATCH_MNT/a/b/c/foo.txt $SCRATCH_MNT/a/b/c/bar.txt
+ln $SCRATCH_MNT/a/b/c/foo.txt $SCRATCH_MNT/a/b/baz.txt
+
+# Filesystem looks like:
+#
+# .                        (ino 256)
+# |-- a/                   (ino 257)
+#     |-- b/               (ino 258)
+#         |-- c/           (ino 259)
+#         |   |-- hel.txt  (ino 260)
+#         |   |-- foo.txt  (ino 261)
+#         |   |-- bar.txt  (ino 261)
+#         |
+#         |-- baz.txt      (ino 261)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+rm -f $SCRATCH_MNT/a/b/c/foo.txt
+rm -f $SCRATCH_MNT/a/b/c/bar.txt
+rm -f $SCRATCH_MNT/a/b/c/hel.txt
+rmdir $SCRATCH_MNT/a/b/c
+
+# Filesystem now looks like:
+#
+# .                        (ino 256)
+# |-- a/                   (ino 257)
+#     |-- b/               (ino 258)
+#         |-- baz.txt      (ino 261)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
+	$SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $tmp/2.snap
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full
+
+_scratch_unmount
+_check_btrfs_filesystem $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/042.out b/tests/btrfs/042.out
new file mode 100644
index 0000000..b403295
--- /dev/null
+++ b/tests/btrfs/042.out
@@ -0,0 +1 @@
+QA output created by 042
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 09e309c..72279d5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -40,3 +40,4 @@
 036 auto quick
 040 auto quick
 041 auto quick
+042 auto quick
-- 
1.7.9.5

