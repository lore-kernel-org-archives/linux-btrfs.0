Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57744 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934526AbaEFJhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 05:37:31 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: add regression test for inode cache vs tree log
Date: Tue, 6 May 2014 17:31:24 +0800
Message-ID: <1399368684-1585-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds a regression test to verify btrfs can not
reuse inode id until we have committed transaction. Which was
addressed by the following kernel patch:

 Btrfs: fix inode cache vs tree log

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/049     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/049.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 111 insertions(+)
 create mode 100644 tests/btrfs/049
 create mode 100644 tests/btrfs/049.out

diff --git a/tests/btrfs/049 b/tests/btrfs/049
new file mode 100644
index 0000000..3101d09
--- /dev/null
+++ b/tests/btrfs/049
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. btrfs/049
+#
+# Regression test for btrfs inode caching vs tree log which was
+# addressed by the following kernel patch.
+#
+# Btrfs: fix inode caching vs tree log
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
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -rf $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+SAVE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode_cache,commit=100"
+
+# create a basic flakey device that will never error out
+_init_flakey
+_mount_flakey
+
+_get_inode_id()
+{
+	local inode_id
+	inode_id=`stat $1 | grep Inode: | $AWK_PROG '{print $4}'`
+	echo $inode_id
+}
+
+$XFS_IO_PROG -f -c "pwrite 0 10M" -c "fsync" \
+	$SCRATCH_MNT/data >& /dev/null
+
+inode_id=`_get_inode_id "$SCRATCH_MNT/data"`
+rm -f $SCRATCH_MNT/data
+
+for i in `seq 1 5`;
+do
+	mkdir $SCRATCH_MNT/dir_$i
+	new_inode_id=`_get_inode_id $SCRATCH_MNT/dir_$i`
+	if [ $new_inode_id -eq $inode_id ]
+	then
+		$XFS_IO_PROG -f -c "pwrite 0 1M" -c "fsync" \
+			$SCRATCH_MNT/dir_$i/data1 >& /dev/null
+		_load_flakey_table 1
+		_unmount_flakey
+		need_umount=1
+		break
+	fi
+	sleep 1
+done
+
+# restore previous mount options
+export MOUNT_OPTIONS="$SAVE_MOUNT_OPTIONS"
+
+# ok mount so that any recovery that needs to happen is done
+if [ $new_inode_id -eq $inode_id ];then
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	_unmount_flakey
+fi
+
+# make sure we got a valid fs after replay
+_check_scratch_fs $FLAKEY_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/049.out b/tests/btrfs/049.out
new file mode 100644
index 0000000..cb0061b
--- /dev/null
+++ b/tests/btrfs/049.out
@@ -0,0 +1 @@
+QA output created by 049
diff --git a/tests/btrfs/group b/tests/btrfs/group
index af60c79..59b0c98 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -51,3 +51,4 @@
 046 auto quick
 047 auto quick
 048 auto quick
+049 auto quick
-- 
1.8.2.1

