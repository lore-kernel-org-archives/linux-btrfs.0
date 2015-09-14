Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35254 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbINIaC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 04:30:02 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: regression test for btrfs read corruption of compressed extents
Date: Mon, 14 Sep 2015 09:29:38 +0100
Message-Id: <1442219378-16851-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Regression test for file read corruption when using compressed extents
that are shared by multiple consecutive ranges of the same file.

The btrfs issue is fixed by the linux kernel patch titled:
"Btrfs: fix read corruption of compressed and shared extents"

Without the corresponding fix the test fails because the second time it
reads the test files it gets different data (some pages are incorrectly
filled with zeroes) from the data it wrote before doing a clean ummount.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/100     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/100.out |  41 ++++++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 151 insertions(+)
 create mode 100755 tests/btrfs/100
 create mode 100644 tests/btrfs/100.out

diff --git a/tests/btrfs/100 b/tests/btrfs/100
new file mode 100755
index 0000000..dfef32d
--- /dev/null
+++ b/tests/btrfs/100
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FSQA Test No. 100
+#
+# Regression test for file read corruption when using compressed extents that
+# are shared by multiple consecutive ranges of the same file.
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
+	# Create a test file with a single extent that is compressed (the
+	# data we write into it is highly compressible no matter which
+	# compression algorithm is used, zlib or lzo).
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 4K"        \
+			-c "pwrite -S 0xbb 4K 8K"        \
+			-c "pwrite -S 0xcc 12K 4K"       \
+			$SCRATCH_MNT/foo | _filter_xfs_io
+
+	# Now clone our extent into an adjacent offset.
+	$CLONER_PROG -s $((4 * 1024)) -d $((16 * 1024)) -l $((8 * 1024)) \
+		$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+	# Same as before but for this file we clone the extent into a lower
+	# file offset.
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa 8K 4K"         \
+			-c "pwrite -S 0xbb 12K 8K"        \
+			-c "pwrite -S 0xcc 20K 4K"        \
+			$SCRATCH_MNT/bar | _filter_xfs_io
+
+	$CLONER_PROG -s $((12 * 1024)) -d 0 -l $((8 * 1024)) \
+		$SCRATCH_MNT/bar $SCRATCH_MNT/bar
+
+	echo "File digests before unmounting filesystem:"
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	md5sum $SCRATCH_MNT/bar | _filter_scratch
+
+	# Evicting the inode or clearing the page cache before reading again
+	# the file would also trigger the bug - reads were returning all bytes
+	# in the range corresponding to the second reference to the extent with
+	# a value of 0, but the correct data was persisted (it was a bug
+	# exclusively in the read path). The issue happened only if the same
+	# readpages() call targeted pages belonging to the first and second
+	# ranges that point to the same compressed extent.
+	_scratch_remount
+
+	echo "File digests after mounting filesystem again:"
+	# Must match the same digests we got before.
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	md5sum $SCRATCH_MNT/bar | _filter_scratch
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
diff --git a/tests/btrfs/100.out b/tests/btrfs/100.out
new file mode 100644
index 0000000..469b21e
--- /dev/null
+++ b/tests/btrfs/100.out
@@ -0,0 +1,41 @@
+QA output created by 100
+
+Testing with zlib compression...
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 12288
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 12288
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 20480
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests before unmounting filesystem:
+4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
+fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
+File digests after mounting filesystem again:
+4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
+fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
+
+Testing with lzo compression...
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 12288
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 12288
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 20480
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests before unmounting filesystem:
+4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
+fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
+File digests after mounting filesystem again:
+4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
+fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a8f458a..ad6d537 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -102,3 +102,4 @@
 097 auto quick send clone
 098 auto quick metadata clone
 099 auto quick metadata enospc
+100 auto quick clone compress
-- 
2.1.3

