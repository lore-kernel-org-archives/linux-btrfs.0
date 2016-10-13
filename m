Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:45625 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754040AbcJMLE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:04:59 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 3/4] btrfs: add test for an incremental send add gen check in did_overwrite_ref
Date: Thu, 13 Oct 2016 19:04:12 +0800
Message-Id: <1476356653-22839-4-git-send-email-robbieko@synology.com>
In-Reply-To: <1476356653-22839-1-git-send-email-robbieko@synology.com>
References: <1476356653-22839-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

There a some case, the old gen directory can not have new
data to write, can not cause overwitre ref, except inode 256.

This test exercises scenarios used to fail in btrfs and are fixed by
the following patches for the linux kernel:

"Btrfs: incremental send, add gen check in did_overwrite_ref"

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 tests/btrfs/133     | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/133.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 123 insertions(+)
 create mode 100755 tests/btrfs/133
 create mode 100644 tests/btrfs/133.out

diff --git a/tests/btrfs/133 b/tests/btrfs/133
new file mode 100755
index 0000000..e292c00
--- /dev/null
+++ b/tests/btrfs/133
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. btrfs/133
+#
+# Test that an incremental send operation,
+# the old gen directory can not have new
+# data to write, can not cause overwitre ref, except inode 256.
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
+touch $SCRATCH_MNT/f
+mkdir $SCRATCH_MNT/d1
+mkdir $SCRATCH_MNT/d259_old
+mv $SCRATCH_MNT/d1 $SCRATCH_MNT/d259_old/d1
+
+# Filesystem looks like:
+#
+# .                                                             (ino 256)
+# |--- f                                                        (ino 257)
+# |
+# |--- d259_old/                                                (ino 259)
+# |    |--- d1/                                                 (ino 258)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+mkdir $SCRATCH_MNT/d1
+mkdir $SCRATCH_MNT/dir258
+mkdir $SCRATCH_MNT/dir259
+mv $SCRATCH_MNT/d1 $SCRATCH_MNT/dir259/d1
+
+# Filesystem now looks like:
+#
+# .                                                             (ino 256)
+# |--- dir258                                                   (ino 258)
+# |
+# |--- dir259/                                                  (ino 259)
+# |    |--- d1/                                                 (ino 257)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+rm $send_files_dir/1.snap
+
+run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
+run_check $FSSUM_PROG -A -f -w $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
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
diff --git a/tests/btrfs/133.out b/tests/btrfs/133.out
new file mode 100644
index 0000000..e914d62
--- /dev/null
+++ b/tests/btrfs/133.out
@@ -0,0 +1,2 @@
+QA output created by 133
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1b12382..779caec 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -135,3 +135,4 @@
 130 auto clone send
 131 auto quick send
 132 auto quick send
+133 auto quick send
-- 
1.9.1

