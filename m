Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21090 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007AbbGVKPY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 06:15:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, david@fromorbit.com
Subject: [PATCH v4 2/3] xfstests: btrfs: test device replace, with EIO on the src dev
Date: Wed, 22 Jul 2015 18:12:02 +0800
Message-Id: <1437559923-32764-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1437559923-32764-1-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
 <1437559923-32764-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This test case will test to confirm the replace works when
the replacing source device has EIO errors.

EIO condition is achieved using the DM device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3->v4: rebase on latest xfstests code
v2->v3: accepts Filipe Manana's review comments, thanks
v1->v2: accepts Dave Chinner's review comments, thanks

 tests/btrfs/095     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/095.out | 10 +++++++
 tests/btrfs/group   |  1 +
 3 files changed, 87 insertions(+)
 create mode 100755 tests/btrfs/095
 create mode 100644 tests/btrfs/095.out

diff --git a/tests/btrfs/095 b/tests/btrfs/095
new file mode 100755
index 0000000..1da856f
--- /dev/null
+++ b/tests/btrfs/095
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. btrfs/095
+#
+#test device replace works when the source device has EIO
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
+_run_btrfs_util_prog replace start -B $error_devid $dev2 $SCRATCH_MNT
+
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
+
+status=0; exit
diff --git a/tests/btrfs/095.out b/tests/btrfs/095.out
new file mode 100644
index 0000000..9af70bb
--- /dev/null
+++ b/tests/btrfs/095.out
@@ -0,0 +1,10 @@
+QA output created by 095
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
index ffe18bf..ed9b3bb 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -96,3 +96,4 @@
 092 auto quick send
 093 auto quick clone
 094 auto quick send
+095 auto quick replace
-- 
2.4.1

