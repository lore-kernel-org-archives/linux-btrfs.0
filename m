Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20317 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaBMDUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 22:20:51 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] xfstests/btrfs: add basic functional test for btrfs quota groups
Date: Thu, 13 Feb 2014 11:18:58 +0800
Message-Id: <1392261539-28903-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392261539-28903-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392261539-28903-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add missing test for btrfs quota groups feature,test idea is to create
a parent qgroup that groups some subvolume groups, we try to write
some data into every subvolume and then check if we exceed parent
qgroup's limit size.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/039     | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/039.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 97 insertions(+)
 create mode 100644 tests/btrfs/039
 create mode 100644 tests/btrfs/039.out

diff --git a/tests/btrfs/039 b/tests/btrfs/039
new file mode 100644
index 0000000..f8c9bee
--- /dev/null
+++ b/tests/btrfs/039
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 039
+#
+# Test the basic functionality of Quota groups
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
+    rm -f $tmp.*
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
+run_check _scratch_mkfs
+run_check _scratch_mount
+
+LIMIT_SIZE=$((10 * 1024 * 1024))
+
+run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+run_check $BTRFS_UTIL_PROG qgroup create 1/1 $SCRATCH_MNT
+run_check $BTRFS_UTIL_PROG qgroup limit $LIMIT_SIZE 1/1 $SCRATCH_MNT
+
+for i in `seq 10 -1 1`; do
+	#add newly created subvolume qgroup to it's parent qgroup
+	run_check $BTRFS_UTIL_PROG subvolume create -i 1/1 \
+		$SCRATCH_MNT/subv_$i
+done
+
+#try to write data into every subvolume
+for i in `seq 10 -1 1`; do
+	dd if=/dev/zero of=$SCRATCH_MNT/subv_$i/data bs=4k \
+		>> /dev/null 2>&1 &
+done
+
+wait
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT \
+	>>$seqres.full 2>&1
+
+total_written=0
+#calculate every subvolume's data.
+for i in `seq 10 -1 1`; do
+	#we may fail to create the file, skip this subvolume
+	test -f $SCRATCH_MNT/subv_$i || continue
+
+	filesize=`du -b $SCRATCH_MNT/subv_$i/data | $AWK_PROG '{print $1}'`
+	if [ $filesize -gt $LIMIT_SIZE ];then
+		_fail "subv_$i/data size should be less than $LIMIT_SIZE"
+	fi
+	total_written=$(($total_written+$filesize))
+done
+
+#check if total written exceeds limit
+if [ $total_written -gt $LIMIT_SIZE ];then
+	_fail "total written should be less than $LIMIT_SIZE"
+fi
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/039.out b/tests/btrfs/039.out
new file mode 100644
index 0000000..d4e7ef6
--- /dev/null
+++ b/tests/btrfs/039.out
@@ -0,0 +1,2 @@
+QA output created by 039
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 7ac9f0a..ba6b70c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -38,3 +38,4 @@
 033 auto quick
 034 auto quick
 038 auto quick
+039 auto quick
-- 
1.8.3.1

