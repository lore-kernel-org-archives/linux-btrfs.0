Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40152 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbdEIS55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 14:57:57 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Eryu Guan <eguan@redhat.com>
Subject: [PATCH 5/6] fstests: regression test for nocsum dio read's repair
Date: Tue,  9 May 2017 11:56:10 -0600
Message-Id: <1494352571-17199-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
References: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
introduced this regression.  It'd cause 'Segmentation fault' error.

The upstream fix is
	Btrfs: fix segment fault when doing dio read

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/142     | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/142.out |  39 +++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 177 insertions(+)
 create mode 100755 tests/btrfs/142
 create mode 100644 tests/btrfs/142.out

diff --git a/tests/btrfs/142 b/tests/btrfs/142
new file mode 100755
index 0000000..953ef0a
--- /dev/null
+++ b/tests/btrfs/142
@@ -0,0 +1,137 @@
+#! /bin/bash
+# FS QA Test 142
+#
+# Regression test for btrfs DIO read's repair during read without checksum.
+#
+# Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
+# introduced this regression.  It'd cause 'Segmentation fault' error.
+#
+# The upstream fix is
+#	Btrfs: fix segment fault when doing dio read
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
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
+_require_scratch_dev_pool 2
+
+_require_btrfs_command inspect-internal dump-tree
+_require_command "$FILEFRAG_PROG" filefrag
+
+get_physical()
+{
+        # $1 is logical address
+        # print chunk tree and find devid 2 which is $SCRATCH_DEV
+        $BTRFS_UTIL_PROG inspect-internal dump-tree -t 3 $SCRATCH_DEV | \
+	grep $1 -A 6 | awk '($1 ~ /stripe/ && $3 ~ /devid/ && $4 ~ /1/) { print $6 }'
+}
+
+
+SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
+
+start_fail()
+{
+	echo 100 > $DEBUGFS_MNT/fail_make_request/probability
+	echo 2 > $DEBUGFS_MNT/fail_make_request/times
+	echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
+	echo 1 > $SYSFS_BDEV/make-it-fail
+}
+
+stop_fail()
+{
+	echo 0 > $DEBUGFS_MNT/fail_make_request/probability
+	echo 0 > $DEBUGFS_MNT/fail_make_request/times
+	echo 0 > $SYSFS_BDEV/make-it-fail
+}
+
+_scratch_dev_pool_get 2
+# step 1, create a raid1 btrfs which contains one 128k file.
+echo "step 1......mkfs.btrfs" >>$seqres.full
+
+mkfs_opts="-d raid1 -b 1G"
+_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
+
+# -o nospace_cache makes sure data is written to the start position of the data
+# chunk
+_scratch_mount -o nospace_cache,nodatasum
+
+$XFS_IO_PROG -f -d -c "pwrite -S 0xaa -b 128K 0 128K" "$SCRATCH_MNT/foobar" | _filter_xfs_io
+
+# step 2, corrupt the first 64k of one copy (on SCRATCH_DEV which is the first
+# one in $SCRATCH_DEV_POOL
+echo "step 2......corrupt file extent" >>$seqres.full
+
+${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar >> $seqres.full
+logical_in_btrfs=`${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar | _filter_filefrag | cut -d '#' -f 1`
+physical_on_scratch=`get_physical ${logical_in_btrfs}`
+
+_scratch_unmount
+$XFS_IO_PROG -d -c "pwrite -S 0xbb -b 64K $physical_on_scratch 64K" $SCRATCH_DEV | _filter_xfs_io
+
+_scratch_mount -o nospace_cache,nodatasum
+
+# step 3, 128k dio read (this read can repair bad copy)
+echo "step 3......repair the bad copy" >>$seqres.full
+
+# since raid1 consists of two copies, and the following read may read the good
+# copy directly, so lets loop 10 times here and discard output that dio reads
+# give
+for i in `seq 1 10`; do
+	# start_fail only fails the following dio read so the repair is
+	# supposed to work.
+	start_fail
+	$XFS_IO_PROG -d -c "pread -b 128K 0 128K" "$SCRATCH_MNT/foobar" > /dev/null
+	stop_fail
+	_get_current_dmesg | grep -q -e "direct IO failed" && break
+done
+
+_scratch_unmount
+
+# check if the repair works
+$XFS_IO_PROG -c "pread -v -b 512 $physical_on_scratch 512" $SCRATCH_DEV | _filter_xfs_io
+
+_scratch_dev_pool_put
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/142.out b/tests/btrfs/142.out
new file mode 100644
index 0000000..d8be7fb
--- /dev/null
+++ b/tests/btrfs/142.out
@@ -0,0 +1,39 @@
+QA output created by 142
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 136708096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+08260000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260010:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260020:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260030:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260040:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260050:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260060:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260070:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260080:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260090:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082600a0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082600b0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082600c0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082600d0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082600e0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082600f0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260100:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260110:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260120:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260130:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260140:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260150:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260160:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260170:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260180:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+08260190:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082601a0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082601b0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082601c0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082601d0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082601e0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+082601f0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
+read 512/512 bytes at offset 136708096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 7b380e5..a4f97cd 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -143,3 +143,4 @@
 139 auto qgroup
 140 auto quick
 141 auto quick
+142 auto quick
-- 
2.5.0

