Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbcFQBr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:27 -0400
Subject: [PATCH 12/20] xfs/235: fix logic errors when checking rmap usage
 after failures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:47:17 -0700
Message-ID: <146612803789.25024.1998523832682276472.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/235     |    4 ++--
 tests/xfs/235.out |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/235 b/tests/xfs/235
index c388af1..c2e0340 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -80,8 +80,8 @@ echo "+ mount image"
 _scratch_mount
 
 echo "+ copy more"
-$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full
-test -s ${SCRATCH_MNT}/file4 || _fail "should not be able to copy with busted rmap btree"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full 2>&1
+test -s ${SCRATCH_MNT}/file4 && _fail "should not be able to copy with busted rmap btree"
 umount ${SCRATCH_MNT}
 
 echo "+ repair fs"
diff --git a/tests/xfs/235.out b/tests/xfs/235.out
index 89a11d6..7640224 100644
--- a/tests/xfs/235.out
+++ b/tests/xfs/235.out
@@ -6,7 +6,6 @@ QA output created by 235
 + corrupt image
 + mount image
 + copy more
-fsync: Structure needs cleaning
 + repair fs
 + mount image (2)
 + chattr -R -i

