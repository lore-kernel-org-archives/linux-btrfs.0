Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35703 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbcFQBsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:48:13 -0400
Subject: [PATCH 20/20] xfs: scrub fs (if still mounted) at the end of the
 test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:48:07 -0700
Message-ID: <146612808781.25024.9354886387434772563.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Teach _check_xfs_filesystem to scrub mounted filesystems before
unmounting and fscking them.  This is mostly to test the online
scrub tool...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/config |    1 +
 common/rc     |    7 +++++++
 2 files changed, 8 insertions(+)


diff --git a/common/config b/common/config
index cacd815..41edb0c 100644
--- a/common/config
+++ b/common/config
@@ -163,6 +163,7 @@ export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
 export XFS_IO_PROG="`set_prog_path xfs_io`"
+export XFS_SCRUB_PROG="`set_prog_path xfs_scrub`"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
 export __XFSDUMP_PROG="`set_prog_path xfsdump`"
diff --git a/common/rc b/common/rc
index 847191e..ea5baea 100644
--- a/common/rc
+++ b/common/rc
@@ -2188,6 +2188,13 @@ _check_xfs_filesystem()
 
     if [ "$type" = "xfs" ]
     then
+	if [ -x "$XFS_SCRUB_PROG" ]; then
+		"$XFS_SCRUB_PROG" $scrubflag -vd $device >>$seqres.full
+		if [ $? -ne 0 ]; then
+			echo "filesystem on $device failed scrub (see $seqres.full)"
+			ok=0
+		fi
+	fi
         # mounted ...
         mountpoint=`_umount_or_remount_ro $device`
     fi

