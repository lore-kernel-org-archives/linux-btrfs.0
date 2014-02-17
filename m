Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57079 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaBQAXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 19:23:03 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so1890558wib.12
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 16:23:01 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add test for btrfs incremental send after dir renames
Date: Mon, 17 Feb 2014 00:22:32 +0000
Message-Id: <1392596552-6566-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392558260-14546-1-git-send-email-fdmanana@gmail.com>
References: <1392558260-14546-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs incremental send issue related to renaming of
directories. If at the time of the initial send we have a directory that is
a child of a directory with a higher inode number, and then later after the
initial full send we rename both the child and parent directories, but
without moving any of them, a subsequent incremental send would produce a
rename instruction for the child directory that pointed to an invalid path.
This made the btrfs receive operation fail.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: incremental send, fix invalid path after dir rename

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Updated test comments with correct inode numbers (their relatives differences
    was correct, only the absolute values were not for some of them). Make use
    of the new _run_btrfs_util_prog() function.

 tests/btrfs/041     |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/041.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 133 insertions(+)
 create mode 100755 tests/btrfs/041
 create mode 100644 tests/btrfs/041.out

diff --git a/tests/btrfs/041 b/tests/btrfs/041
new file mode 100755
index 0000000..5ebe6ca
--- /dev/null
+++ b/tests/btrfs/041
@@ -0,0 +1,131 @@
+#! /bin/bash
+# FS QA Test No. btrfs/041
+#
+# Regression test for a btrfs incremental send issue related to renaming of
+# directories. If at the time of the initial send we have a directory that is
+# a child of a directory with a higher inode number, and then later after the
+# initial full send we rename both the child and parent directories, but
+# without moving any of them, a subsequent incremental send would produce a
+# rename instruction for the child directory that pointed to an invalid path.
+# This made the btrfs receive operation fail.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: incremental send, fix invalid path after dir rename
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
+mkdir -p $SCRATCH_MNT/a/b
+mkdir $SCRATCH_MNT/d
+mkdir $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/d $SCRATCH_MNT/a/b/c
+mkdir $SCRATCH_MNT/e
+mkdir -p $SCRATCH_MNT/a/b/f/g
+mv $SCRATCH_MNT/e $SCRATCH_MNT/a/b/f/g
+
+# Filesystem looks like:
+#
+# .                      (ino 256)
+# |-- a                  (ino 257)
+#     |-- b              (ino 258)
+#         |-- c          (ino 260)
+#         |   |-- d      (ino 259)
+#         |
+#         |-- f          (ino 262)
+#             |-- g      (ino 263)
+#                 |-- e  (ino 261)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/a/b/x
+mv $SCRATCH_MNT/a/b/x/d $SCRATCH_MNT/a/b/x/y
+mv $SCRATCH_MNT/a/b/f $SCRATCH_MNT/a/b/w
+mv $SCRATCH_MNT/a/b/w/g/e $SCRATCH_MNT/a/b/w/g/z
+
+# Filesystem now looks like:
+#
+# .                      (ino 256)
+# |-- a                  (ino 257)
+#     |-- b              (ino 258)
+#         |-- x          (ino 260)
+#         |   |-- y      (ino 259)
+#         |
+#         |-- w          (ino 262)
+#             |-- g      (ino 263)
+#                 |-- z  (ino 261)
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
diff --git a/tests/btrfs/041.out b/tests/btrfs/041.out
new file mode 100644
index 0000000..309876c
--- /dev/null
+++ b/tests/btrfs/041.out
@@ -0,0 +1 @@
+QA output created by 041
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a687634..09e309c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -39,3 +39,4 @@
 034 auto quick
 036 auto quick
 040 auto quick
+041 auto quick
-- 
1.7.9.5

