Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:63502 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaBNUH0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 15:07:26 -0500
Received: by mail-we0-f173.google.com with SMTP id x48so3453833wes.32
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 12:07:25 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: use right clone root offset for compressed extents
Date: Fri, 14 Feb 2014 20:05:32 +0000
Message-Id: <1392408332-22425-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For non compressed extents, iterate_extent_inodes() gives us offsets
that take into account the data offset from the file extent items, while
for compressed extents it doesn't. Therefore we have to adjust them before
placing them in a send clone instruction. Not doing this adjustment leads to
the receiving end requesting for a wrong a file range to the clone ioctl,
which results in different file content from the one in the original send
root.

Issue reproducible with the following xfstest:

  _scratch_mkfs >/dev/null 2>&1
  _scratch_mount "-o compress-force=lzo"

  run_check $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
  $XFS_IO_PROG -c "fpunch 582007 864596" $SCRATCH_MNT/foo
  run_check $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
      $SCRATCH_MNT/foo

  run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
      $SCRATCH_MNT/mysnap1

  run_check $XFS_IO_PROG -c "pwrite -S 0xe1 -b 38804 1119395 38804" \
      $SCRATCH_MNT/foo
  run_check $XFS_IO_PROG -c "pwrite -S 0x0e -b 41125 80802 41125" \
      $SCRATCH_MNT/foo

  run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
      $SCRATCH_MNT/mysnap2

  run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
  run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
      $SCRATCH_MNT/mysnap2

  run_check $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
  run_check $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
      -f $tmp/2.snap

  _scratch_unmount
  _scratch_mkfs >/dev/null 2>&1
  _scratch_mount

  run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
  run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full

  run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
  run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f46c43f..6447ce6 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1295,6 +1295,13 @@ verbose_printk(KERN_DEBUG "btrfs: find_extent_clone: data_offset=%llu, "
 	}
 
 	if (cur_clone_root) {
+		if (compressed != BTRFS_COMPRESS_NONE) {
+			/*
+			 * Compensate the offsets set by:
+			 *    backref.c:check_extent_in_eb()
+			 */
+			cur_clone_root->offset += logical - found_key.objectid;
+		}
 		*found = cur_clone_root;
 		ret = 0;
 	} else {
-- 
1.7.9.5

