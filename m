Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63121 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbcFNJ0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 05:26:41 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fdmanana@gmail.com, mfasheh@suse.de, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs: test if qgroup handle data balance correctly
Date: Tue, 14 Jun 2016 17:26:27 +0800
Message-Id: <20160614092627.15612-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs after v4.2 kernel will leaks qgroup numbers for relocated data
extents, due to the design of tree block direct swap.

This test case will check if such data balance will corrupt qgroup.

Reported-by: Mark Fasheh <mfasheh@suse.de>
Reported-by: Filipe Manana <fdmanana@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/028     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/028.out | 67 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 153 insertions(+)
 create mode 100755 tests/btrfs/028
 create mode 100644 tests/btrfs/028.out

diff --git a/tests/btrfs/028 b/tests/btrfs/028
new file mode 100755
index 0000000..16c6935
--- /dev/null
+++ b/tests/btrfs/028
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test 028
+#
+# Test if btrfs leaks qgroup numbers for data extents
+#
+# Due to balance code is doing trick tree block swap, which doing
+# non-standard extent reference update, qgroup can't handle it correctly,
+# and leads to corrupted qgroup numbers.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs
+# Need to use inline extents to fill metadata rapidly
+_scratch_mount "-o max_inline=2048"
+
+# create 64K inlined metadata, which will ensure there is a 2-level
+# metadata. Even for maximum nodesize(64K)
+for i in $(seq 32); do
+	_pwrite_byte 0xcdcdcdcd 0 2k $SCRATCH_MNT/small_$i | _filter_xfs_io
+done
+
+# then a large data write to make the quota corruption obvious enough
+_pwrite_byte 0xcdcdcdcd 0 32m $SCRATCH_MNT/large | _filter_xfs_io
+sync
+
+# enable quota and rescan to get correct number
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+# now balance data block groups to corrupt qgroup
+_run_btrfs_util_prog balance start -d $SCRATCH_MNT
+
+_scratch_unmount
+# generate a qgroup report and look for inconsistent groups
+$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
+		grep -E "Counts for qgroup.*are different"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
new file mode 100644
index 0000000..7ec6b0d
--- /dev/null
+++ b/tests/btrfs/028.out
@@ -0,0 +1,67 @@
+QA output created by 028
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2048/2048 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33554432/33554432 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 50b13d6..44531ab 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -30,6 +30,7 @@
 025 auto quick send clone
 026 auto quick compress prealloc
 027 auto replace
+028 auto quick qgroup
 029 auto quick clone
 030 auto quick send
 031 auto quick subvol clone
-- 
2.5.5



