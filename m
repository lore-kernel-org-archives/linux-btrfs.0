Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34002 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932115AbeEICHw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 22:07:52 -0400
Received: by mail-it0-f65.google.com with SMTP id c5-v6so15600165itj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 19:07:52 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: [RFC PATCH 4/6] btrfs: send, use fallocate command to allocate extents
Date: Tue,  8 May 2018 22:06:49 -0400
Message-Id: <20180509020651.7946-5-linux@hmclauchlan.com>
In-Reply-To: <20180509020651.7946-1-linux@hmclauchlan.com>
References: <20180509020651.7946-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe David Borba Manana <fdmanana@gmail.com>

The send stream version 2 adds the fallocate command, which can be used to
allocate extents for a file or punch holes in a file. Previously we were
ignoring file prealloc extents or treating them as extents filled with 0
bytes and sending a regular write command to the stream.

After this change, together with my previous change titled:

    "Btrfs: send, use fallocate command to punch holes"

an incremental send preserves the hole and data structure of files, which can
be seen via calls to lseek with the whence parameter set to SEEK_DATA or SEEK_HOLE,
as the example below shows:

    mkfs.btrfs -f /dev/sdc
    mount /dev/sdc /mnt
    xfs_io -f -c "pwrite -S 0x01 -b 300000 0 300000" /mnt/foo
    btrfs subvolume snapshot -r /mnt /mnt/mysnap1

    xfs_io -c "fpunch 100000 50000" /mnt/foo
    xfs_io -c "falloc 100000 50000" /mnt/foo
    xfs_io -c "pwrite -S 0xff -b 1000 120000 1000" /mnt/foo
    xfs_io -c "fpunch 250000 20000" /mnt/foo

    # prealloc extents that start beyond the inode's size
    xfs_io -c "falloc -k 300000 1000000" /mnt/foo
    xfs_io -c "falloc -k 9000000 2000000" /mnt/foo

    btrfs subvolume snapshot -r /mnt /mnt/mysnap2

    btrfs send /mnt/mysnap1 -f /tmp/1.snap
    btrfs send -p /mnt/mysnap1 /mnt/mysnap2 -f /tmp/2.snap

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt2
    btrfs receive /mnt2 -f /tmp/1.snap
    btrfs receive /mnt2 -f /tmp/2.snap

Before this change the hole/data structure differed between both filesystems:

    $ xfs_io -r -c 'seek -r -a 0' /mnt/mysnap2/foo
    Whence  Result
    DATA    0
    HOLE    102400
    DATA    118784
    HOLE    122880
    DATA    147456
    HOLE    253952
    DATA    266240
    HOLE    300000

    $ xfs_io -r -c 'seek -r -a 0' /mnt2/mysnap2/foo
    Whence  Result
    DATA    0
    HOLE    300000

After this change the second filesystem (/dev/sdd) ends up with the same hole/data
structure as the first filesystem.

Also, after this change, prealloc extents that lie beyond the inode's size (were
allocated with fallocate + keep size flag) are also replicated by an incremental
send. For the above test, it can be observed via fiemap (or btrfs-debug-tree):

    $ xfs_io -r -c 'fiemap -l' /mnt2/mysnap2/foo
	0: [0..191]: 25096..25287 192 blocks
	1: [192..199]: 24672..24679 8 blocks
	2: [200..231]: 24584..24615 32 blocks
	3: [232..239]: 24680..24687 8 blocks
	4: [240..287]: 24616..24663 48 blocks
	5: [288..295]: 24688..24695 8 blocks
	6: [296..487]: 25392..25583 192 blocks
	7: [488..495]: 24696..24703 8 blocks
	8: [496..519]: hole 24 blocks
	9: [520..527]: 24704..24711 8 blocks
	10: [528..583]: 25624..25679 56 blocks
	11: [584..591]: 24712..24719 8 blocks
	12: [592..2543]: 26192..28143 1952 blocks
	13: [2544..17575]: hole 15032 blocks
	14: [17576..21487]: 28144..32055 3912 blocks

The proposed xfstest can be found at:

    xfstests: btrfs, test send's ability to punch holes and prealloc extents

This test verifies that send-stream version 2 does space pre-allocation
and hole punching.

