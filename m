Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751327AbbHEBJT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 21:09:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH v2] fstests: btrfs: Add regression test for reserved space leak.
Date: Wed, 5 Aug 2015 09:08:34 +0800
Message-ID: <1438736914-28147-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The regression is introduced in v4.2-rc1, with the big btrfs qgroup
change.
The problem is, qgroup reserved space is never freed, causing even we
increase the limit, we can still hit the EDQUOT much faster than it
should.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/089     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/089.out |  5 +++
 tests/btrfs/group   |  1 +
 3 files changed, 94 insertions(+)
 create mode 100755 tests/btrfs/089
 create mode 100644 tests/btrfs/089.out

diff --git a/tests/btrfs/089 b/tests/btrfs/089
new file mode 100755
index 0000000..82db96c
--- /dev/null
+++ b/tests/btrfs/089
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test 089
+#
+# Regression test for btrfs qgroup reserved space leak.
+#
+# Due to qgroup reserved space leak, EDQUOT can be trigged even it's not
+# over limit after previous write.
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
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+# Use big blocksize to ensure there is still enough space left
+# for metadata reserve after hitting EDQUOT
+BLOCKSIZE=$(( 2 * 1024 * 1024 ))
+FILESIZE=$(( 128 * 1024 * 1024 )) # 128Mbytes 
+
+# The last block won't be able to finish write, as metadata takes
+# $NODESIZE space, causing the last block triggering EDQUOT
+LENGTH=$(( $FILESIZE - $BLOCKSIZE ))
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+_require_fs_space $SCRATCH_MNT $(($FILESIZE * 2 / 1024))
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog qgroup limit $FILESIZE 5 $SCRATCH_MNT
+
+$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE 0 $LENGTH" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# A sync is needed to trigger a commit_transaction.
+# As the reserved space freeing happens at commit_transaction time,
+# without a transaction commit, no reserved space needs freeing and
+# won't trigger the bug.
+sync
+
+# Double the limit to allow further write
+_run_btrfs_util_prog qgroup limit $(($FILESIZE * 2)) 5 $SCRATCH_MNT
+
+# Test whether further write can succeed
+$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE $LENGTH $LENGTH" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/089.out b/tests/btrfs/089.out
new file mode 100644
index 0000000..396888f
--- /dev/null
+++ b/tests/btrfs/089.out
@@ -0,0 +1,5 @@
+QA output created by 089
+wrote 132120576/132120576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 132120576/132120576 bytes at offset 132120576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index ffe18bf..225b532 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -91,6 +91,7 @@
 086 auto quick clone
 087 auto quick send
 088 auto quick metadata
+089 auto quick qgroup
 090 auto quick metadata
 091 auto quick qgroup
 092 auto quick send
-- 
1.8.3.1

