Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbbI1I6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 04:58:20 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs, test read corruption of compressed extents differently
Date: Mon, 28 Sep 2015 09:58:12 +0100
Message-Id: <1443430692-4292-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Regression test for file read corruption when using compressed extents
that represent file ranges with a length that is a multiple of 16 pages
and that are shared by multiple consecutive ranges of the same file.

This is similar to the test added in commit 694db0c050d6 ("btrfs: read
corruption of compressed extents"), but tests the special case where the
extent's uncompressed length is a multiple of 16 pages. The first btrfs
fix, tested by the test added in the commit mentioned before, failed to
address this special case.

This btrfs issue is fixed by the linux kernel patch titled:
"Btrfs: update fix for read corruption of compressed and shared extents"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/105     | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/105.out | 17 ++++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 115 insertions(+)
 create mode 100755 tests/btrfs/105
 create mode 100644 tests/btrfs/105.out

diff --git a/tests/btrfs/105 b/tests/btrfs/105
new file mode 100755
index 0000000..30e1a98
--- /dev/null
+++ b/tests/btrfs/105
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FSQA Test No. 105
+#
+# Regression test for file read corruption when using compressed extents
+# that represent file ranges with a length that is a multiple of 16 pages
+# and that are shared by multiple consecutive ranges of the same file.
+#
+#-----------------------------------------------------------------------
+#
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cloner
+
+rm -f $seqres.full
+
+test_clone_and_read_compressed_extent()
+{
+	local mount_opts=$1
+
+	_scratch_mkfs >>$seqres.full 2>&1
+	_scratch_mount $mount_opts
+
+	# Create our test file with a single extent of 64Kb that is going to be
+	# compressed no matter which compression algorithm is used (zlib/lzo).
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 64K" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+	# Now clone the compressed extent into an adjacent file offset.
+	$CLONER_PROG -s 0 -d $((64 * 1024)) -l $((64 * 1024)) \
+		$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+	echo "File digest before unmount:"
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+	# Remount the fs or clear the page cache to trigger the bug in btrfs.
+	# Because the extent has an uncompressed length that is a multiple of
+	# 16 pages, all the pages belonging to the second range of the file
+	# (64K to 128K), which points to the same extent as the first range
+	# (0K to 64K), had their contents full of zeroes instead of the byte
+	# 0xaa. This was a bug exclusively in the read path of compressed
+	# extents, the correct data was stored on disk, btrfs just failed to
+	# fill in the pages correctly.
+	_scratch_remount
+
+	echo "File digest after remount:"
+	# Must match the digest we got before.
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+}
+
+echo -e "\nTesting with zlib compression..."
+test_clone_and_read_compressed_extent "-o compress=zlib"
+
+_scratch_unmount
+
+echo -e "\nTesting with lzo compression..."
+test_clone_and_read_compressed_extent "-o compress=lzo"
+
+status=0
+exit
diff --git a/tests/btrfs/105.out b/tests/btrfs/105.out
new file mode 100644
index 0000000..101da10
--- /dev/null
+++ b/tests/btrfs/105.out
@@ -0,0 +1,17 @@
+QA output created by 105
+
+Testing with zlib compression...
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest before unmount:
+be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
+File digest after remount:
+be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
+
+Testing with lzo compression...
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest before unmount:
+be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
+File digest after remount:
+be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 4d99714..b9936f9 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -107,3 +107,4 @@
 102 auto quick metadata enospc
 103 auto quick clone compress
 104 auto quick send
+105 auto quick clone compress
-- 
2.1.3

