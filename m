Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35615 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbcFQBsA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:48:00 -0400
Subject: [PATCH 18/20] xfs/128: use $XFS_FSR_PROG instead of xfs_fsr directly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:47:55 -0700
Message-ID: <146612807538.25024.6579124315123898764.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128 |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/128 b/tests/xfs/128
index 68f6f94..8758d7e 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -97,10 +97,10 @@ c14=$(_md5_checksum $testdir/file4)
 
 echo "Defragment"
 lsattr -l $testdir/ | _filter_scratch | _filter_spaces
-xfs_fsr -v -d $testdir/file1 >> $seqres.full
-xfs_fsr -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
-xfs_fsr -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
-xfs_fsr -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
+$XFS_FSR_PROG -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
+$XFS_FSR_PROG -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
+$XFS_FSR_PROG -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
 _test_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
 

