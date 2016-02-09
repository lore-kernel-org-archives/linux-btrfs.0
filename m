Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32695 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbcBIBM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 20:12:27 -0500
Subject: [PATCH 05/23] common/dmerror: add some more dmerror routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 08 Feb 2016 17:12:17 -0800
Message-ID: <20160209011217.23099.26572.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add functions to the dmerror routine so that we can load both the
error table and the linear table.  This will help us with EIO testing
of copy-on-write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/dmerror  |   27 +++++++++++++++++++++++++--
 tests/btrfs/100 |    2 +-
 tests/btrfs/101 |    2 +-
 3 files changed, 27 insertions(+), 4 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 3900a4e..004530d 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -46,15 +46,23 @@ _dmerror_mount()
 	_mount -t $FSTYP `_dmerror_mount_options $*`
 }
 
+_dmerror_unmount()
+{
+	umount $SCRATCH_MNT
+}
+
 _dmerror_cleanup()
 {
 	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
 	$DMSETUP_PROG remove error-test > /dev/null 2>&1
 }
 
-_dmerror_load_table()
+_dmerror_load_error_table()
 {
-	$DMSETUP_PROG suspend error-test
+	suspend_opt="--nolockfs"
+	[ $# -gt 1 ] && [ $2 -eq 1 ] && suspend_opt=""
+
+	$DMSETUP_PROG suspend $suspend_opt error-test
 	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
 
 	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
@@ -63,3 +71,18 @@ _dmerror_load_table()
 	$DMSETUP_PROG resume error-test
 	[ $? -ne 0 ] && _fail  "dmsetup resume failed"
 }
+
+_dmerror_load_working_table()
+{
+	suspend_opt="--nolockfs"
+	[ $# -gt 1 ] && [ $2 -eq 1 ] && suspend_opt=""
+
+	$DMSETUP_PROG suspend $suspend_opt error-test
+	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
+
+	$DMSETUP_PROG load error-test --table "$DMLINEAR_TABLE"
+	[ $? -ne 0 ] && _fail "dmsetup failed to load error table"
+
+	$DMSETUP_PROG resume error-test
+	[ $? -ne 0 ] && _fail  "dmsetup resume failed"
+}
diff --git a/tests/btrfs/100 b/tests/btrfs/100
index 080d0ae..cd385e1 100755
--- a/tests/btrfs/100
+++ b/tests/btrfs/100
@@ -69,7 +69,7 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n 200 -p 8 $FSSTRESS_AVOID -x \
 							"$snapshot_cmd" -X 50
 
 # now load the error into the DMERROR_DEV
-_dmerror_load_table
+_dmerror_load_error_table
 
 _run_btrfs_util_prog replace start -B $error_devid $dev2 $SCRATCH_MNT
 
diff --git a/tests/btrfs/101 b/tests/btrfs/101
index 0824de1..8d7af85 100755
--- a/tests/btrfs/101
+++ b/tests/btrfs/101
@@ -70,7 +70,7 @@ run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n 200 -p 8 $FSSTRESS_AVOID -x \
 							"$snapshot_cmd" -X 50
 
 # now load the error into the DMERROR_DEV
-_dmerror_load_table
+_dmerror_load_error_table
 
 _run_btrfs_util_prog device delete $error_devid $SCRATCH_MNT
 