[Howard: rebased on 4.17-rc4]
Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c | 71 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 328c7a2857ae..c8ea1ccaa3d8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -98,9 +98,10 @@ struct send_ctx {
 	 */
 	u64 cur_ino;
 	u64 cur_inode_gen;
-	int cur_inode_new;
-	int cur_inode_new_gen;
-	int cur_inode_deleted;
+	u8 cur_inode_new:1;
+	u8 cur_inode_new_gen:1;
+	u8 cur_inode_skip_truncate:1;
+	u8 cur_inode_deleted:1;
 	u64 cur_inode_size;
 	u64 cur_inode_mode;
 	u64 cur_inode_rdev;
@@ -5313,6 +5314,19 @@ static int clone_range(struct send_ctx *sctx,
 	return ret;
 }
 
+static int truncate_before_falloc(struct send_ctx *sctx)
+{
+	int ret = 0;
+
+	if (!sctx->cur_inode_skip_truncate) {
+		ret = send_truncate(sctx, sctx->cur_ino,
+				    sctx->cur_inode_gen,
+				    sctx->cur_inode_size);
+		sctx->cur_inode_skip_truncate = 1;
+	}
+	return ret;
+}
+
 static int send_write_or_clone(struct send_ctx *sctx,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
@@ -5354,8 +5368,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	}
 
 	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
-		if (offset < sctx->cur_inode_size)
-			sctx->total_data_size += len;
+		sctx->total_data_size += len;
 		goto out;
 	}
 
@@ -5373,6 +5386,21 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		 offset < sctx->cur_inode_size) {
 		ret = send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
 				     offset, len);
+	} else if (type == BTRFS_FILE_EXTENT_PREALLOC &&
+		   (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)) {
+		u32 flags = 0;
+		if (offset < sctx->cur_inode_size) {
+			ret = send_fallocate(sctx,
+					     BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+					     offset, len);
+		} else {
+			flags |= BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE;
+			ret = truncate_before_falloc(sctx);
+		}
+		if (ret)
+			goto out;
+		ret = send_fallocate(sctx, flags, offset, len);
+
 	} else {
 		ret = send_extent_data(sctx, offset, len);
 	}
@@ -5775,19 +5803,24 @@ static int process_extent(struct send_ctx *sctx,
 		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_file_extent_item);
 		type = btrfs_file_extent_type(path->nodes[0], ei);
-		if (type == BTRFS_FILE_EXTENT_PREALLOC ||
-		    type == BTRFS_FILE_EXTENT_REG) {
-			/*
-			 * The send spec does not have a prealloc command yet,
-			 * so just leave a hole for prealloc'ed extents until
-			 * we have enough commands queued up to justify rev'ing
-			 * the send spec.
-			 */
-			if (type == BTRFS_FILE_EXTENT_PREALLOC) {
-				ret = 0;
-				goto out;
+		if (type == BTRFS_FILE_EXTENT_PREALLOC &&
+		    (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)) {
+			u64 len;
+			u32 flags = 0;
+
+			len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
+			if (key->offset >= sctx->cur_inode_size) {
+				flags |= BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE;
+				ret = truncate_before_falloc(sctx);
+				if (ret)
+					goto out;
 			}
-
+			ret = send_fallocate(sctx, flags, key->offset, len);
+			goto out;
+		} else if (type == BTRFS_FILE_EXTENT_PREALLOC) {
+			ret = 0;
+			goto out;
+		} else if (type == BTRFS_FILE_EXTENT_REG) {
 			/* Have a hole, just skip it. */
 			if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0) {
 				ret = 0;
@@ -5982,7 +6015,8 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 					goto out;
 			}
 		}
-		if (need_truncate) {
+		if (need_truncate && !sctx->cur_inode_skip_truncate
+		    && sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
 			ret = send_truncate(sctx, sctx->cur_ino,
 					    sctx->cur_inode_gen,
 					    sctx->cur_inode_size);
@@ -6044,6 +6078,7 @@ static int changed_inode(struct send_ctx *sctx,
 	sctx->cur_inode_new_gen = 0;
 	sctx->cur_inode_last_extent = (u64)-1;
 	sctx->cur_inode_next_write_offset = 0;
+	sctx->cur_inode_skip_truncate = 0;
 
 	/*
 	 * Set send_progress to current inode. This will tell all get_cur_xxx
-- 
2.17.0

