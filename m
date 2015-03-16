Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37336 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbbCPHW4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 03:22:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH] fstest: btrfs/083: Test for incorrect exclusive refernce number after file clone.
Date: Mon, 16 Mar 2015 15:22:55 +0800
Message-ID: <1426490575-20955-1-git-send-email-quwenruo@cn.fujitsu.com>
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
changelog:
v2:
   Redirect error output of dd to seqres.full for debug in case dd
   failed.
v3:
   Add support and check for old kernel which doesn't support
   noinode_cache mount option.
   Change nodesize to 64K to support arch whose page size can be larger
   than 4K.
---
 tests/btrfs/083     | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/083.out |   5 +++
 tests/btrfs/group   |   1 +
 3 files changed, 109 insertions(+)
 create mode 100755 tests/btrfs/083
 create mode 100644 tests/btrfs/083.out

diff --git a/tests/btrfs/083 b/tests/btrfs/083
new file mode 100755
index 0000000..da9b92e
--- /dev/null
+++ b/tests/btrfs/083
@@ -0,0 +1,103 @@
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
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cp_reflink
+
+rm -f $seqres.full
+
+# use largest node/leaf size (64K) to allow the test to be run on arch with
+# page size > 4k.
+NODESIZE=65536
+SUPPORT_NOINODE_CACHE="yes"
+
+run_check _scratch_mkfs "--nodesize $NODESIZE"
+
+# inode cache will also take space in fs tree, disable them to get consistent
+# result.
+# discard error output since we will check return value manually.
+_scratch_mount "-o noinode_cache" 2> /dev/null
+
+# Check for old kernel which doesn't support 'noinode_cache' mount option
+if [ $? -ne 0 ]
+then
+	support_noinode_cache="no"
+	run_check _scratch_mount
+fi
+
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv1
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv2
+_run_btrfs_util_prog subvolume create $SCRATCH_MNT/subv3
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+# if we don't support noinode_cache mount option, then we should double check
+# whether inode cache is enabled before executing the real test payload.
+if [ $SUPPORT_NOINODE_CACHE == "no" ]; then
+	EMPTY_SIZE=`$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | \
+		$SED_PROG -n '/[0-9]/p' | $AWK_PROG '{print $2}' | head -n1`
+	if [ $EMPTY_SIZE != $NODESIZE ]; then
+		_notrun "Kernel doesn't support to disable inode cache"
+	fi
+fi
+
+dd if=/dev/zero of=$SCRATCH_MNT/subv1/file1 bs=4K count=64 2>> $seqres.full
+cp --reflink $SCRATCH_MNT/subv1/file1 $SCRATCH_MNT/subv2/file1
+cp --reflink $SCRATCH_MNT/subv1/file1 $SCRATCH_MNT/subv3/file1
+
+# Current btrfs use tree search ioctl to show quota, which will only show info
+# in commit tree. So need to sync to update the qgroup commit tree.
+sync
+
+units=`_btrfs_qgroup_units`
+$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | \
+	$AWK_PROG '{print $2" "$3}'
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/083.out b/tests/btrfs/083.out
new file mode 100644
index 0000000..479966a
--- /dev/null
+++ b/tests/btrfs/083.out
@@ -0,0 +1,5 @@
+QA output created by 083
+65536 65536
+327680 65536
+327680 65536
+327680 65536
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
1.8.3.1

