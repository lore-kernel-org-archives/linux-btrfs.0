Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59373 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaBOPx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 10:53:27 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so1266138wib.12
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Feb 2014 07:53:26 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: use right clone root offset for compressed extents
Date: Sat, 15 Feb 2014 15:53:16 +0000
Message-Id: <1392479596-7574-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392408332-22425-1-git-send-email-fdmanana@gmail.com>
References: <1392408332-22425-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For non compressed extents, iterate_extent_inodes() gives us offsets
that take into account the data offset from the file extent items, while
for compressed extents it doesn't. Therefore we have to adjust them before
placing them in a send clone instruction. Not doing this adjustment leads to
the receiving end requesting for a wrong a file range to the clone ioctl,
which results in different file content from the one in the original send
root.

Issue reproducible with the following excerpt from the test I made for
xfstests:

  _scratch_mkfs
  _scratch_mount "-o compress-force=lzo"

  $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
  $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" $SCRATCH_MNT/foo

  $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1

  $XFS_IO_PROG -c "pwrite -S 0x3e -b 80000 200000 80000" $SCRATCH_MNT/foo
  $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
  $XFS_IO_PROG -c "pwrite -S 0xdc -b 10000 250000 10000" $SCRATCH_MNT/foo
  $XFS_IO_PROG -c "pwrite -S 0xff -b 10000 300000 10000" $SCRATCH_MNT/foo

  # will be used for incremental send to be able to issue clone operations
  $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/clones_snap

  $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2

  $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
  $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
      -x $SCRATCH_MNT/mysnap2/clones_snap $SCRATCH_MNT/mysnap2
  $FSSUM_PROG -A -f -w $tmp/clones.fssum $SCRATCH_MNT/clones_snap \
      -x $SCRATCH_MNT/clones_snap/mysnap1 -x $SCRATCH_MNT/clones_snap/mysnap2

  $BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
  $BTRFS_UTIL_PROG send $SCRATCH_MNT/clones_snap -f $tmp/clones.snap
  $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 \
      -c $SCRATCH_MNT/clones_snap $SCRATCH_MNT/mysnap2 -f $tmp/2.snap

  _scratch_unmount
  _scratch_mkfs
  _scratch_mount

  $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
  $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1 2>> $seqres.full

  $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/clones.snap
  $FSSUM_PROG -r $tmp/clones.fssum $SCRATCH_MNT/clones_snap 2>> $seqres.full

  $BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
  $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2 2>> $seqres.full

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Updated commit message and the comment.

 fs/btrfs/send.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f46c43f..4addace 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1295,6 +1295,16 @@ verbose_printk(KERN_DEBUG "btrfs: find_extent_clone: data_offset=%llu, "
 	}
 
 	if (cur_clone_root) {
+		if (compressed != BTRFS_COMPRESS_NONE) {
+			/*
+			 * Offsets given by iterate_extent_inodes() are relative
+			 * to the start of the extent, we need to add logical
+			 * offset from the file extent item.
+			 * (See why at backref.c:check_extent_in_eb())
+			 */
+			cur_clone_root->offset += btrfs_file_extent_offset(eb,
+									   fi);
+		}
 		*found = cur_clone_root;
 		ret = 0;
 	} else {
-- 
1.7.9.5

