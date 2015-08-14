Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24282 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbbHNPc0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 11:32:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, eguan@redhat.com,
        fdmanana@gmail.com
Subject: [PATCH v6 3/3] xfstests: btrfs: test device delete with EIO on src dev
Date: Fri, 14 Aug 2015 23:31:45 +0800
Message-Id: <1439566305-12460-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This test case tests if the device delete works with
the failed (EIO) source device. EIO errors are achieved
usign the DM device.

This test would need following btrfs-progs and btrfs
kernel patch
   btrfs-progs: device delete to accept devid
   Btrfs: device delete by devid

However when btrfs-progs patch is not found this test will
not run, and when kernel patch is not found btrfs-progs
will fail gracefully and thus the test script.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5->v6: accepts Eryu and Filipe's comments, thanks
v4->v5: rebase on latest xfstests code, and accepts Filipe comment
v3->v4: rebase on latest xfstests code
v2->v3: accepts Filipe Manana's review comments, thanks
v1->v2: accepts Dave Chinner's review comments, thanks
 common/rc           |  7 +++++
 tests/btrfs/099     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/099.out | 11 +++++++
 tests/btrfs/group   |  1 +
 4 files changed, 101 insertions(+)
 create mode 100755 tests/btrfs/099
 create mode 100644 tests/btrfs/099.out

diff --git a/common/rc b/common/rc
index 8d4da0e..31a0328 100644
--- a/common/rc
+++ b/common/rc
@@ -2737,6 +2737,13 @@ _require_meta_uuid()
 	umount $SCRATCH_MNT
 }
 
+_require_btrfs_dev_del_by_devid()
+{
+	$BTRFS_UTIL_PROG device delete --help | egrep devid > /dev/null 2>&1
+	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old "\
+			"(must support 'btrfs device delete <devid> /<mnt>')"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/btrfs/099 b/tests/btrfs/099
new file mode 100755
index 0000000..a0761c7
--- /dev/null
+++ b/tests/btrfs/099
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. btrfs/099
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
+	rm -f $tmp.*
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
+_run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
+
+error_devid=`$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT |\
+			egrep $DMERROR_DEV | $AWK_PROG '{print $2}'`
+
+snapshot_cmd="$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT"
+snapshot_cmd="$snapshot_cmd $SCRATCH_MNT/snap_\`date +'%H_%M_%S_%N'\`"
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n 200 -p 8 $FSSTRESS_AVOID -x \
+						"$snapshot_cmd" -X 50
+
+# now load the error into the DMERROR_DEV
+_load_dmerror_table
+
+_run_btrfs_util_prog device delete $error_devid $SCRATCH_MNT
+
+_run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
+
+echo "=== device delete completed"
+
+status=0; exit
diff --git a/tests/btrfs/099.out b/tests/btrfs/099.out
new file mode 100644
index 0000000..ec74e45
--- /dev/null
+++ b/tests/btrfs/099.out
@@ -0,0 +1,11 @@
+QA output created by 099
+Label: none  uuid:  <UUID>
+	Total devices <NUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+	devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test
+
+Label: none  uuid:  <UUID>
+	Total devices <NUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
+=== device delete completed
diff --git a/tests/btrfs/group b/tests/btrfs/group
index c8a53b5..968ee63 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -101,3 +101,4 @@
 096 auto quick clone
 097 auto quick send clone
 098 auto quick replace
+099 auto quick replace
-- 
2.4.1

