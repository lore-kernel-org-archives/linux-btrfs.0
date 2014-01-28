Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:65150 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaA1Oq5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 09:46:57 -0500
Received: by mail-ea0-f171.google.com with SMTP id f15so284306eak.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 06:46:56 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: make test btrfs/025 more robust
Date: Tue, 28 Jan 2014 14:46:36 +0000
Message-Id: <1390920396-20311-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make the test btrfs/025 not depend on the output of the btrfs tools
subvolume, send, receive and filesystem commands output. The output
of these commands has changed several times in the past, and it can
change again in the future. Therefore just test for failure/success
and not for the exact output on the success case.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/025     |   34 +++++++++++++++++-----------------
 tests/btrfs/025.out |   12 ------------
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/tests/btrfs/025 b/tests/btrfs/025
index 482467f..01b1f86 100755
--- a/tests/btrfs/025
+++ b/tests/btrfs/025
@@ -54,27 +54,27 @@ rm -f $seqres.full
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-$XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -f -c "truncate 819200" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -c "falloc -k 819200 667648" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$XFS_IO_PROG -f -c "pwrite 1482752 2978" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -c "pwrite 1482752 2978" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
-    _filter_scratch
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap1
 
-$XFS_IO_PROG -f -c "truncate 883305" $SCRATCH_MNT/foo | _filter_xfs_io
-$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
+run_check $XFS_IO_PROG -c "truncate 883305" $SCRATCH_MNT/foo
+run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
 
-$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
-    _filter_scratch
+run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
+    $SCRATCH_MNT/mysnap2
 
-$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
-$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
-    -f $tmp/2.snap 2>&1 | _filter_scratch
+run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+    -f $tmp/2.snap 2>&1
 
 md5sum $SCRATCH_MNT/foo | _filter_scratch
 md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
@@ -85,10 +85,10 @@ _check_btrfs_filesystem $SCRATCH_DEV
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
 md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
 
-$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
+run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
 md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
 
 _scratch_unmount
diff --git a/tests/btrfs/025.out b/tests/btrfs/025.out
index aaad4ab..9921aea 100644
--- a/tests/btrfs/025.out
+++ b/tests/btrfs/025.out
@@ -1,18 +1,6 @@
 QA output created by 025
-FSSync 'SCRATCH_MNT'
-FSSync 'SCRATCH_MNT'
-wrote 2978/2978 bytes at offset 1482752
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-FSSync 'SCRATCH_MNT'
-Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap1'
-FSSync 'SCRATCH_MNT'
-Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap2'
-At subvol SCRATCH_MNT/mysnap1
-At subvol SCRATCH_MNT/mysnap2
 129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/foo
 42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
 129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo
-At subvol mysnap1
 42b6369eae2a8725c1aacc0440e597aa  SCRATCH_MNT/mysnap1/foo
-At snapshot mysnap2
 129b8eaee8d3c2bcad49bec596591cb3  SCRATCH_MNT/mysnap2/foo
-- 
1.7.9.5

