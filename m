Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23854 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbbCPGCh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 02:02:37 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <eguan@redhat.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v2] fstest: btrfs: add a test for quota number when deleting a subvol.
Date: Mon, 16 Mar 2015 13:58:54 +0800
Message-ID: <1426485534-15014-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <550664EC.7090705@cn.fujitsu.com>
References: <550664EC.7090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This regression is introduced by two commits:

e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
changlog:
	v1:
	1. Fix lots of coding style problems pointed by Eryu.
	2. Add more description for the regression.

 tests/btrfs/083     | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/083.out |   3 ++
 tests/btrfs/group   |   1 +
 3 files changed, 122 insertions(+)
 create mode 100755 tests/btrfs/083
 create mode 100644 tests/btrfs/083.out

diff --git a/tests/btrfs/083 b/tests/btrfs/083
new file mode 100755
index 0000000..a5e85e3
--- /dev/null
+++ b/tests/btrfs/083
@@ -0,0 +1,118 @@
+#! /bin/bash
+# FS QA Test No. 083
+#
+# This is a case for the regression introduced by
+#
+# e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
+# 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
+#
+# The problem is shown as below:
+#	$ btrfs sub create /mnt/sub
+#	Create subvolume '/mnt/sub'
+#	$ fallocate -l 1M /mnt/sub/data
+#	$ btrfs quota enable /mnt
+#	$ sync
+#	$ btrfs qgroup show --raw /mnt
+#	qgroupid         rfer         excl
+#	--------         ----         ----
+#	0/5             16384        16384
+#	0/257         1064960      1064960
+#	$ btrfs sub dele /mnt/sub
+#	Delete subvolume (no-commit): '/mnt/sub'
+#
+#	... ...                    		<------------Wait for the cleaner_kthread, about 30s.
+#	$ btrfs qgroup show --raw /mnt
+#	qgroupid         rfer         excl
+#	--------         ----         ----
+#	0/5             16384        16384
+#	0/257         1048576      1048576	<-----------sub 0/257 is deleted, but the quota numbers are not 0.
+#
+#
+# What we are expecting is:
+#	$ btrfs qgroup show --raw /mnt
+#	$ qgroupid         rfer         excl
+#	--------         ----         ----
+#	0/5             16384        16384
+#	0/257               0            0
+#
+# Currently, just revert these two commits mentioned above, we
+# can get the expected result. But there are some more things
+# we need to consider.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
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
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo 2>&1 > /dev/null
+
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+units=`_btrfs_qgroup_units`
+orig_result=`$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $AWK_PROG 'NR==NF {print $3}'`
+
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap
+
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+
+timeout=100
+# There is a background thread doing the clean work
+for ((i=0; i<$timeout; i++)); do
+	result=`$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $AWK_PROG 'NR==NF {print $3}'`
+	if (($orig_result != $result)); then
+		break
+	fi
+	sleep 1
+done
+
+$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $AWK_PROG '/[0-9]/ {print $2" "$3}'
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/083.out b/tests/btrfs/083.out
new file mode 100644
index 0000000..e73797e
--- /dev/null
+++ b/tests/btrfs/083.out
@@ -0,0 +1,3 @@
+QA output created by 083
+24576 24576
+0 0
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fd2fa76..e98a154 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -85,3 +85,4 @@
 080 auto snapshot
 081 auto quick clone
 082 auto quick remount
+083 auto qgroup
-- 
1.8.4.2

