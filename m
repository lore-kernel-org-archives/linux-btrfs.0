Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:38190 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbbFWKkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 06:40:00 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v3 2/7] Btrfs: incremental send, avoid circular waiting and descendant overwrite ancestor need to update path
Date: Tue, 23 Jun 2015 18:39:46 +0800
Message-Id: <1435055991-10109-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1435055991-10109-1-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are several more cases where we can't do the renames immediately.

Example1:
Parent snapshot:
|---- d/ (ino 257)
    |---- p1 (ino 258)
|---- p1/ (ino 259)

Send snapshot:
|---- d/ (ino 257)
    |---- p1 (ino 259)
        |---- p1/ (ino 258)

Inode 258 became a child of inode 259 and both
were renamed in the send snapshot. Therefore inode 258's rename
operation is delayed to happen after 259 is renamed.

And we can not rename 259 from 'p1' to 'd/p1' without the rename
of inode 258, because the name of both 259 and 258 are identical
at the same time 258 is waiting to move.

so 259's rename is delayed to happen after 258's rename,
which creates a circular dependency (258 -> 259 -> 258).

Example2:
Parent snapshot:
|---- a/ (ino 259)
    |---- c (ino 266)
|---- d/ (ino 260)
    |---- ance (ino 265)
        |---- e (ino 261)
        |---- f (ino 262)
        |---- ance (ino 263)

Send snapshot:
|---- a/ (ino 259)
|---- c/ (ino 266)
    |---- ance (ino 265)
|---- d/ (ino 260)
    |---- ance (ino 263)
|---- f/ (ino 262)
    |---- e (ino 261)

After moving 262 outside, path of 265 is stored in the name_cache_entry.
When 263 try to overwrite 265, its ancestor, 265 is moved to orphanized.
However, the path of 263 is the original path before 265 is renamed, which
causes error while we try to rename a non-exist path.

Example3:
There is another case for 2nd scenario where is_ancestor() can't be used.

Parent snapshot:
|---- a/ (ino 261)
    |---- c (ino 267)
|---- d/ (ino 259)
    |---- ance/ (ino 266)
        |---- waiting_dir/ (ino 262)
|---- pre/ (ino 264)
    |---- ance/ (ino 265)

Send snapshot:
|---- a/ (ino 261)
    |---- ance/ (ino 266)
|---- c (ino 267)
    |---- waiting_dir/ (ino 262)
        |---- pre/ (ino 264)
|---- d/ (ino 259)
    |---- ance/ (ino 265)

First, 262 can't move to c/waiting_dir without the rename of inode 267.
Second, 264 can move into dir 262. Although 262 is waiting, 264 is not
parent of 262 in the parent root.
(The second behavior will happen after applying "[PATCH] Btrfs:
incremental send, don't delay directory renames unnecessarily")
Finally, 265 will overwrite 266 and path for 265 should be updated
since 266 is not the ancestor of 265.
Here we need to check the current state of tree rather than parent
root which  is_ancestor function does.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---

V3: modify comment and coding style

 fs/btrfs/send.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 257753b..95dc1d4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -230,7 +230,6 @@ struct pending_dir_move {
 	u64 parent_ino;
 	u64 ino;
 	u64 gen;
-	bool is_orphan;
 	struct list_head update_refs;
 };
 
@@ -1840,7 +1839,8 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	 * was already unlinked/moved, so we can safely assume that we will not
 	 * overwrite anything at this point in time.
 	 */
-	if (other_inode > sctx->send_progress) {
+	if (other_inode > sctx->send_progress ||
+			is_waiting_for_move(sctx, other_inode)) {
 		ret = get_inode_info(sctx->parent_root, other_inode, NULL,
 				who_gen, NULL, NULL, NULL, NULL);
 		if (ret < 0)
@@ -3014,7 +3014,6 @@ static int add_pending_dir_move(struct send_ctx *sctx,
 	pm->parent_ino = parent_ino;
 	pm->ino = ino;
 	pm->gen = ino_gen;
-	pm->is_orphan = is_orphan;
 	INIT_LIST_HEAD(&pm->list);
 	INIT_LIST_HEAD(&pm->update_refs);
 	RB_CLEAR_NODE(&pm->node);
@@ -3134,6 +3133,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	u64 rmdir_ino = 0;
 	int ret;
 	u64 ancestor = 0;
+	bool is_orphan;
 
 	name = fs_path_alloc();
 	from_path = fs_path_alloc();
@@ -3145,9 +3145,10 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	dm = get_waiting_dir_move(sctx, pm->ino);
 	ASSERT(dm);
 	rmdir_ino = dm->rmdir_ino;
+	is_orphan = dm->orphanized;
 	free_waiting_dir_move(sctx, dm);
 
-	if (pm->is_orphan) {
+	if (is_orphan) {
 		ret = gen_unique_name(sctx, pm->ino,
 				      pm->gen, from_path);
 	} else {
@@ -3171,7 +3172,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 		ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
 		ret = add_pending_dir_move(sctx, pm->ino, pm->gen, ancestor,
 					   &pm->update_refs, &deleted_refs,
-					   pm->is_orphan);
+					   is_orphan);
 		if (ret < 0)
 			goto out;
 		if (rmdir_ino) {
@@ -3351,6 +3352,7 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
 	u64 left_gen;
 	u64 right_gen;
 	int ret = 0;
+	struct waiting_dir_move *wdm;
 
 	if (RB_EMPTY_ROOT(&sctx->waiting_dir_moves))
 		return 0;
@@ -3409,7 +3411,8 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
 		goto out;
 	}
 
-	if (is_waiting_for_move(sctx, di_key.objectid)) {
+	wdm = get_waiting_dir_move(sctx, di_key.objectid);
+	if (wdm && !wdm->orphanized) {
 		ret = add_pending_dir_move(sctx,
 					   sctx->cur_ino,
 					   sctx->cur_inode_gen,
@@ -3669,11 +3672,26 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 				goto out;
 			if (ret) {
 				struct name_cache_entry *nce;
+				struct waiting_dir_move *wdm;
 
 				ret = orphanize_inode(sctx, ow_inode, ow_gen,
 						cur->full_path);
 				if (ret < 0)
 					goto out;
+
+				/*
+				 * If ow_inode has its rename operation delayed
+				 * make sure that its orphanized name is used in
+				 * the source path when performing its rename
+				 * operation.
+				 */
+				if (is_waiting_for_move(sctx, ow_inode)) {
+					wdm = get_waiting_dir_move(sctx,
+								   ow_inode);
+					ASSERT(wdm);
+					wdm->orphanized = true;
+				}
+
 				/*
 				 * Make sure we clear our orphanized inode's
 				 * name from the name cache. This is because the
@@ -3689,6 +3707,19 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 					name_cache_delete(sctx, nce);
 					kfree(nce);
 				}
+
+				/*
+				 * ow_inode might currently be an ancestor of
+				 * cur_ino, therefore compute valid_path (the
+				 * current path of cur_ino) again because it
+				 * might contain the pre-orphanization name of
+				 * ow_inode, which is no longer valid.
+				 */
+				fs_path_reset(valid_path);
+				ret = get_cur_path(sctx, sctx->cur_ino,
+					   sctx->cur_inode_gen, valid_path);
+				if (ret < 0)
+					goto out;
 			} else {
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
-- 
1.9.1

