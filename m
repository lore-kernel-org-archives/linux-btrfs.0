Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27802 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab3KZG7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 01:59:31 -0500
From: Miao Xie <miaox@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v3] xfstests,btrfs: add wrong compress type regression test
Date: Tue, 26 Nov 2013 15:00:23 +0800
Message-Id: <1385449223-28748-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <20131126064107.GN8803@dastard>
References: <20131126064107.GN8803@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs would crash when the users wrote some data into a file with compress
flag but the compression of the fs was disabled. This test case is to check
this bug still happen or not.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 tests/btrfs/022     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/022.out | 11 +++++++
 tests/btrfs/group   |  1 +
 3 files changed, 95 insertions(+)
 create mode 100755 tests/btrfs/022
 create mode 100644 tests/btrfs/022.out

diff --git a/tests/btrfs/022 b/tests/btrfs/022
new file mode 100755
index 0000000..1b61991
--- /dev/null
+++ b/tests/btrfs/022
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. btrfs/008
+#
+# btrfs wrong compression type regression test. This test is used to check
+# the oops will happen when the users write some data into the files whose
+# compress flag is set but the compression of the fs is disabled.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fujitsu.  All Rights Reserved.
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
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -f $tmp.*
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
+__workout()
+{
+	work_file="$SCRATCH_MNT/tmpfile"
+
+	touch $work_file
+	chattr =c $work_file
+	$XFS_IO_PROG -f -c "pwrite 0 1M" -c "fsync" $work_file | _filter_xfs_io
+}
+
+echo "*** test nodatacow"
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o nodatacow"
+__workout
+_scratch_unmount
+_check_scratch_fs
+
+echo "*** test compress=no"
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o compress=no"
+__workout
+_scratch_unmount
+_check_scratch_fs
+
+echo "*** test compress-force=no"
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount "-o compress-force=no"
+__workout
+_scratch_unmount
+_check_scratch_fs
+
+echo "*** done"
+status=0 ; exit
diff --git a/tests/btrfs/022.out b/tests/btrfs/022.out
new file mode 100644
index 0000000..e21b42c
--- /dev/null
+++ b/tests/btrfs/022.out
@@ -0,0 +1,11 @@
+QA output created by 022
+*** test nodatacow
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+*** test compress=no
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+*** test compress-force=no
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+*** done
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 410f8ed..c2adb2f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -24,3 +24,4 @@
 019 auto quick
 020 auto quick
 021 auto quick
+022 auto quick
-- 
1.8.3.1

