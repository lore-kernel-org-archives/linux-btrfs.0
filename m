Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42356 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbbEKNjB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 09:39:01 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, fdmanana@gmail.com
Subject: [PATCH v3 3/3] xfstests: btrfs: test device delete with EIO on src dev
Date: Mon, 11 May 2015 21:49:11 +0800
Message-Id: <1431352151-3117-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This test case tests if the device delete would work when
the source device has failed with EIO errors.

EIO errors are achieved usign the DM device.

Also this test needs the latest btrfs-progs and kernel patch
under title
  [PATCH] device delete by devid

When this patch is not found in the btrfs-progs, this test
will not run. However when the require patch is not found
in the kernel it will fail gracefully.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: accepts Filipe Manana's review comments, thanks
v1->v2: accepts Dave Chinner's review comments, thanks
 common/rc           |    6 ++++
 tests/btrfs/088     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/088.out |   10 ++++++
 tests/btrfs/group   |    1 +
 4 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/088
 create mode 100644 tests/btrfs/088.out

diff --git a/common/rc b/common/rc
index 447ab7f..aca7a62 100644
--- a/common/rc
+++ b/common/rc
@@ -2685,6 +2685,12 @@ _require_test_fcntl_advisory_locks()
 		_notrun "Require fcntl advisory locks support"
 }
 
+_require_btrfs_dev_del_by_devid()
+{
+	$BTRFS_UTIL_PROG device delete --help | egrep devid > /dev/null 2>&1
+	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support 'btrfs device delete <devid> /<mnt>')"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/btrfs/088 b/tests/btrfs/088
new file mode 100755
index 0000000..5ab226f
--- /dev/null
+++ b/tests/btrfs/088
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test No. btrfs/088
+#
+# test device delete when the source device has EIO
+#
+# Copyright (c) 2015 Oracle.  All Rights Reserved.
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
+
+_cleanup()
+{
+	_cleanup_dmerror
+	rm -f $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/filter.btrfs
+. ./common/dmerror
+
+_supported_fs btrfs
+_supported_os Linux
+_need_to_be_root
+_require_scratch_dev_pool 3
+_require_btrfs_dev_del_by_devid
+_require_dmerror
+
+rm -f $seqres.full
+
+dev1="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`"
+dev2="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $3}'`"
+
+_init_dmerror
+_scratch_mkfs_dmerror "-f -d raid1 -m raid1 $dev1 $dev2"
+_mount_dmerror
+
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
+
+error_devid=`$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT |\
+			egrep $DMERROR_DEV | $AWK_PROG '{print $2}'`
+
+snapshot_cmd="$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT"
+snapshot_cmd="$snapshot_cmd $SCRATCH_MNT/snap_\`date +'%H_%M_%S_%N'\`"
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n 200 -p 8 $FSSTRESS_AVOID -x "$snapshot_cmd" -X 50 >&/dev/null
+
+# now load the error into the DMERROR_DEV
+_load_dmerror_table
+
+_run_btrfs_util_prog device delete $error_devid $SCRATCH_MNT
+
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
+
+status=0; exit
diff --git a/tests/btrfs/088.out b/tests/btrfs/088.out
new file mode 100644
index 0000000..32ee8f4
--- /dev/null
+++ b/tests/btrfs/088.out
@@ -0,0 +1,10 @@
+QA output created by 088
+Label: none  uuid: <UUID>
+	Total devices <NUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+	devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test
+
+Label: none  uuid: <UUID>
+	Total devices <NUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d66b4fc..d474c47 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -90,3 +90,4 @@
 085 auto quick metadata subvol
 086 auto quick clone
 087 auto quick replace
+088 auto quick replace
-- 
1.7.1

