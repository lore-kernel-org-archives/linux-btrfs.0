Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47547 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaJGPVg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 11:21:36 -0400
From: Wang Shilong <wangshilong1991@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: add regression for inode bad compression ratio detection
Date: Tue,  7 Oct 2014 19:20:49 -0400
Message-Id: <1412724049-50613-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test add a regression test to make sure btrfs dosen't set
inode NOCOMPRESS flag when a small write(<=blocksize) happens.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
Test is a little relying on btrfs now have a max 128k limit write, not sure
whether it is good since it is possible we may change it in the future, let me
know if you have better idea ^_^.
---
 tests/btrfs/060     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/060.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 76 insertions(+)
 create mode 100644 tests/btrfs/060
 create mode 100644 tests/btrfs/060.out

diff --git a/tests/btrfs/060 b/tests/btrfs/060
new file mode 100644
index 0000000..6ef2e0f
--- /dev/null
+++ b/tests/btrfs/060
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FS QA Test No. btrfs/060
+#
+# Regression test for btrfs incorrection inode ratio detection.
+# This was fixed in the following linux kernel patch:
+#
+#     Btrfs: fix incorrect compression ratio detection
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Wang Shilong.  All Rights Reserved.
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
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_test
+_require_scratch
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount "-o compress=lzo"
+
+$XFS_IO_PROG -f -c "pwrite 0 10M" -c "fsync" \
+	$SCRATCH_MNT/data >> $seqres.full 2>&1
+
+filefrag $SCRATCH_MNT/data | $AWK_PROG '{print $2}'
+
+$XFS_IO_PROG -f -c "pwrite 0 $((4096*33))" -c "fsync" \
+	$SCRATCH_MNT/data >> $seqres.full 2>&1
+
+$XFS_IO_PROG -f -c "pwrite 0 10M" -c "fsync" \
+	$SCRATCH_MNT/data >> $seqres.full 2>&1
+filefrag $SCRATCH_MNT/data | $AWK_PROG '{print $2}'
+
+status=0
+exit
diff --git a/tests/btrfs/060.out b/tests/btrfs/060.out
new file mode 100644
index 0000000..1c306d2
--- /dev/null
+++ b/tests/btrfs/060.out
@@ -0,0 +1,3 @@
+QA output created by 060
+80
+80
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 68b5c79..d06c163 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -62,3 +62,4 @@
 057 auto quick
 058 auto quick
 059 auto quick
+060 auto quick
-- 
1.8.3.1

