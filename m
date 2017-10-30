Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:46772 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753389AbdJ3Wd5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 18:33:57 -0400
From: Justin Maggard <jmaggard10@gmail.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Subject: [PATCH] btrfs: test for qgroup reservation leaks with prealloc
Date: Mon, 30 Oct 2017 15:33:48 -0700
Message-Id: <20171030223348.22018-1-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test case writes into pre-allocated space, then tries to fallocate
some more within the defined quota limit. Currently (4.14-rc7) this fails
with EDQUOT due to quota reservation leakage when writing into pre-
allocated space.

A possible fix has been sent to the ML as "btrfs: Fix quota reservation
leak on preallocated files"

Signed-off-by: Justin Maggard <jmaggard@netgear.com>
---
 tests/btrfs/153     | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/153.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 75 insertions(+)
 create mode 100755 tests/btrfs/153
 create mode 100644 tests/btrfs/153.out

diff --git a/tests/btrfs/153 b/tests/btrfs/153
new file mode 100755
index 0000000..95a8095
--- /dev/null
+++ b/tests/btrfs/153
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FS QA Test 153
+#
+# Test for leaking quota reservations on preallocated files.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (c) 2017 NETGEAR, Inc.  All Rights Reserved.
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
+_require_btrfs_qgroup_report
+_require_xfs_io_command "falloc"
+
+_scratch_mkfs >/dev/null
+_scratch_mount
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+_run_btrfs_util_prog qgroup limit 100M 0/5 $SCRATCH_MNT
+
+testfile1=$SCRATCH_MNT/testfile1
+testfile2=$SCRATCH_MNT/testfile2
+$XFS_IO_PROG -fc "falloc 0 80M" $testfile1
+$XFS_IO_PROG -fc "pwrite 0 80M" $testfile1 > /dev/null
+$XFS_IO_PROG -fc "falloc 0 19M" $testfile2
+$XFS_IO_PROG -fc "pwrite 0 19M" $testfile2 > /dev/null
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/153.out b/tests/btrfs/153.out
new file mode 100644
index 0000000..cd9fe8a
--- /dev/null
+++ b/tests/btrfs/153.out
@@ -0,0 +1,2 @@
+QA output created by 153
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fb94461..15c2ecb 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -155,3 +155,4 @@
 150 auto quick dangerous
 151 auto quick
 152 auto quick metadata qgroup send
+153 auto quick qgroup
-- 
2.1.4

