Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18908 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcBKXkN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 18:40:13 -0500
Subject: [PATCH 08/32] common: provide a method to repair the scratch fs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 11 Feb 2016 15:40:08 -0800
Message-ID: <20160211234008.2202.30511.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Create a wrapper function that repairs any damage to the scratch
filesystem and returns a standard result.  We will use this to clean
up after IO error testing and other weird corruption tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/common/rc b/common/rc
index 63eb90b..e05df74 100644
--- a/common/rc
+++ b/common/rc
@@ -953,6 +953,49 @@ _scratch_xfs_repair()
     $XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
+# Repair scratch filesystem.  Returns 0 if the FS is good to go (either no
+# errors found or errors were fixed) and nonzero otherwise; also spits out
+# a complaint on stderr if fsck didn't tell us that the FS is good to go.
+_repair_scratch_fs()
+{
+    case $FSTYP in
+    xfs)
+        _scratch_xfs_repair "$@" 2>&1
+	res=$?
+	if [ "$res" -eq 2 ]; then
+		echo "xfs_repair returns $res; replay log?"
+		_scratch_mount
+		res=$?
+		if [ "$res" -gt 0 ]; then
+			echo "mount returns $res; zap log?"
+			_scratch_xfs_repair -L 2>&1
+			echo "log zap returns $?"
+		else
+			umount "$SCRATCH_MNT"
+		fi
+		_scratch_xfs_repair "$@" 2>&1
+		res=$?
+	fi
+	test $res -ne 0 && >&2 echo "xfs_repair failed, err=$res"
+	return $res
+        ;;
+    *)
+        # Let's hope fsck -y suffices...
+        fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
+	res=$?
+	case $res in
+	0|1|2)
+		res=0
+		;;
+	*)
+		>&2 echo "fsck.$FSTYP failed, err=$res"
+		;;
+	esac
+	return $res
+        ;;
+    esac
+}
+
 _get_pids_by_name()
 {
     if [ $# -ne 1 ]

