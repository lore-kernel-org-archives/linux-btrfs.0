Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60930 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBCPWu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2014 10:22:50 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so7166203pab.24
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Feb 2014 07:22:49 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: [PATCH] Btrfs: add regression test for running snapshot and send concurrently
Date: Mon,  3 Feb 2014 23:22:36 +0800
Message-Id: <1391440956-31924-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Btrfs would fail to send if snapshot run concurrently, this test is to make
sure we have fixed the bug.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/034     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/034.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 78 insertions(+)
 create mode 100644 tests/btrfs/034
 create mode 100644 tests/btrfs/034.out

diff --git a/tests/btrfs/034 b/tests/btrfs/034
new file mode 100644
index 0000000..e27e3cf
--- /dev/null
+++ b/tests/btrfs/034
@@ -0,0 +1,75 @@
+#!/bin/bash
+# FS QA Test No. btrfs/034
+#
+# Regression test for running snapshots and send concurrently.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
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
+#
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
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+
+touch $SCRATCH_MNT/foo
+
+# get file with fragments by using backwards writes.
+for i in `seq 10240 -1 1`; do
+	$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
+	$SCRATCH_MNT/foo > /dev/null | _filter_xfs_io
+done
+
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
+
+$BTRFS_UTIL_PROG send -f $SCRATCH_MNT/send_file \
+	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1 &
+
+pid=$!
+
+$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT/snap_1 \
+	$SCRATCH_MNT/snap_2 >> $seqres.full 2>&1
+
+wait $pid || echo "Failed to send, see dmesg"
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/034.out b/tests/btrfs/034.out
new file mode 100644
index 0000000..4c8873c
--- /dev/null
+++ b/tests/btrfs/034.out
@@ -0,0 +1,2 @@
+QA output created by 034
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index b29236c..f9f062f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -36,3 +36,4 @@
 031 auto quick
 032 auto quick
 033 auto quick
+034 auto quick
-- 
1.8.4

