Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:25122 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbFDL1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 07:27:54 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 1/5] Btrfs: incremental send, avoid circular waiting and descendant overwrite ancestor need to update path
Date: Thu,  4 Jun 2015 19:18:06 +0800
Message-Id: <1433416690-19177-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1433416690-19177-1-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Base on [PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename

Example1:
There's one case where we can't issue a rename operation for a directory
immediately when we process it. 

Parent snapshot:
|---- d/ (ino 257)
  |---- p1 (ino 258)
|---- p1/ (ino 259)

Send snapshot:
|---- d/ (ino 257)
  |---- p1 (ino 259)
    |---- p1/ (ino 258)

Here we can not rename 258 from d/p1 to p1/p1 without the rename of inode 259.
p1 258 is put into wait_parent_move. 259 can't be rename to d/p1, so it is put into
circular waiting happens. This is fix by rename destination directory and set 
it as orphanized for this case.

Example2:
There's one case where we can't issue a rename operation for a directory
immediately we process it.
After moving 262 outside, path of 265 is stored in the name_cache_entry.
When 263 try to overwrite 265, its ancestor, 265 is moved to orphanized. Path of 263
is still the original path, however. This causes error.

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

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1c1f161..fbfbb8b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -230,7 +230,6 @@ struct pending_dir_move {
 	u64 parent_ino;
 	u64 ino;
 	u64 gen;
-	bool is_orphan;
 	struct list_head update_refs;
 };
 
@@ -1840,7 +1839,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	 * was already unlinked/moved, so we can safely assume that we will not
 	 * overwrite anything at this point in time.
 	 */
-	if (other_inode > sctx->send_progress) {
+	if (other_inode > sctx->send_progress || is_waiting_for_move(sctx, other_inode)) {
 		ret = get_inode_info(sctx->parent_root, other_inode, NULL,
 				who_gen, NULL, NULL, NULL, NULL);
 		if (ret < 0)
@@ -3014,7 +3013,6 @@ static int add_pending_dir_move(struct send_ctx *sctx,
 	pm->parent_ino = parent_ino;
 	pm->ino = ino;
 	pm->gen = ino_gen;
-	pm->is_orphan = is_orphan;
 	INIT_LIST_HEAD(&pm->list);
 	INIT_LIST_HEAD(&pm->update_refs);
 	RB_CLEAR_NODE(&pm->node);
@@ -3091,6 +3089,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	struct waiting_dir_move *dm = NULL;
 	u64 rmdir_ino = 0;
 	int ret;
+	bool is_orphan;
 
 	name = fs_path_alloc();
 	from_path = fs_path_alloc();
@@ -3102,9 +3101,10 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
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
@@ -3292,6 +3292,7 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
 	u64 left_gen;
 	u64 right_gen;
 	int ret = 0;
+	struct waiting_dir_move *wdm;
 
 	if (RB_EMPTY_ROOT(&sctx->waiting_dir_moves))
 		return 0;
@@ -3350,7 +3351,8 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
 		goto out;
 	}
 
-	if (is_waiting_for_move(sctx, di_key.objectid)) {
+	wdm = get_waiting_dir_move(sctx, di_key.objectid);
+	if (wdm && !wdm->orphanized) {
 		ret = add_pending_dir_move(sctx,
 					   sctx->cur_ino,
 					   sctx->cur_inode_gen,
@@ -3610,11 +3612,33 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 				goto out;
 			if (ret) {
 				struct name_cache_entry *nce;
+				struct waiting_dir_move *wdm;
+				bool cur_is_ancestor = false;
+
+				/*
+				 * check is dset path is ancestor src path
+				 * if yes, need to update cur_ino path
+				 */
+				if (strncmp(cur->full_path->start, valid_path->start, fs_path_len(cur->full_path)) == 0 &&
+							fs_path_len(valid_path) > fs_path_len(cur->full_path) && valid_path->start[fs_path_len(cur->full_path)] == '/') {
+					cur_is_ancestor = true;
+				}
 
 				ret = orphanize_inode(sctx, ow_inode, ow_gen,
 						cur->full_path);
 				if (ret < 0)
 					goto out;
+
+				/*
+				 * check is waiting dir, if yes change the ino
+				 * to orphanized in the waiting tree.
+				 */
+				if (is_waiting_for_move(sctx, ow_inode)) {
+					wdm = get_waiting_dir_move(sctx, ow_inode);
+					ASSERT(wdm);
+					wdm->orphanized = true;
+				}
+
 				/*
 				 * Make sure we clear our orphanized inode's
 				 * name from the name cache. This is because the
@@ -3630,6 +3654,17 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 					name_cache_delete(sctx, nce);
 					kfree(nce);
 				}
+
+				/*
+				 * if ow_inode is ancestor cur_ino, need to update
+				 * update cur_ino path.
+				 */
+				if (cur_is_ancestor) {
+					fs_path_reset(valid_path);
+					ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, valid_path);
+					if (ret < 0)
+						goto out;
+				}
 			} else {
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
-- 
1.9.1

