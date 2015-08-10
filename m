Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44893 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbbHJINM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 04:13:12 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs regression test for defrag tail extents
Date: Mon, 10 Aug 2015 16:12:59 +0800
Message-Id: <1439194379-29290-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs defragment tool, it's aimed to verify
that tail extents won't be skipped as a separate extent while the previous
extents have been defrag'ed into a whole extent.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/098     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 72 insertions(+)
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out

diff --git a/tests/btrfs/098 b/tests/btrfs/098
new file mode 100755
index 0000000..e4bb38a
--- /dev/null
+++ b/tests/btrfs/098
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test 098
+#
+# Test if btrfs defrag tool can merge tail extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Liu Bo.  All Rights Reserved.
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
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_defrag
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "pwrite 0 640k" $SCRATCH_MNT/foobar >> $seqres.full 2>&1
+
+# create sparse file layout
+for ((i = 160; i > 0; i--)); do
+	$XFS_IO_PROG -f -c "pwrite $((($RANDOM % 160) * 4))k 4k" \
+		$SCRATCH_MNT/foobar >> $seqres.full 2>&1
+done
+
+_defrag --after 1 $SCRATCH_MNT/foobar
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/098.out b/tests/btrfs/098.out
new file mode 100644
index 0000000..7306733
--- /dev/null
+++ b/tests/btrfs/098.out
@@ -0,0 +1,3 @@
+QA output created by 098
+Before: in_range(0, -1)
+After: 1
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e13865a..392de6d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -100,3 +100,4 @@
 095 auto quick metadata
 096 auto quick clone
 097 auto quick send clone
+098 auto defrag quick
-- 
1.8.2.1

