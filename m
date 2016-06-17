Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbcFQBqT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:46:19 -0400
Subject: [PATCH 01/20] xfs/104: don't enospc when ag metadata overhead grows
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:46:08 -0700
Message-ID: <146612796843.25024.7729638172520969379.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adapt to different metadata overhead sizes by trying to reserve
decreasing amounts of disk space until we actually succeed at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/104 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/104 b/tests/xfs/104
index 17f9b62..785027e 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -88,9 +88,14 @@ sizeb=`expr $size / $dbsize`	# in data blocks
 echo "*** creating scratch filesystem"
 _create_scratch -lsize=10m -dsize=${size} -dagcount=${nags}
 
-fillsize=`expr 110 \* 1048576`	# 110 megabytes of filling
 echo "*** using some initial space on scratch filesystem"
-_fill_scratch $fillsize
+for i in `seq 125 -1 90`; do
+	fillsize=`expr $i \* 1048576`
+	out="$(_fill_scratch $fillsize 2>&1)"
+	echo "$out" | grep -q 'No space left on device' && continue
+	test -n "${out}" && echo "$out"
+	break
+done
 
 #
 # Grow the filesystem while actively stressing it...

