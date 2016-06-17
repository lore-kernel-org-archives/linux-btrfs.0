Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18670 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbcFQBsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:48:10 -0400
Subject: [PATCH 19/20] xfs: run xfs_repair at the end of each test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:48:01 -0700
Message-ID: <146612808160.25024.5986137574652014794.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Run xfs_repair twice at the end of each test -- once to rebuild
the btree indices, and again with -n to check the rebuild work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/rc b/common/rc
index 1225047..847191e 100644
--- a/common/rc
+++ b/common/rc
@@ -2225,6 +2225,9 @@ _check_xfs_filesystem()
         ok=0
     fi
 
+    $XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
+    cat $tmp.repair | _fix_malloc		>>$seqres.full
+
     $XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then

