Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52544 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923AbbJIJRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 05:17:42 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] fstests: test btrfs send with shared and compressed extents
Date: Fri,  9 Oct 2015 02:12:06 +0100
Message-Id: <1444353126-31869-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1444263854-26683-1-git-send-email-fdmanana@kernel.org>
References: <1444263854-26683-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that a send operation works correctly with reflinked files (cloned
extents which multiple files point to) that have compressed extents.

This used to fail on btrfs, resulting in different file digests after
receiving the send stream, and got fixed by the linux kernel patch
titled:

  "Btrfs: send, fix file corruption due to incorrect cloning operations"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Simplified the test. It also now covers a case that was failing before
    with the initial version of the btrfs fix (and was failing too without
    that fix).

 tests/btrfs/107     | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/107.out |  13 ++++++
 tests/btrfs/group   |   1 +
 3 files changed, 125 insertions(+)
 create mode 100755 tests/btrfs/107
 create mode 100644 tests/btrfs/107.out

diff --git a/tests/btrfs/107 b/tests/btrfs/107
new file mode 100755
index 0000000..4fbfed9
--- /dev/null
+++ b/tests/btrfs/107
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. btrfs/107
+#
+# Test that a send operation works correctly with reflinked files (cloned
+# extents which multiple files point to) that have compressed extents.
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
+_require_scratch
+_need_to_be_root
+_require_cp_reflink
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o compress"
+
+# Create our file with an extent of 100K starting at file offset 0K.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 100K"       \
+		-c "fsync"                        \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Rewrite part of the previous extent (its first 40K) and write a new 100K
+# extent starting at file offset 100K.
+$XFS_IO_PROG -c "pwrite -S 0xbb 0K 40K"    \
+		-c "pwrite -S 0xcc 100K 100K"      \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Our file foo now has 3 file extent items in its metadata:
+#
+# 1) One covering the file range 0 to 40K;
+# 2) One covering the file range 40K to 100K, which points to the first extent
+#    we wrote to the file and has a data offset field with value 40K (our file
+#    no longer uses the first 40K of data from that extent);
+# 3) One covering the file range 100K to 200K.
+
+# Now clone our file foo into file bar.
+cp --reflink=always $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+# Create our snapshot for the send operation.
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap
+
+echo "File digests in the original filesystem:"
+md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap/bar | _filter_scratch
+
+_run_btrfs_util_prog send $SCRATCH_MNT/snap -f $send_files_dir/1.snap
+
+# Now recreate the filesystem by receiving the send stream and verify we get
+# the same file contents that the original filesystem had.
+# Btrfs send used to issue a clone operation from foo's range [80K, 140K[ to
+# bar's range [40K, 100K[ when cloning the extent pointed to by foo's second
+# file extent item, this was incorrect because of bad accounting of the file
+# extent item's data offset field. The correct range to clone from should have
+# been [40K, 100K[.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o compress"
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+
+echo "File digests in the new filesystem:"
+# Must match the digests we got in the original filesystem.
+md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap/bar | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/107.out b/tests/btrfs/107.out
new file mode 100644
index 0000000..da251f3
--- /dev/null
+++ b/tests/btrfs/107.out
@@ -0,0 +1,13 @@
+QA output created by 107
+wrote 102400/102400 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 40960/40960 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 102400/102400 bytes at offset 102400
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the original filesystem:
+253f558dbd25727d7d2fdb77f9ad2590  SCRATCH_MNT/snap/foo
+253f558dbd25727d7d2fdb77f9ad2590  SCRATCH_MNT/snap/bar
+File digests in the new filesystem:
+253f558dbd25727d7d2fdb77f9ad2590  SCRATCH_MNT/snap/foo
+253f558dbd25727d7d2fdb77f9ad2590  SCRATCH_MNT/snap/bar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index ae16213..886bdd8 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -109,3 +109,4 @@
 104 auto quick send
 105 auto quick clone compress
 106 auto quick send clone
+107 auto quick send clone compress
-- 
2.1.3

