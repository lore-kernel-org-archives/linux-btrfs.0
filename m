Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbcF1Bzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 21:55:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: btrfs: Regression test for leaking data reserved space
Date: Tue, 28 Jun 2016 09:54:51 +0800
Message-Id: <20160628015451.13903-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs hits EDQUOTA when reserving data space, it will leak already
reserved data space.

This test case will check it by using more restrict enospc_debug mount
option to trigger kernel warning at umount time.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/124     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/124.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 76 insertions(+)
 create mode 100755 tests/btrfs/124
 create mode 100644 tests/btrfs/124.out

diff --git a/tests/btrfs/124 b/tests/btrfs/124
new file mode 100755
index 0000000..94a5b28
--- /dev/null
+++ b/tests/btrfs/124
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test 124
+#
+# Regression test for leaking data space after hitting EDQUOTA
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
+
+_scratch_mkfs
+# Use enospc_debug mount option to trigger restrict space info check
+_scratch_mount "-o enospc_debug"
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+_run_btrfs_util_prog qgroup limit 512K 0/5 $SCRATCH_MNT
+
+# The amount of written data may change due to different nodesize at mkfs time,
+# so redirect stdout to seqres.full.
+# Also, EDQUOTA is expected, which can't be redirected due to the limitation
+# of _filter_xfs_io, so golden output will include EDQUOTA error message
+_pwrite_byte 0xcdcdcdcd 0 1M $SCRATCH_MNT/test_file | _filter_xfs_io \
+	>> $seqres.full
+
+# Fstests will umount the fs, and at umount time, kernel warning will be
+# triggered
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/124.out b/tests/btrfs/124.out
new file mode 100644
index 0000000..6774792
--- /dev/null
+++ b/tests/btrfs/124.out
@@ -0,0 +1,2 @@
+QA output created by 124
+pwrite64: Disk quota exceeded
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5a26ed7..a398213 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -126,3 +126,4 @@
 121 auto quick snapshot qgroup
 122 auto quick snapshot qgroup
 123 auto quick qgroup
+124 auto quick qgroup
-- 
2.5.5



