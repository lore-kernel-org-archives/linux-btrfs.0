Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24250 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbbHNPcX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 11:32:23 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, david@fromorbit.com, eguan@redhat.com,
        fdmanana@gmail.com
Subject: [PATCH v6 2/3] xfstests: btrfs: test device replace, with EIO on the src dev
Date: Fri, 14 Aug 2015 23:31:44 +0800
Message-Id: <1439566305-12460-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This test case will test to confirm the replace works with
the failed (EIO) replacing source device. EIO condition is
achieved using the DM device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
v5->v6: accepts Eryu and Filipe's comments
v4->v5: rebase on latest xfstests code and accepts Filipe comment
v3->v4: rebase on latest xfstests code
v2->v3: accepts Filipe Manana's review comments, thanks
v1->v2: accepts Dave Chinner's review comments, thanks
 tests/btrfs/098     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/098.out | 11 ++++++++
 tests/btrfs/group   |  1 +
 3 files changed, 93 insertions(+)
 create mode 100755 tests/btrfs/098
 create mode 100644 tests/btrfs/098.out

diff --git a/tests/btrfs/098 b/tests/btrfs/098
new file mode 100755
index 0000000..a41ea86
--- /dev/null
+++ b/tests/btrfs/098
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. btrfs/098
+#
+# Test device replace works when the source device has EIO
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
+_require_dmerror
+
+rm -f $seqres.full
+
+dev1="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`"
+dev2="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $3}'`"
+
+_init_dmerror
+_scratch_mkfs_dmerror "-f -d raid1 -m raid1 $dev1"
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
+_run_btrfs_util_prog replace start -B $error_devid $dev2 $SCRATCH_MNT
+
+_run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
+
+echo "=== device replace completed"
+
+status=0; exit
diff --git a/tests/btrfs/098.out b/tests/btrfs/098.out
new file mode 100644
index 0000000..eb2f87f
--- /dev/null
+++ b/tests/btrfs/098.out
@@ -0,0 +1,11 @@
+QA output created by 098
+Label: none  uuid:  <UUID>
+	Total devices <NUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+	devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test
+
+Label: none  uuid:  <UUID>
+	Total devices <NUM> FS bytes used <SIZE>
+	devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
+
+=== device replace completed
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e13865a..c8a53b5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -100,3 +100,4 @@
 095 auto quick metadata
 096 auto quick clone
 097 auto quick send clone
+098 auto quick replace
-- 
2.4.1

