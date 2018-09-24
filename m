Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbeIXRti (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 13:49:38 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] test unaligned punch hole at ENOSPC
Date: Mon, 24 Sep 2018 19:47:39 +0800
Message-Id: <1537789659-29460-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Try to punch hole with unaligned size and offset when the FS
returns ENOSPC

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
This test case fails on btrfs as of now.

 tests/btrfs/172     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/172.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/btrfs/172
 create mode 100644 tests/btrfs/172.out

diff --git a/tests/btrfs/172 b/tests/btrfs/172
new file mode 100755
index 000000000000..9c32a173f912
--- /dev/null
+++ b/tests/btrfs/172
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle. All Rights Reserved.
+#
+# FS QA Test 172
+#
+# Test if the unaligned (by size and offset) punch hole is successful when FS
+# is at ENOSPC.
+#
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
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs_sized $((200 * 1024 *1024)) >> $seqres.full
+
+# max_inline helps to create regular extent
+_scratch_mount "-o max_inline=0,nodatacow"
+
+echo "Fill fs upto ENOSPC" >> $seqres.full
+dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
+
+extent_size=$(_scratch_btrfs_sectorsize)
+unalign_by=512
+echo extent_size=$extent_size unalign_by=$unalign_by >> $seqres.full
+
+hole_offset=0
+hole_len=$unalign_by
+run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
+
+hole_offset=$(($extent_size + $unalign_by))
+hole_len=$(($extent_size - $unalign_by))
+run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
+
+hole_offset=$(($extent_size * 2 + $unalign_by))
+hole_len=$(($extent_size * 5))
+run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/172.out b/tests/btrfs/172.out
new file mode 100644
index 000000000000..ce2de3f0d107
--- /dev/null
+++ b/tests/btrfs/172.out
@@ -0,0 +1,2 @@
+QA output created by 172
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index feffc45b6564..7e1a638ab7e1 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -174,3 +174,4 @@
 169 auto quick send
 170 auto quick snapshot
 171 auto quick qgroup
+172 auto quick
-- 
1.8.3.1
