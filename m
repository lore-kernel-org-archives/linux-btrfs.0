Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52119 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaDPQ4S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 12:56:18 -0400
Received: by mail-wi0-f173.google.com with SMTP id z2so1709106wiv.12
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 09:56:17 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 4/4 v3] Btrfs: send, use fallocate command to allocate extents
Date: Wed, 16 Apr 2014 18:56:07 +0100
Message-Id: <1397670967-10768-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580021-26598-4-git-send-email-fdmanana@gmail.com>
References: <1397580021-26598-4-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

A test case for xfstests will follow.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE. A version 2
    stream is now only produced is the ioctl caller specifies at least one of
    the new send flags (BTRFS_SEND_FLAG_SUPPORT_FALLOCATE or
    BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE).
V3: Fixed rebase, removed some duplicate logic on truncate + falloc -k.

 fs/btrfs/send.c | 78 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bb9afea..86b6a87 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -113,9 +113,10 @@ struct send_ctx {
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
@@ -4563,6 +4564,19 @@ tlv_put_failure:
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
@@ -4602,8 +4616,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	}
 
 	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
-		if (offset < sctx->cur_inode_size)
-			sctx->total_data_size += len;
+		sctx->total_data_size += len;
 		goto out;
 	}
 
@@ -4617,6 +4630,20 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		   offset < sctx->cur_inode_size) {
 		ret = send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
 				     offset, len);
+	} else if (type == BTRFS_FILE_EXTENT_PREALLOC &&
+		   (sctx->flags & BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)) {
+		u32 mode = 0;
+		if (offset < sctx->cur_inode_size) {
+			ret = send_fallocate(sctx,
+					     BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+					     offset, len);
+		} else {
+			mode |= BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE;
+			ret = truncate_before_falloc(sctx);
+		}
+		if (ret)
+			goto out;
+		ret = send_fallocate(sctx, mode, offset, len);
 	} else {
 		while (pos < len) {
 			l = len - pos;
@@ -4925,19 +4952,24 @@ static int process_extent(struct send_ctx *sctx,
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
+		    (sctx->flags & BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)) {
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
@@ -5123,10 +5155,13 @@ truncate_inode:
 					goto out;
 			}
 		}
-		ret = send_truncate(sctx, sctx->cur_ino, sctx->cur_inode_gen,
-				sctx->cur_inode_size);
-		if (ret < 0)
-			goto out;
+		if (!sctx->cur_inode_skip_truncate) {
+			ret = send_truncate(sctx, sctx->cur_ino,
+					    sctx->cur_inode_gen,
+					    sctx->cur_inode_size);
+			if (ret < 0)
+				goto out;
+		}
 	}
 
 	if (need_chown) {
@@ -5181,6 +5216,7 @@ static int changed_inode(struct send_ctx *sctx,
 	sctx->cur_ino = key->objectid;
 	sctx->cur_inode_new_gen = 0;
 	sctx->cur_inode_last_extent = (u64)-1;
+	sctx->cur_inode_skip_truncate = 0;
 
 	/*
 	 * Set send_progress to current inode. This will tell all get_cur_xxx
-- 
1.9.1

