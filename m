Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17206 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbbLSJLX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Dec 2015 04:11:23 -0500
Subject: [PATCH 04/11] xfs/128: allow larger margin for disk space usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Sat, 19 Dec 2015 01:11:18 -0800
Message-ID: <20151219091118.15320.82351.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The free blocks count can vary from our calculations by up to 8% on a
1k-block filesystem, so permit that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/128 b/tests/xfs/128
index 49652cb..f461c1a 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -59,7 +59,7 @@ FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
 
 echo "Create the original file and reflink to file2, file3"
 BLKS=2000
-MARGIN=100
+MARGIN=160
 BLKSZ=65536
 REAL_BLKSZ="$(stat -f $TESTDIR -c '%S')"
 BLKSZ_FACTOR=$((BLKSZ / REAL_BLKSZ))

