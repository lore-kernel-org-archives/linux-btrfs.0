Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35029 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755143AbdJISl2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Oct 2017 14:41:28 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Fstest: btrfs/151: test if device delete ends up with losing raid profile
Date: Mon,  9 Oct 2017 11:39:21 -0600
Message-Id: <20171009173921.12569-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently running 'btrfs device delete' can end up with losing data raid
profile (if any), this test is to reproduce the problem.

The fix is
     "Btrfs: avoid losing data raid profile when deleting a device"

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/151     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/151.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 76 insertions(+)
 create mode 100755 tests/btrfs/151
 create mode 100644 tests/btrfs/151.out

diff --git a/tests/btrfs/151 b/tests/btrfs/151
new file mode 100755
index 0000000..1866cb6
--- /dev/null
+++ b/tests/btrfs/151
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test 151
+#
+# Test if it's losing data chunk's raid profile after 'btrfs device
+# remove'.
+#
+# The fix is
+#	Btrfs: avoid losing data raid profile when deleting a device
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle.  All Rights Reserved.
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
+_require_scratch_dev_pool 3
+
+# create raid1 for data
+_scratch_pool_mkfs "-d raid1 -b 1G" >> $seqres.full 2>&1
+
+# we need an empty data chunk, so nospace_cache is required.
+_scratch_mount -onospace_cache
+
+# if data chunk is empty, 'btrfs device remove' can change raid1 to
+# single.
+$BTRFS_UTIL_PROG device delete 2 $SCRATCH_MNT >> $seqres.full
+
+df_ret=`$BTRFS_UTIL_PROG filesystem df $SCRATCH_MNT`
+echo $df_ret | $AWK_PROG -F ':' '/Data,/ {print $1}'
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/151.out b/tests/btrfs/151.out
new file mode 100644
index 0000000..0a1de06
--- /dev/null
+++ b/tests/btrfs/151.out
@@ -0,0 +1,2 @@
+QA output created by 151
+Data, RAID1
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e73bb1b..a7ff7b0 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -153,3 +153,4 @@
 148 auto quick rw
 149 auto quick send compress
 150 auto quick dangerous
+151 auto quick
-- 
2.5.0

