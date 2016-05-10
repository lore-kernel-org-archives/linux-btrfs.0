Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbcEJIkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 04:40:05 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: Test fiemap ioctl on completely deduped file
Date: Tue, 10 May 2016 16:39:41 +0800
Message-Id: <1462869581-19227-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For a completely deduped file, which means all its file extent are
pointing to one bytenr, if calling fiemap on it, btrfs will cause soft
hang up or just takes years long.

This bug can be reproduced even without any in-band or out-of-band
dedupe, normal clone_file_range() call can create such situation.

This test case will detect it.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/028     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/028.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 82 insertions(+)
 create mode 100755 tests/btrfs/028
 create mode 100644 tests/btrfs/028.out

diff --git a/tests/btrfs/028 b/tests/btrfs/028
new file mode 100755
index 0000000..62bcc9d
--- /dev/null
+++ b/tests/btrfs/028
@@ -0,0 +1,78 @@
+#! /bin/bash
+# FS QA Test 028
+#
+# Test fiemap ioctl on heavily deduped file.
+#
+# This test will cause btrfs to soft hang up or takes years long to finish
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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
+. ./common/reflink
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_reflink
+
+blocksize=$(( 128 * 1024 ))
+nr=4096
+file="$SCRATCH_MNT/tmp"
+
+_scratch_mkfs
+_scratch_mount
+
+# write the initial block for later reflink
+$XFS_IO_PROG -f -c "pwrite 0 $blocksize" -c "fsync" $file | _filter_xfs_io
+
+# use reflink to create the rest of the file, whose all extents are all
+# pointing to the first extent
+for i in $(seq 1 $nr); do
+	$XFS_IO_PROG -c "reflink $file 0 $(( $i * $blocksize )) $blocksize" \
+		$SCRATCH_MNT/tmp > /dev/null || _fail "reflink failed"
+done
+
+# then call fiemap on that file, which shouldn't hang the fs by all means
+$XFS_IO_PROG -c "fiemap" $file >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
new file mode 100644
index 0000000..2b5a9a5
--- /dev/null
+++ b/tests/btrfs/028.out
@@ -0,0 +1,3 @@
+QA output created by 028
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index da0e27f..8f6f877 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -30,6 +30,7 @@
 025 auto quick send clone
 026 auto quick compress prealloc
 027 auto replace
+028 auto clone
 029 auto quick clone
 030 auto quick send
 031 auto quick subvol clone
-- 
2.5.5



