Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23552 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753319AbbI3Gbm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 02:31:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH] fstests: btrfs: Check if fallocate re-truncates page beyond EOF
Date: Wed, 30 Sep 2015 14:31:38 +0800
Message-ID: <1443594698-5285-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even the fallocate range doesn't cover the last page of a file, btrfs
will still re-truncate the last page.

Such behavior is completely duplicated and unneeded, and fixed by the
following kernel patch:

btrfs: Avoid truncate tailing page if fallocate range doesn't exceed
inode size

Add this test case to check that malfunction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/104     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/104.out |  3 ++
 tests/btrfs/group   |  1 +
 3 files changed, 87 insertions(+)
 create mode 100755 tests/btrfs/104
 create mode 100644 tests/btrfs/104.out

diff --git a/tests/btrfs/104 b/tests/btrfs/104
new file mode 100755
index 0000000..f3ddc15
--- /dev/null
+++ b/tests/btrfs/104
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test 104
+#
+# Test that calling fallocate against a range which is already
+# allocated does not truncate beyond EOF
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Fujitsu. All Rights Reserved.
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
+. ./common/defrag
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+# Use 64K file size to match any sectorsize
+# And with a unaligned tailing range to ensure it will be at least 2 pages
+filesize=$(( 64 * 1024 + 1024 ))
+
+# Fallocate a range that will not cover the tailing page
+fallocrange=$(( 64 * 1024 ))
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+$XFS_IO_PROG -f -c "pwrite 0 $filesize" $SCRATCH_MNT/foo | _filter_xfs_io
+sync
+orig_extent_nr=`_extent_count $SCRATCH_MNT/foo`
+
+# As all space are allocated and even written to disk, this falloc
+# should do nothing with extent modification.
+$XFS_IO_PROG -f -c "falloc 0 $fallocrange" $SCRATCH_MNT/foo
+sync
+new_extent_nr=`_extent_count $SCRATCH_MNT/foo`
+
+echo "orig: $orig_extent_nr, new: $new_extent_nr" >> $seqres.full
+
+if [ "x$orig_extent_nr" != "x$new_extent_nr" ]; then
+	echo "Extent beyond EOF is re-truncated"
+	echo "orig_extent_nr: $orig_extent_nr new_extent_nr: $new_extent_nr"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/104.out b/tests/btrfs/104.out
new file mode 100644
index 0000000..4c43e17
--- /dev/null
+++ b/tests/btrfs/104.out
@@ -0,0 +1,3 @@
+QA output created by 104
+wrote 66560/66560 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e92a65a..640336b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -106,3 +106,4 @@
 101 auto quick replace
 102 auto quick metadata enospc
 103 auto quick clone compress
+104 auto quick prealloc
-- 
1.8.3.1

