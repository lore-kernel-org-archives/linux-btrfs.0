Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35532 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbcGKLSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 07:18:11 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/3] btrfs: add test for incremental send after removing a directory
Date: Sat,  2 Jul 2016 13:32:38 +0100
Message-Id: <1467462758-14550-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that, under a particular scenario, an incremental send operation does
not leak memory (which used to emit a warning in dmesg/syslog).

This is a regression test for a btrfs kernel fix that has the title:
"Btrfs: send, fix warning due to late freeing of orphan_dir_info
structures".

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/125     | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/125.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 130 insertions(+)
 create mode 100755 tests/btrfs/125
 create mode 100644 tests/btrfs/125.out

diff --git a/tests/btrfs/125 b/tests/btrfs/125
new file mode 100755
index 0000000..2ee39c7
--- /dev/null
+++ b/tests/btrfs/125
@@ -0,0 +1,127 @@
+#! /bin/bash
+# FS QA Test No. btrfs/125
+#
+# Test that, under a particular scenario, an incremental send operation does
+# not leak memory (which used to emit a warning in dmesg/syslog).
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
+mkdir $SCRATCH_MNT/a
+mkdir $SCRATCH_MNT/tmp
+mkdir $SCRATCH_MNT/del
+mv $SCRATCH_MNT/tmp $SCRATCH_MNT/del
+mkdir $SCRATCH_MNT/a/c
+mkdir $SCRATCH_MNT/del/x
+mkdir $SCRATCH_MNT/del/y
+
+# Filesystem looks like:
+#
+# .                                                             (ino 256)
+# |--- a/                                                       (ino 257)
+# |    |--- c/                                                  (ino 260)
+# |
+# |--- del/                                                     (ino 259)
+#       |--- tmp/                                               (ino 258)
+#       |--- x/                                                 (ino 261)
+#       |--- y/                                                 (ino 262)
+#
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+# It used to be that when attempting to issue an rmdir operation for inode 259,
+# the kernel allocated an orphan_dir_info structure so that later after doing
+# the delayed rename operation for inode 258 (which happened once inode 260 was
+# renamed) it would check if it could finally issue a rmdir instruction for
+# inode 259. If it couldn't, it would not release the previously allocated
+# orphan_dir_info structure immediately. Instead it would only release it once
+# it finished the send stream and it would emit a warning in dmesg/syslog.
+#
+mv $SCRATCH_MNT/a/c $SCRATCH_MNT
+mv $SCRATCH_MNT/del/x $SCRATCH_MNT/a
+mv $SCRATCH_MNT/del/y $SCRATCH_MNT/a
+mv $SCRATCH_MNT/del/tmp $SCRATCH_MNT/c
+rmdir $SCRATCH_MNT/del
+
+# Filesystem now looks like:
+#
+# .                                                             (ino 256)
+# |--- a/                                                       (ino 257)
+# |    |--- x/                                                  (ino 261)
+# |    |--- y/                                                  (ino 262)
+# |
+# |--- c/                                                       (ino 260)
+#      |--- tmp/                                                (ino 258)
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
diff --git a/tests/btrfs/125.out b/tests/btrfs/125.out
new file mode 100644
index 0000000..0cfa697
--- /dev/null
+++ b/tests/btrfs/125.out
@@ -0,0 +1,2 @@
+QA output created by 125
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 19f4688..82443f6 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -127,3 +127,4 @@
 122 auto quick snapshot qgroup
 123 auto quick qgroup
 124 auto quick send
+125 auto quick send
-- 
2.7.0.rc3

