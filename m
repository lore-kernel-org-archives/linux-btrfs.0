Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbaCJDqd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Mar 2014 23:46:33 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] xfstests/btrfs: add stress test for btrfs quota operations
Date: Mon, 10 Mar 2014 11:44:11 +0800
Message-Id: <1394423051-17356-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So this is a stress test for btrfs quota operations. it can also
detect the following commit fixed problem:

4082bd3d73(Btrfs: fix oops when writting dirty qgroups to disk)

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	switch into new helper _run_btrfs_util_prog()
---
 tests/btrfs/043     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/043.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 79 insertions(+)
 create mode 100755 tests/btrfs/043
 create mode 100644 tests/btrfs/043.out

diff --git a/tests/btrfs/043 b/tests/btrfs/043
new file mode 100755
index 0000000..d6c4bf3
--- /dev/null
+++ b/tests/btrfs/043
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 043
+#
+# stresstest for btrfs quota operations. we run fsstress and quota
+# operations concurrently.
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
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_quota_enabled_background()
+{
+	i=1
+	while [ $i -le 5 ]
+	do
+		_run_btrfs_util_prog quota enable $SCRATCH_MNT
+		_run_btrfs_util_prog quota disable $SCRATCH_MNT
+		i=$(($i+1))
+		sleep 1
+	done
+}
+
+MKFS_SIZE=$((1024 * 1024 * 1024))
+run_check _scratch_mkfs_sized $MKFS_SIZE
+run_check _scratch_mount
+
+_quota_enabled_background &
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
+	$FSSTRESS_AVOID
+
+run_check _scratch_unmount
+_check_scratch_fs
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/043.out b/tests/btrfs/043.out
new file mode 100644
index 0000000..f90f0a5
--- /dev/null
+++ b/tests/btrfs/043.out
@@ -0,0 +1,2 @@
+QA output created by 043
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1037761..fabe3b5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -45,3 +45,4 @@
 040 auto quick
 041 auto quick
 042 auto quick
+043 auto quick
-- 
1.9.0

