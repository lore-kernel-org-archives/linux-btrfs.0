Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35106 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754311AbbCLMKf (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 12 Mar 2015 08:10:35 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test for btrfs incremental send/receive
Date: Sun,  8 Mar 2015 17:51:30 +0000
Message-Id: <1425837090-27069-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test for incremental send where the difference between the parent and
send snapshots is that for a subtree with the same path in both snapshots
(p1/p2), the root directories were swapped.

This issue was fixed by the following linux kernel btrfs patch:

  Btrfs: incremental send, clear name from cache after orphanization

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/084     | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/084.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 135 insertions(+)
 create mode 100755 tests/btrfs/084
 create mode 100644 tests/btrfs/084.out

diff --git a/tests/btrfs/084 b/tests/btrfs/084
new file mode 100755
index 0000000..a9e26be
--- /dev/null
+++ b/tests/btrfs/084
@@ -0,0 +1,132 @@
+#! /bin/bash
+# FS QA Test No. btrfs/084
+#
+# Test for incremental send where the difference between the parent and send
+# snapshots is that for a subtree with the same path in both snapshots (p1/p2),
+# the root directories were swapped.
+#
+# This issue was fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: incremental send, clear name from cache after orphanization
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
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
+_require_scratch
+_require_fssum
+_need_to_be_root
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
+mkdir -p $SCRATCH_MNT/data/n1/n2/p1/p2
+mkdir $SCRATCH_MNT/data/n4
+mkdir -p $SCRATCH_MNT/data/p1/p2
+
+# Filesystem looks like:
+#
+# .                                       (ino 256)
+# |---- data                              (ino 257)
+#         |---- n1/                       (ino 258)
+#         |     |---- n2/                 (ino 259)
+#         |           |---- p1/           (ino 260)
+#         |                 |---- p2/     (ino 261)
+#         |
+#         |---- n4/                       (ino 262)
+#         |---- p1/                       (ino 263)
+#               |---- p2/                 (ino 264)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+# Now move directories around such that for the subtrees with the path "p1/p2"
+# we end up swapping the parents, that is, inode 263 becomes the parent of
+# inode 261 and inode 260 becomes the parent of inode 264. This makes the send
+# stream orphanize the inodes 263 and 264, and we want to verify the respective
+# rename operations don't fail, that they don't use incorrect paths.
+mv $SCRATCH_MNT/data/p1/p2 $SCRATCH_MNT/data
+mv $SCRATCH_MNT/data/n1/n2/p1/p2 $SCRATCH_MNT/data/p1
+mv $SCRATCH_MNT/data/p2 $SCRATCH_MNT/data/n1/n2/p1
+mv $SCRATCH_MNT/data/n1/n2 $SCRATCH_MNT/data/p1
+mv $SCRATCH_MNT/data/p1 $SCRATCH_MNT/data/n4
+mv $SCRATCH_MNT/data/n4/p1/n2/p1 $SCRATCH_MNT/data
+
+# Filesystem now looks like:
+#
+# .                                       (ino 256)
+# |---- data                              (ino 257)
+#         |---- n1/                       (ino 258)
+#         |---- n4/                       (ino 262)
+#         |     |---- p1/                 (ino 263)
+#         |           |---- n2/           (ino 259)
+#         |           |---- p2/           (ino 261)
+#         |
+#         |---- p1/                       (ino 260)
+#               |---- p2/                 (ino 264)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
+	-x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+# Now recreate the filesystem by receiving both send streams and verify we get
+# the same content that the original filesystem had.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+run_check $FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/084.out b/tests/btrfs/084.out
new file mode 100644
index 0000000..022f013
--- /dev/null
+++ b/tests/btrfs/084.out
@@ -0,0 +1,2 @@
+QA output created by 084
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fe82a9c..8f8dd42 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -86,3 +86,4 @@
 081 auto quick clone
 082 auto quick remount
 083 auto quick send
+084 auto quick send
-- 
2.1.3

