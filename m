Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41173 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3GCJqd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 05:46:33 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com
Subject: [PATCH] Xfstests/btrfs/308: add snapshot-aware defrag for partial extents testcases
Date: Wed,  3 Jul 2013 17:46:20 +0800
Message-Id: <1372844780-31845-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is to test whether snapshot-aware defrag can work well on partial extents.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/308     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/308.out |    2 +
 tests/btrfs/group   |    1 +
 3 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/308
 create mode 100644 tests/btrfs/308.out

diff --git a/tests/btrfs/308 b/tests/btrfs/308
new file mode 100755
index 0000000..b3dd39c
--- /dev/null
+++ b/tests/btrfs/308
@@ -0,0 +1,93 @@
+#! /bin/bash
+# BTRFS QA Test No. 308
+#
+# Test if snapshot-aware defrag can work well on partial extents, ie.
+# extent_offset is not zero.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle.  All Rights Reserved.
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
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_command "/usr/sbin/filefrag"
+
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+subvol=$SCRATCH_MNT/subvol
+
+$BTRFS_UTIL_PROG subvolume create $subvol >> $seqres.full
+
+for i in `seq 5 -1 1`
+do
+	dd if=/dev/zero of=$subvol/foobar bs=6k count=1 seek=$i conv=notrunc oflag=dsync 2>> $seqres.full
+done
+
+sync
+for i in `seq 2 -1 1`
+do
+	$BTRFS_UTIL_PROG subvolume snapshot $subvol $SCRATCH_MNT/snap-$i >> $seqres.full
+done
+
+$BTRFS_UTIL_PROG filesystem defrag $subvol/foobar && sync
+
+num_extent_orig=`filefrag $subvol/foobar | awk -F ' ' '{print $2}'`
+num_extent_snap1=`filefrag $SCRATCH_MNT/snap-1/foobar | awk -F ' ' '{print $2}'`
+num_extent_snap2=`filefrag $SCRATCH_MNT/snap-2/foobar | awk -F ' ' '{print $2}'`
+
+echo "$num_extent_orig $num_extent_snap1 $num_extent_snap2" >> $seqres.full
+
+# if error
+if [ "x$num_extent_snap1" != "x$num_extent_orig" -o "x$num_extent_snap2" != "x$num_extent_orig" ]; then
+	echo "number of extents mis-match!"
+	exit
+fi
+
+# optional stuff if your test has verbose output to help resolve problems
+#echo
+#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
+
+# success, all done
+echo "done"
+status=0
+exit
diff --git a/tests/btrfs/308.out b/tests/btrfs/308.out
new file mode 100644
index 0000000..1f3de82
--- /dev/null
+++ b/tests/btrfs/308.out
@@ -0,0 +1,2 @@
+QA output created by 308
+done
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..666054b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -9,3 +9,4 @@
 276 auto rw metadata
 284 auto
 307 auto quick
+308 auto quick
-- 
1.7.7

