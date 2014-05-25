Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45057 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEYB6I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 21:58:08 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: test for btrfs send when nested subvols/snapshots exist
Date: Sun, 25 May 2014 03:45:24 +0100
Message-Id: <1400985924-16431-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for a btrfs incremental send issue where the difference
between the snapshots used by the incremental send consists of one of
these cases:

1) First snapshot has a directory with name X and in the second snapshot
   that directory doesn't exist anymore but a subvolume/snapshot with
   the same name (X) exists;

2) First snapshot has a subvolume/snapshot with name X and in the second
   snapshot that subvolume/snapshot doesn't exist anymore (might have been
   replaced by a directory with the same name or not).

This issue is fixed by the following linux kernel btrfs patches:

    Btrfs: send, don't error in the presence of subvols/snapshots
    Btrfs: set dead flag on the right root when destroying snapshot

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/054     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/054.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 111 insertions(+)
 create mode 100755 tests/btrfs/054
 create mode 100644 tests/btrfs/054.out

diff --git a/tests/btrfs/054 b/tests/btrfs/054
new file mode 100755
index 0000000..215861c
--- /dev/null
+++ b/tests/btrfs/054
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. btrfs/054
+#
+# Regression test for a btrfs incremental send issue where the difference
+# between the snapshots used by the incremental send consists of one of
+# these cases:
+#
+# 1) First snapshot has a directory with name X and in the second snapshot
+#    that directory doesn't exist anymore but a subvolume/snapshot with
+#    the same name (X) exists;
+#
+# 2) First snapshot has a subvolume/snapshot with name X and in the second
+#    snapshot that subvolume/snapshot doesn't exist anymore (might have been
+#    replaced by a directory with the same name or not).
+#
+# This issue is fixed by the following linux kernel btrfs patches:
+#
+#    Btrfs: send, don't error in the presence of subvols/snapshots
+#    Btrfs: set dead flag on the right root when destroying snapshot
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    rm -fr $send_files_dir
+    rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+mkdir $SCRATCH_MNT/testdir
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/first_subvol
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+# Replace the directory testdir with a subvolume that has the same name.
+rmdir $SCRATCH_MNT/testdir
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/testdir
+
+# Delete the subvolume first_subvol and create a directory with the same name.
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/first_subvol
+mkdir $SCRATCH_MNT/first_subvol
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap2 -p $SCRATCH_MNT/mysnap1 \
+	-f $send_files_dir/2.snap
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+[ -e $SCRATCH_MNT/first_subvol ] && \
+	echo "Subvolume first_subvol was not supposed to be replicated by full send!"
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+[ -e $SCRATCH_MNT/testdir ] && \
+	echo "Directory testdir was supposed to be deleted after incremental send!"
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/054.out b/tests/btrfs/054.out
new file mode 100644
index 0000000..03e258b
--- /dev/null
+++ b/tests/btrfs/054.out
@@ -0,0 +1 @@
+QA output created by 054
diff --git a/tests/btrfs/group b/tests/btrfs/group
index ea49c5c..b668485 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -56,3 +56,4 @@
 051 auto quick
 052 auto quick
 053 auto quick
+054 auto quick
-- 
1.9.1

