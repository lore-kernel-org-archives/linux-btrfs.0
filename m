Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079AbcCEAiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 19:38:10 -0500
Subject: [PATCH 06/12] xfs/030: fix output on newer filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Fri, 04 Mar 2016 16:37:56 -0800
Message-ID: <20160305003756.28738.26362.stgit@birch.djwong.org>
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/030           |    5 ++++-
 tests/xfs/030.out.linux |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/030 b/tests/xfs/030
index 4cb1524..33c906c 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -57,7 +57,10 @@ _check_ag()
 		echo "Corrupting $structure - setting bits to $1"
 		_check_repair $1 "$structure" |
 			sed -e '/^error following ag 0 unlinked list$/d' \
-			    -e '/^bad agbno AGBNO for finobt/d'
+			    -e '/^bad agbno AGBNO for finobt/d' \
+			    -e '/^bad agbno AGBNO for rmapbt/d' \
+			    -e '/^bad agbno AGBNO for refcntbt/d' \
+			    -e '/^Missing reverse-mapping record.*/d'
 	done
 }
 
diff --git a/tests/xfs/030.out.linux b/tests/xfs/030.out.linux
index cf3259f..14b9b35 100644
--- a/tests/xfs/030.out.linux
+++ b/tests/xfs/030.out.linux
@@ -231,6 +231,8 @@ bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
+bad agbno AGBNO in agfl, agno 0
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...

