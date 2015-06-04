Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:13780 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbFDL1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 07:27:54 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 2/5] Btrfs: incremental send, avoid ancestor rename to descendant
Date: Thu,  4 Jun 2015 19:18:07 +0800
Message-Id: <1433416690-19177-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1433416690-19177-1-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Base on [PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily

There's one case where we can't issue a rename operation for a directory
as soon as we process it. We move a directory from ancestor to descendant,
if not wait_parent_move or wait_for_dest_dir_move so that happen path loop.

Example:

Parent snapshot:
|---- @tmp/ (ino 257)
|---- pre/ (ino 259)
  |---- wait_dir (ino 260)
    |---- finish_dir2/ (ino 261)
|---- ance/ (ino 263)
  |---- finish_dir1/ (ino 258)
|---- desc/ (ino 262)
|---- other_dir/ (ino 264)

Send snapshot:
|---- @tmp/ (ino 257)
  |---- other_dir/ (ino 264)
    |---- wait_dir/ (ino 260)
      |---- finish_dir2/ (ino 261)
        |---- desc/ (ino 262)
          |---- ance/ (ino 263)
            |---- finish_dir1/ (ino 258)
              |---- pre/ (ino 259)
Here we can not rename 263 from ance to ance/finish_dir1/pre/wait_dir/finish_dir2/desc/ance
without the rename of inode 260, so that happen path loop.
So fix this by delaying directory renames for this case.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fbfbb8b..596b9dc 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3078,6 +3078,56 @@ static struct pending_dir_move *get_pending_dir_moves(struct send_ctx *sctx,
 	return NULL;
 }
 
+static int path_loop(struct send_ctx *sctx, struct fs_path *name,
+		     u64 ino, u64 gen, u64 *ancestor_ino)
+{
+	int ret = 0;
+	u64 parent_inode = 0;
+	u64 parent_gen = 0;
+	u64 start_ino = ino;
+
+	*ancestor_ino = 0;
+	while (ino != BTRFS_FIRST_FREE_OBJECTID) {
+		struct waiting_dir_move *wdm;
+		fs_path_reset(name);
+
+		if (is_waiting_for_rm(sctx, ino))
+			break;
+
+		wdm = get_waiting_dir_move(sctx, ino);
+		if (wdm) {
+			if (*ancestor_ino == 0)
+				*ancestor_ino = ino;
+			if (wdm->orphanized) {
+				ret = gen_unique_name(sctx, ino, gen, name);
+				break;
+			} else {
+				ret = get_first_ref(sctx->parent_root, ino,
+									&parent_inode, &parent_gen, name);
+			}
+		} else {
+			ret = __get_cur_name_and_parent(sctx, ino, gen,
+							&parent_inode,
+							&parent_gen, name);
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+		}
+		if (ret < 0)
+			break;
+		if (parent_inode == start_ino) {
+			ret = 1;
+			if (*ancestor_ino == 0)
+				*ancestor_ino = ino;
+			break;
+		}
+		ino = parent_inode;
+		gen = parent_gen;
+	}
+	return ret;
+}
+
 static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 {
 	struct fs_path *from_path = NULL;
@@ -3089,6 +3139,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	struct waiting_dir_move *dm = NULL;
 	u64 rmdir_ino = 0;
 	int ret;
+	u64 ancestor = 0;
 	bool is_orphan;
 
 	name = fs_path_alloc();
@@ -3122,6 +3173,22 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 		goto out;
 
 	sctx->send_progress = sctx->cur_ino + 1;
+	ret = path_loop(sctx, name, pm->ino, pm->gen, &ancestor);
+	if (ret) {
+		LIST_HEAD(deleted_refs);
+		ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
+		ret = add_pending_dir_move(sctx, pm->ino, pm->gen, ancestor,
+									&pm->update_refs, &deleted_refs,
+									is_orphan);
+		if (ret < 0)
+			goto out;
+		if (rmdir_ino) {
+			dm = get_waiting_dir_move(sctx, pm->ino);
+			ASSERT(dm);
+			dm->rmdir_ino = rmdir_ino;
+		}
+		goto out;
+	}
 	fs_path_reset(name);
 	to_path = name;
 	name = NULL;
@@ -3693,6 +3760,34 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		}
 
 		/*
+		 * if cur_ino is cur ancestor, can't move now,
+		 * find descendant who is waiting, waiting it.
+		 */
+		if (can_rename && (strncmp(valid_path->start, cur->full_path->start, fs_path_len(valid_path)) == 0) &&
+							fs_path_len(cur->full_path) > fs_path_len(valid_path) && cur->full_path->start[fs_path_len(valid_path)] == '/') {
+			struct fs_path *name = NULL;
+			u64 ancestor;
+			u64 old_send_progress = sctx->send_progress;
+
+			name = fs_path_alloc();
+			sctx->send_progress = sctx->cur_ino + 1;
+			ret = path_loop(sctx, name, sctx->cur_ino, sctx->cur_inode_gen, &ancestor);
+			if (ret) {
+				ret = add_pending_dir_move(sctx, sctx->cur_ino, sctx->cur_inode_gen,
+							ancestor, &sctx->new_refs, &sctx->deleted_refs, is_orphan);
+				if (ret < 0) {
+					sctx->send_progress = old_send_progress;
+					fs_path_free(name);
+					goto out;
+				}
+				can_rename = false;
+				*pending_move = 1;
+			}
+			sctx->send_progress = old_send_progress;
+			fs_path_free(name);
+		}
+
+		/*
 		 * link/move the ref to the new place. If we have an orphan
 		 * inode, move it and update valid_path. If not, link or move
 		 * it depending on the inode mode.
-- 
1.9.1

