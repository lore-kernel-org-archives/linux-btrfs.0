Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41906 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbbHTB50 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 21:57:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4] fstests: btrfs: Add reserved space leak check for rewrite  dirty page
Date: Thu, 20 Aug 2015 09:55:22 +0800
Message-ID: <1440035722-24981-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs qgroup reserve codes lacks check for rewrite dirty page, causing
every write, even rewriting a uncommitted dirty page, to reserve space.

But only written data will free the reserved space, causing reserved
space leaking.

The bug exists almost from the beginning of btrfs qgroup codes, but
nobody found it.

For example:

1)Write [0, 12K) into file A
  reserve 12K space

File A:
0	4K	8K	12K
|<--------dirty-------->|
reserved: 12K

2)Write [0,4K) into file A
0	4K	8K	12K
|<--------dirty-------->|
reserved: 16K <<< Should be 12K

3) Commit transaction
Dirty pages [0,12) written to disk.
Free 12K reserved space.
reserved: 4K <<< Should be 0

This testcase will test such problem.
Kernel fix will need some huge change, so won't be soon.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
Changelog:
v2:
  Use smaller write size inside loop, in case commit is trigger by dirty
page
  threshold, and ensure following write won't trigger EQUOT
v3:
  Add more comments and fix some expression.
v4:
  Rebase to latest fstests.
---
 tests/btrfs/095     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/095.out | 13 ++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 100 insertions(+)
 create mode 100755 tests/btrfs/095
 create mode 100644 tests/btrfs/095.out

diff --git a/tests/btrfs/095 b/tests/btrfs/095
new file mode 100755
index 0000000..f700cce
--- /dev/null
+++ b/tests/btrfs/095
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test 095
+#
+# Check for qgroup reserved space leaks caused by re-writing dirty ranges
+# This bug has been present in btrfs qgroup for a long time
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
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+# Use big blocksize to ensure there is still enough space left for metadata
+# space reserve.
+BLOCKSIZE=$(( 2 * 1024 * 1024 )) # 2M block size
+FILESIZE=$(( 128 * 1024 * 1024 )) # 128M file size
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+_require_fs_space $SCRATCH_MNT $(($FILESIZE * 2 / 1024))
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog qgroup limit $FILESIZE 5 $SCRATCH_MNT
+
+# loop 5 times without sync to ensure reserved space leak will happen
+for i in `seq 1 5`; do
+	# Use 1/4 of the file size, to ensure even commit is trigger by
+	# dirty page threshold or commit interval, we should still be
+	# able to continue write
+	$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE 0 $(($FILESIZE / 4))" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+done
+
+# Sync to make sure all the dirty pages are written to disk, which should
+# free all the reserved space
+sync
+
+# remove the file and sync, to ensure all quota space freed
+rm $SCRATCH_MNT/foo
+sync
+
+# We should be able to write $FILESIZE - $BLOCKSIZE data now
+$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE 0 $(($FILESIZE - $BLOCKSIZE))" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/095.out b/tests/btrfs/095.out
new file mode 100644
index 0000000..5675dac
--- /dev/null
+++ b/tests/btrfs/095.out
@@ -0,0 +1,13 @@
+QA output created by 095
+wrote 33554432/33554432 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33554432/33554432 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33554432/33554432 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33554432/33554432 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 33554432/33554432 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 132120576/132120576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index da37e46..13416ae 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -97,3 +97,4 @@
 092 auto quick send
 093 auto quick clone
 094 auto quick send
+095 auto quick qgroup
-- 
1.8.3.1

