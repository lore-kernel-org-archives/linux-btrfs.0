Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32791 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcEZF5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 01:57:16 -0400
Subject: [PATCH 1/7] xfs/104: don't enospc when ag metadata overhead grows
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Wed, 25 May 2016 22:57:08 -0700
Message-ID: <146424222875.6278.15144771781299434088.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
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

