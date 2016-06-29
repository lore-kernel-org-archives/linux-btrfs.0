Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:43972 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbcF2EAZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 00:00:25 -0400
Date: Tue, 28 Jun 2016 20:36:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 21/20] xfs/128: cycle_mount the scratch device, not the test
 device
Message-ID: <20160629033648.GA7108@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test uses the scratch device, so cycle that, not the test dev.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/128 |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/128 b/tests/xfs/128
index 8758d7e..2e756d5 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -66,7 +66,7 @@ _pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2
 _cp_reflink $testdir/file2 $testdir/file3
 _cp_reflink $testdir/file3 $testdir/file4
-_test_cycle_mount
+_scratch_cycle_mount
 free_blocks1=$(stat -f $testdir -c '%f')
 
 md5sum $testdir/file1 | _filter_scratch
@@ -82,7 +82,7 @@ c04=$(_md5_checksum $testdir/file4)
 echo "CoW the reflink copies"
 _pwrite_byte 0x62 $blksz $blksz $testdir/file2 >> $seqres.full
 _pwrite_byte 0x63 $(( blksz * (blks - 1) )) $blksz $testdir/file3 >> $seqres.full
-_test_cycle_mount
+_scratch_cycle_mount
 free_blocks2=$(stat -f $testdir -c '%f')
 
 md5sum $testdir/file1 | _filter_scratch
@@ -97,11 +97,12 @@ c14=$(_md5_checksum $testdir/file4)
 
 echo "Defragment"
 lsattr -l $testdir/ | _filter_scratch | _filter_spaces
+filefrag -v $testdir/file* >> $seqres.full
 $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
 $XFS_FSR_PROG -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
 $XFS_FSR_PROG -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link
 $XFS_FSR_PROG -v -d $testdir/file4 >> $seqres.full # fsr probably ignores this file
-_test_cycle_mount
+_scratch_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
 
 md5sum $testdir/file1 | _filter_scratch
