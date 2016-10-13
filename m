Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:45423 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754029AbcJMLE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:04:59 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 2/4] btrfs: add test for an incremental send add gen for is_waiting_for_rm when some corner case
Date: Thu, 13 Oct 2016 19:04:11 +0800
Message-Id: <1476356653-22839-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1476356653-22839-1-git-send-email-robbieko@synology.com>
References: <1476356653-22839-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

There a one case for old_gen waiting_for_rm,
but new_gen use get_cur_path with the same inode.

This test exercises scenarios used to fail in btrfs and are fixed by
the following patches for the linux kernel:

"Btrfs: incremental send, add gen for is_waiting_for_rm when some corner case"
"Btrfs: incremental send, add gen for send_utimes in apply_dir_move"

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 tests/btrfs/132     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/132.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/btrfs/132
 create mode 100644 tests/btrfs/132.out

diff --git a/tests/btrfs/132 b/tests/btrfs/132
new file mode 100755
index 0000000..1ecd3b5
--- /dev/null
+++ b/tests/btrfs/132
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. btrfs/132
+#
+# Test that an incremental send operation,
+# add gen for is_waiting_for_rm when some corner case.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
+mkdir $SCRATCH_MNT/dir257
+mkdir $SCRATCH_MNT/dir258
+mkdir $SCRATCH_MNT/dir259
+mv $SCRATCH_MNT/dir257 $SCRATCH_MNT/dir258/dir257
+
+# Filesystem looks like:
+#
+# .                                                             (ino 256)
+# |--- dir258/                                                  (ino 258)
+# |    |--- dir257/                                             (ino 257)
+# |
+# |--- dir259/                                                  (ino 259)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+mv $SCRATCH_MNT/dir258/dir257 $SCRATCH_MNT/dir257
+rmdir $SCRATCH_MNT/dir258
+rmdir $SCRATCH_MNT/dir259
+_scratch_unmount
+_scratch_mount
+touch $SCRATCH_MNT/file258
+mkdir $SCRATCH_MNT/new_dir259
+mv $SCRATCH_MNT/dir257 $SCRATCH_MNT/new_dir259/dir257
+
+# Filesystem now looks like:
+#
+# .                                                             (ino 256)
+# |--- file258                                                  (ino 258)
+# |
+# |--- new_dir259/                                              (ino 259)
+# |    |--- dir257/                                             (ino 257)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/2.fssum \
+        -x $SCRATCH_MNT/mysnap2/mysnap1 $SCRATCH_MNT/mysnap2
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
diff --git a/tests/btrfs/132.out b/tests/btrfs/132.out
new file mode 100644
index 0000000..b096312
--- /dev/null
+++ b/tests/btrfs/132.out
@@ -0,0 +1,2 @@
+QA output created by 132
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a7a070a..1b12382 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -134,3 +134,4 @@
 129 auto quick send
 130 auto clone send
 131 auto quick send
+132 auto quick send
-- 
1.9.1

