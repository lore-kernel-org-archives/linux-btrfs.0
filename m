Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751308AbdFZSXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 14:23:51 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: test incremental send after replacing directory with a file
Date: Mon, 26 Jun 2017 00:13:39 +0100
Message-Id: <20170625231339.479-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that an incremental send/receive operation works correctly after
moving some directory inode A, renaming a regular file inode B into the
old name of inode A and finally creating a new hard link for inode B at
directory inode A.

This issue is fixed by the following patch for the linux kernel:

  "Btrfs: incremental send, fix invalid path for link commands"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/147     | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/147.out |   6 +++
 tests/btrfs/group   |   1 +
 3 files changed, 137 insertions(+)
 create mode 100755 tests/btrfs/147
 create mode 100644 tests/btrfs/147.out

diff --git a/tests/btrfs/147 b/tests/btrfs/147
new file mode 100755
index 00000000..15517b0c
--- /dev/null
+++ b/tests/btrfs/147
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. btrfs/147
+#
+# Test that an incremental send/receive operation works correctly after moving
+# some directory inode A, renaming a regular file inode B into the old name of
+# inode A and finally creating a new hard link for inode B at directory inode A.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2017 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Filipe Manana <fdmanana@suse.com>
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -fr $send_files_dir
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_test
+_require_scratch
+_require_fssum
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+mkdir $SCRATCH_MNT/dir1
+mkdir $SCRATCH_MNT/dir1/dir2
+mkdir $SCRATCH_MNT/dir1/dir2/dir3
+mkdir $SCRATCH_MNT/dir5
+touch $SCRATCH_MNT/dir1/dir2/dir3/file1
+mkdir $SCRATCH_MNT/dir1/dir2/dir3/dir4
+
+# Filesystem looks like:
+#
+# .                                                      (ino 256)
+# |
+# |--- dir1/                                             (ino 257)
+# |      |--- dir2/                                      (ino 258)
+# |             |--- dir3/                               (ino 259)
+# |                   |--- file1                         (ino 261)
+# |                   |--- dir4/                         (ino 262)
+# |
+# |--- dir5/                                             (ino 260)
+#
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/mysnap1 > /dev/null
+
+$BTRFS_UTIL_PROG send -f $send_files_dir/1.snap \
+	$SCRATCH_MNT/mysnap1 2>&1 1>/dev/null | _filter_scratch
+
+mkdir $SCRATCH_MNT/dir1/dir6
+mv $SCRATCH_MNT/dir5 $SCRATCH_MNT/dir1/dir2/dir3/dir4/dir55
+ln $SCRATCH_MNT/dir1/dir2/dir3/file1 $SCRATCH_MNT/dir1/dir2/dir3/dir4/file11
+mv $SCRATCH_MNT/dir1/dir2/dir3/dir4 $SCRATCH_MNT/dir1/dir6/dir44
+mv $SCRATCH_MNT/dir1/dir2/dir3/file1 $SCRATCH_MNT/dir1/dir2/dir3/dir4
+
+# Filesystem now looks like:
+#
+# .                                                      (ino 256)
+# |
+# |--- dir1/                                             (ino 257)
+#        |--- dir2/                                      (ino 258)
+#        |      |--- dir3/                               (ino 259)
+#        |            |--- dir4                          (ino 261)
+#        |
+#        |--- dir6/                                      (ino 263)
+#               |--- dir44/                              (ino 262)
+#                      |--- file11                       (ino 261)
+#                      |--- dir55/                       (ino 260)
+#
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+		 $SCRATCH_MNT/mysnap2 > /dev/null
+
+$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 -f $send_files_dir/2.snap \
+		 $SCRATCH_MNT/mysnap2 2>&1 1>/dev/null | _filter_scratch
+
+$FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+$FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
+	-x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
+
+# Now recreate the filesystem by receiving both send streams and verify we get
+# the same content that the original filesystem had.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+$BTRFS_UTIL_PROG receive -f $send_files_dir/1.snap $SCRATCH_MNT > /dev/null
+$BTRFS_UTIL_PROG receive -f $send_files_dir/2.snap $SCRATCH_MNT > /dev/null
+$FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+$FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
+
+status=0
+exit
diff --git a/tests/btrfs/147.out b/tests/btrfs/147.out
new file mode 100644
index 00000000..06b94018
--- /dev/null
+++ b/tests/btrfs/147.out
@@ -0,0 +1,6 @@
+QA output created by 147
+At subvol SCRATCH_MNT/mysnap1
+At subvol SCRATCH_MNT/mysnap2
+At subvol mysnap1
+OK
+OK
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f74f50ca..2eb540e7 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -149,3 +149,4 @@
 144 auto quick send
 145 auto quick send
 146 auto quick
+147 auto quick send
-- 
2.11.0

