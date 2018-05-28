Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34127 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752939AbeE1CSY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:24 -0400
Received: by mail-io0-f193.google.com with SMTP id e15-v6so4091765iog.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:24 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH v2 2/6] btrfs: send, implement total data size command to allow for progress estimation
Date: Sun, 27 May 2018 22:14:31 -0400
Message-Id: <20180528021443.13923-3-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe David Borba Manana <fdmanana@gmail.com>

This new send flag makes send calculate first the amount of new file data (in bytes)
the send root has relatively to the parent root, or for the case of a non-incremental
send, the total amount of file data the stream will create (including holes and prealloc
extents). In other words, it computes the sum of the lengths of all write, clone and
fallocate operations that will be sent through the send stream.

This data size value is sent in a new command, named BTRFS_SEND_C_TOTAL_DATA_SIZE, that
immediately follows a BTRFS_SEND_C_SUBVOL or BTRFS_SEND_C_SNAPSHOT command, and precedes
any command that changes a file or the filesystem hierarchy. Upon receiving a write, clone
or fallocate command, the receiving end can increment a counter by the data length of that
command and therefore report progress by comparing the counter's value with the data size
value received in the BTRFS_SEND_C_TOTAL_DATA_SIZE command.

The approach is simple, before the normal operation of send, do a scan in the file system
tree for new inodes and new/changed file extent items, just like in send's normal operation,
and keep incrementing a counter with new inodes' size and the size of file extents (and file
holes)  that are going to be written, cloned or fallocated. This is actually a simpler and
more lightweight tree scan/processing than the one we do when sending the changes, as it
doesn't process inode references nor does any lookups in the extent tree for example.

