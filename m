Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36730 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXLyv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:54:51 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so2904319wib.3
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 03:54:50 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add test for btrfs send issuing premature rmdir operations
Date: Mon, 24 Feb 2014 11:54:38 +0000
Message-Id: <1393242878-16039-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392820352-8550-1-git-send-email-fdmanana@gmail.com>
References: <1392820352-8550-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs incremental send issue where a rmdir instruction
is sent against an orphan directory inode which is not empty yet, causing
btrfs receive to fail when it attempts to remove the directory.

This issue is fixed by the following linux kernel btrfs patch:

   Btrfs: fix send attempting to rmdir non-empty directories

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Some cleanup as suggested by Dave Chinner. Use _check_scratch_fs() and
    removed redundant stderr redirection when calling fssum via run_check.

 tests/btrfs/041     |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/041.out |    1 +
 tests/btrfs/group   |    1 +
 3 files changed, 154 insertions(+)
 create mode 100755 tests/btrfs/041
 create mode 100644 tests/btrfs/041.out

diff --git a/tests/btrfs/041 b/tests/btrfs/041
new file mode 100755
index 0000000..bfc0e4b
--- /dev/null
+++ b/tests/btrfs/041
@@ -0,0 +1,152 @@
+#! /bin/bash
+# FS QA Test No. btrfs/041
+#
+# Regression test for btrfs incremental send issue where a rmdir instruction
+# is sent against an orphan directory inode which is not empty yet, causing
+# btrfs receive to fail when it attempts to remove the directory.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: fix send attempting to rmdir non-empty directories
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
+mkdir $SCRATCH_MNT/0
+mkdir $SCRATCH_MNT/1
+mkdir $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/0 $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/1 $SCRATCH_MNT/a/b/c
+echo 'ola mundo' > $SCRATCH_MNT/a/b/c/foo.txt
+mkdir $SCRATCH_MNT/a/b/c/x
+mkdir $SCRATCH_MNT/a/b/c/x2
+mkdir $SCRATCH_MNT/a/b/y
+mkdir $SCRATCH_MNT/a/b/z
+mkdir -p $SCRATCH_MNT/a/b/d1/d2/d3
+mkdir $SCRATCH_MNT/a/b/d4
+
+# Filesystem looks like:
+#
+# .                        (ino 256)
+# |-- a/                   (ino 257)
+#     |-- b/               (ino 258)
+#         |-- c/           (ino 261)
+#         |   |-- foo.txt  (ino 262)
+#         |   |-- 0/       (ino 259)
+#         |   |-- 1/       (ino 260)
+#         |   |-- x/       (ino 263)
+#         |   |-- x2/      (ino 264)
+#         |
+#         |-- y/           (ino 265)
+#         |-- z/           (ino 266)
+#         |-- d1/          (ino 267)
+#         |   |-- d2/      (ino 268)
+#         |       |-- d3/  (ino 269)
+#         |
+#         |-- d4/          (ino 270)
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+rm -f $SCRATCH_MNT/a/b/c/foo.txt
+mv $SCRATCH_MNT/a/b/y $SCRATCH_MNT/a/b/YY
+mv $SCRATCH_MNT/a/b/z $SCRATCH_MNT/a
+mv $SCRATCH_MNT/a/b/c/x $SCRATCH_MNT/a/b/YY
+mv $SCRATCH_MNT/a/b/c/0 $SCRATCH_MNT/a/b/YY/00
+mv $SCRATCH_MNT/a/b/c/x2 $SCRATCH_MNT/a/z/X_2
+mv $SCRATCH_MNT/a/b/c/1 $SCRATCH_MNT/a/z/X_2
+rmdir $SCRATCH_MNT/a/b/c
+mv $SCRATCH_MNT/a/b/d4 $SCRATCH_MNT/a/d44
+mv $SCRATCH_MNT/a/b/d1/d2 $SCRATCH_MNT/a/d44
+rmdir $SCRATCH_MNT/a/b/d1
+
+# Filesystem now looks like:
+#
+# .                        (ino 256)
+# |-- a/                   (ino 257)
+#     |-- b/               (ino 258)
+#     |   |-- YY/          (ino 265)
+#     |        |-- x/      (ino 263)
+#     |        |-- 00/     (ino 259)
+#     |
+#     |-- z/               (ino 266)
+#     |   |-- X_2/         (ino 264)
+#     |        |-- 1/      (ino 260)
+#     |
+#     |-- d44/             (ino 270)
+#          |-- d2/         (ino 268)
+#              |-- d3/     (ino 269)
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
+_check_scratch_fs
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
+
+_check_scratch_fs
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
index f5452b5..fd0193c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -43,3 +43,4 @@
 038 auto quick
 039 auto quick
 040 auto quick
+041 auto quick
-- 
1.7.9.5

