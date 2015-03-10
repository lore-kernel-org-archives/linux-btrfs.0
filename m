Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54621 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbbCJHsi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 03:48:38 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
CC: <jbacik@fb.com>
Subject: [PATCH] fstest: btrfs/083: Test for incorrect exclusive refernce number after file clone.
Date: Tue, 10 Mar 2015 15:46:34 +0800
Message-ID: <1425973594-31936-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Problem]
Since commit fcebe4562dec83b3f8d308 ("Btrfs: rework qgroup accounting"),
quota data update is delayed after delayed_ref calculation, and lacks
correct protection to detect root reference which shouldn't be counted
in current sequence number but already written into extent backref.

This makes exclusive reference not decreased correctly and give incorrect
result.

[Test procedure]
1. Create a btrfs with 3 subvolumes, quota enabled and rescanned.
2. Create a file in 1st subvolume
3. Clone the file to 2nd and 3rd subvolume
4. Sync the fs to reflect the changes in qgroup.
5. Check the qgroup data

[Expected result]
None of the subvolume has exclusive reference to the file.

[Actual result]
The first subvolume still have exclusive reference to the file.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/083     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/083.out |  5 ++++
 tests/btrfs/group   |  1 +
 3 files changed, 82 insertions(+)
 create mode 100755 tests/btrfs/083
 create mode 100644 tests/btrfs/083.out

diff --git a/tests/btrfs/083 b/tests/btrfs/083
new file mode 100755
index 0000000..17fd30b
--- /dev/null
+++ b/tests/btrfs/083
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 083
+#
+# Test for incorrect exclusive reference count after cloning file
+# between subvolumes.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Fujitsu. All Rights Reserved.
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
+# real QA test starts here
+
+# Modify as appropriate.
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cp_reflink
+
+run_check _scratch_mkfs "--nodesize 4096"
+
+# inode cache will also take space in fs tree, disable them to get consistent
+# result.
+run_check _scratch_mount "-o noinode_cache"
+
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv1
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv2
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv3
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+dd if=/dev/zero of=$SCRATCH_MNT/subv1/file1 bs=4K count=64 &> /dev/null
+cp --reflink $SCRATCH_MNT/subv1/file1 $SCRATCH_MNT/subv2/file1
+cp --reflink $SCRATCH_MNT/subv1/file1 $SCRATCH_MNT/subv3/file1
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+
+units=`_btrfs_qgroup_units`
+$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
+	| $AWK_PROG '{print $2" "$3}'
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/083.out b/tests/btrfs/083.out
new file mode 100644
index 0000000..359b4a0
--- /dev/null
+++ b/tests/btrfs/083.out
@@ -0,0 +1,5 @@
+QA output created by 083
+4096 4096
+266240 4096
+266240 4096
+266240 4096
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fd2fa76..04d5d67 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -85,3 +85,4 @@
 080 auto snapshot
 081 auto quick clone
 082 auto quick remount
+083 auto quick qgroup
-- 
2.3.1