After modifying btrfs-progs to understand this new command and report progress, here's an
example (the -o flag tells btrfs send to pass the new flag to the kernel's send ioctl):

    $ btrfs send -s --stream-version 2 /mnt/sdd/snap_base | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/snap_base
    At subvol snap_base
    About to receive 9212392667 bytes
    Subvolume /mnt/sdc//snap_base, 4059722426 / 9212392667 bytes received, 44.07%, 40.32MB/s

    $ btrfs send -s --stream-version 2 -p /mnt/sdd/snap_base /mnt/sdd/snap_incr | btrfs receive /mnt/sdc
    At subvol /mnt/sdd/snap_incr
    At subvol snap_incr
    About to receive 9571342213 bytes
    Subvolume /mnt/sdc//snap_incr, 6557345221 / 9571342213 bytes received, 68.51%, 51.04MB/s

[Howard: rebased on 4.17-rc7]
Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c | 189 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 157 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eccd69387065..7b184831812b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -66,7 +66,13 @@ struct clone_root {
 #define SEND_CTX_MAX_NAME_CACHE_SIZE 128
 #define SEND_CTX_NAME_CACHE_CLEAN_SIZE (SEND_CTX_MAX_NAME_CACHE_SIZE * 2)
 
+enum btrfs_send_phase {
+	SEND_PHASE_STREAM_CHANGES,
+	SEND_PHASE_COMPUTE_DATA_SIZE,
+};
+
 struct send_ctx {
+	enum btrfs_send_phase phase;
 	struct file *send_filp;
 	loff_t send_off;
 	char *send_buf;
@@ -102,6 +108,7 @@ struct send_ctx {
 	u64 cur_inode_next_write_offset;
 
 	u64 send_progress;
+	u64 total_data_size;
 
 	struct list_head new_refs;
 	struct list_head deleted_refs;
@@ -709,6 +716,8 @@ static int send_rename(struct send_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
 	int ret;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_rename %s -> %s", from->start, to->start);
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_RENAME);
@@ -758,6 +767,8 @@ static int send_unlink(struct send_ctx *sctx, struct fs_path *path)
 	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
 	int ret;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_unlink %s", path->start);
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_UNLINK);
@@ -780,6 +791,7 @@ static int send_rmdir(struct send_ctx *sctx, struct fs_path *path)
 {
 	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
 	int ret;
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
 
 	btrfs_debug(fs_info, "send_rmdir %s", path->start);
 
@@ -2419,6 +2431,8 @@ static int send_truncate(struct send_ctx *sctx, u64 ino, u64 gen, u64 size)
 	int ret = 0;
 	struct fs_path *p;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_truncate %llu size=%llu", ino, size);
 
 	p = fs_path_alloc();
@@ -2449,6 +2463,8 @@ static int send_chmod(struct send_ctx *sctx, u64 ino, u64 gen, u64 mode)
 	int ret = 0;
 	struct fs_path *p;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_chmod %llu mode=%llu", ino, mode);
 
 	p = fs_path_alloc();
@@ -2479,6 +2495,8 @@ static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid, u64 gid)
 	int ret = 0;
 	struct fs_path *p;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_chown %llu uid=%llu, gid=%llu",
 		    ino, uid, gid);
 
@@ -2516,6 +2534,8 @@ static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
 	struct btrfs_key key;
 	int slot;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_utimes %llu", ino);
 
 	p = fs_path_alloc();
@@ -2578,6 +2598,8 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 	u64 mode;
 	u64 rdev;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(fs_info, "send_create_inode %llu", ino);
 
 	p = fs_path_alloc();
@@ -2725,6 +2747,8 @@ static int send_create_inode_if_needed(struct send_ctx *sctx)
 {
 	int ret;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	if (S_ISDIR(sctx->cur_inode_mode)) {
 		ret = did_create_dir(sctx, sctx->cur_ino);
 		if (ret < 0)
@@ -2825,6 +2849,8 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 	int ret;
 	struct fs_path *orphan;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	orphan = fs_path_alloc();
 	if (!orphan)
 		return -ENOMEM;
@@ -3200,6 +3226,8 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	bool is_orphan;
 	int ret;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	name = fs_path_alloc();
 	from_path = fs_path_alloc();
 	if (!name || !from_path) {
@@ -3792,6 +3820,9 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 	bool orphanized_dir = false;
 	bool orphanized_ancestor = false;
 
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
+		return 0;
+
 	btrfs_debug(fs_info, "process_recorded_refs %llu", sctx->cur_ino);
 
 	/*
@@ -4391,6 +4422,8 @@ static int process_all_refs(struct send_ctx *sctx,
 	iterate_inode_ref_t cb;
 	int pending_move = 0;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	path = alloc_path_for_send();
 	if (!path)
 		return -ENOMEM;
@@ -4708,6 +4741,8 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 	struct extent_buffer *eb;
 	int slot;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	path = alloc_path_for_send();
 	if (!path)
 		return -ENOMEM;
@@ -4849,6 +4884,8 @@ static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 	struct fs_path *p;
 	ssize_t num_read = 0;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
@@ -4884,6 +4921,22 @@ static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 	return num_read;
 }
 
+static int send_total_data_size(struct send_ctx *sctx, u64 data_size)
+{
+	int ret;
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_TOTAL_DATA_SIZE);
+	if (ret < 0)
+		goto out;
+
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, data_size);
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+out:
+	return ret;
+}
+
 /*
  * Send a clone command to user space.
  */
@@ -4895,6 +4948,8 @@ static int send_clone(struct send_ctx *sctx,
 	struct fs_path *p;
 	u64 gen;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	btrfs_debug(sctx->send_root->fs_info,
 		    "send_clone offset=%llu, len=%d, clone_root=%llu, clone_inode=%llu, clone_offset=%llu",
 		    offset, len, clone_root->root->objectid, clone_root->ino,
@@ -4966,6 +5021,8 @@ static int send_update_extent(struct send_ctx *sctx,
 	int ret = 0;
 	struct fs_path *p;
 
+	ASSERT(sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE);
+
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
@@ -4997,6 +5054,10 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 	u64 len;
 	int ret = 0;
 
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
+		sctx->total_data_size += end - offset;
+		return 0;
+	}
 	if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA)
 		return send_update_extent(sctx, offset, end - offset);
 
@@ -5250,6 +5311,12 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		goto out;
 	}
 
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
+		if (offset < sctx->cur_inode_size)
+			sctx->total_data_size += len;
+		goto out;
+	}
+
 	if (clone_root && IS_ALIGNED(offset + len, bs)) {
 		u64 disk_byte;
 		u64 data_offset;
@@ -5681,10 +5748,12 @@ static int process_extent(struct send_ctx *sctx,
 		}
 	}
 
-	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
-			sctx->cur_inode_size, &found_clone);
-	if (ret != -ENOENT && ret < 0)
-		goto out;
+	if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
+		ret = find_extent_clone(sctx, path, key->objectid, key->offset,
+					sctx->cur_inode_size, &found_clone);
+		if (ret != -ENOENT && ret < 0)
+			goto out;
+	}
 
 	ret = send_write_or_clone(sctx, path, key, found_clone);
 	if (ret)
@@ -5815,6 +5884,9 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 	if (!at_end && sctx->cmp_key->objectid == sctx->cur_ino)
 		goto out;
 
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
+		goto truncate_inode;
+
 	ret = get_inode_info(sctx->send_root, sctx->cur_ino, NULL, NULL,
 			&left_mode, &left_uid, &left_gid, NULL);
 	if (ret < 0)
@@ -5845,6 +5917,7 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 			need_truncate = 0;
 	}
 
+truncate_inode:
 	if (S_ISREG(sctx->cur_inode_mode)) {
 		if (need_send_hole(sctx)) {
 			if (sctx->cur_inode_last_extent == (u64)-1 ||
@@ -5887,7 +5960,8 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 	 * If other directory inodes depended on our current directory
 	 * inode's move/rename, now do their move/rename operations.
 	 */
-	if (!is_waiting_for_move(sctx, sctx->cur_ino)) {
+	if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE &&
+	    !is_waiting_for_move(sctx, sctx->cur_ino)) {
 		ret = apply_children_dir_moves(sctx);
 		if (ret)
 			goto out;
@@ -5972,7 +6046,8 @@ static int changed_inode(struct send_ctx *sctx,
 				sctx->left_path->nodes[0], left_ii);
 		sctx->cur_inode_rdev = btrfs_inode_rdev(
 				sctx->left_path->nodes[0], left_ii);
-		if (sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID)
+		if (sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID &&
+		    sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE)
 			ret = send_create_inode_if_needed(sctx);
 	} else if (result == BTRFS_COMPARE_TREE_DELETED) {
 		sctx->cur_inode_gen = right_gen;
@@ -5994,17 +6069,19 @@ static int changed_inode(struct send_ctx *sctx,
 			/*
 			 * First, process the inode as if it was deleted.
 			 */
-			sctx->cur_inode_gen = right_gen;
-			sctx->cur_inode_new = 0;
-			sctx->cur_inode_deleted = 1;
-			sctx->cur_inode_size = btrfs_inode_size(
+			if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
+				sctx->cur_inode_gen = right_gen;
+				sctx->cur_inode_new = 0;
+				sctx->cur_inode_deleted = 1;
+				sctx->cur_inode_size = btrfs_inode_size(
 					sctx->right_path->nodes[0], right_ii);
-			sctx->cur_inode_mode = btrfs_inode_mode(
+				sctx->cur_inode_mode = btrfs_inode_mode(
 					sctx->right_path->nodes[0], right_ii);
-			ret = process_all_refs(sctx,
-					BTRFS_COMPARE_TREE_DELETED);
-			if (ret < 0)
-				goto out;
+				ret = process_all_refs(sctx,
+						   BTRFS_COMPARE_TREE_DELETED);
+				if (ret < 0)
+					goto out;
+			}
 
 			/*
 			 * Now process the inode as if it was new.
@@ -6018,29 +6095,38 @@ static int changed_inode(struct send_ctx *sctx,
 					sctx->left_path->nodes[0], left_ii);
 			sctx->cur_inode_rdev = btrfs_inode_rdev(
 					sctx->left_path->nodes[0], left_ii);
-			ret = send_create_inode_if_needed(sctx);
-			if (ret < 0)
-				goto out;
-
-			ret = process_all_refs(sctx, BTRFS_COMPARE_TREE_NEW);
-			if (ret < 0)
-				goto out;
+			if (sctx->phase != SEND_PHASE_COMPUTE_DATA_SIZE) {
+				ret = send_create_inode_if_needed(sctx);
+				if (ret < 0)
+					goto out;
+				ret = process_all_refs(sctx,
+						       BTRFS_COMPARE_TREE_NEW);
+				if (ret < 0)
+					goto out;
+			}
 			/*
 			 * Advance send_progress now as we did not get into
 			 * process_recorded_refs_if_needed in the new_gen case.
 			 */
 			sctx->send_progress = sctx->cur_ino + 1;
 
-			/*
-			 * Now process all extents and xattrs of the inode as if
-			 * they were all new.
-			 */
-			ret = process_all_extents(sctx);
-			if (ret < 0)
-				goto out;
-			ret = process_all_new_xattrs(sctx);
-			if (ret < 0)
-				goto out;
+			if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
+				if (S_ISREG(sctx->cur_inode_mode))
+					sctx->total_data_size +=
+						sctx->cur_inode_size;
+				/* TODO: maybe account for xattrs one day too */
+			} else {
+				/*
+				 * Now process all extents and xattrs of the
+				 * inode as if they were all new.
+				 */
+				ret = process_all_extents(sctx);
+				if (ret < 0)
+					goto out;
+				ret = process_all_new_xattrs(sctx);
+				if (ret < 0)
+					goto out;
+			}
 		} else {
 			sctx->cur_inode_gen = left_gen;
 			sctx->cur_inode_new = 0;
@@ -6077,6 +6163,9 @@ static int changed_ref(struct send_ctx *sctx,
 		return -EIO;
 	}
 
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
+		return 0;
+
 	if (!sctx->cur_inode_new_gen &&
 	    sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID) {
 		if (result == BTRFS_COMPARE_TREE_NEW)
@@ -6105,6 +6194,9 @@ static int changed_xattr(struct send_ctx *sctx,
 		return -EIO;
 	}
 
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
+		return 0;
+
 	if (!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted) {
 		if (result == BTRFS_COMPARE_TREE_NEW)
 			ret = process_new_xattr(sctx);
@@ -6273,6 +6365,8 @@ static int changed_cb(struct btrfs_path *left_path,
 	if (result == BTRFS_COMPARE_TREE_SAME) {
 		if (key->type == BTRFS_INODE_REF_KEY ||
 		    key->type == BTRFS_INODE_EXTREF_KEY) {
+			if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE)
+				return 0;
 			ret = compare_refs(sctx, left_path, key);
 			if (!ret)
 				return 0;
@@ -6369,6 +6463,24 @@ static int full_send_tree(struct send_ctx *sctx)
 	return ret;
 }
 
+static int compute_total_data_size(struct send_ctx *sctx)
+{
+	int ret;
+
+	sctx->total_data_size = 0;
+
+	if (sctx->parent_root) {
+		ret = btrfs_compare_trees(sctx->send_root, sctx->parent_root,
+					  changed_cb, sctx);
+		if (!ret)
+			ret = finish_inode_if_needed(sctx, 1);
+	} else {
+		ret = full_send_tree(sctx);
+	}
+
+	return ret;
+}
+
 static int send_subvol(struct send_ctx *sctx)
 {
 	int ret;
@@ -6383,6 +6495,19 @@ static int send_subvol(struct send_ctx *sctx)
 	if (ret < 0)
 		goto out;
 
+	if (sctx->flags & BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE) {
+		sctx->phase = SEND_PHASE_COMPUTE_DATA_SIZE;
+		ret = compute_total_data_size(sctx);
+		if (ret < 0)
+			goto out;
+		ret = send_total_data_size(sctx, sctx->total_data_size);
+		if (ret < 0)
+			goto out;
+		sctx->phase = SEND_PHASE_STREAM_CHANGES;
+		sctx->cur_ino = 0;
+		sctx->send_progress = 0;
+	}
+
 	if (sctx->parent_root) {
 		ret = btrfs_compare_trees(sctx->send_root, sctx->parent_root,
 				changed_cb, sctx);
-- 
2.17.0

