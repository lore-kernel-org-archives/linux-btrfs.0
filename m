Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:43363 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754366AbeEHKLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 06:11:54 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 2/2] btrfs: incremental send, improve rmdir performance for large directory
Date: Tue,  8 May 2018 18:11:38 +0800
Message-Id: <1525774298-6919-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1525774298-6919-1-git-send-email-robbieko@synology.com>
References: <1525774298-6919-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Currently when checking if we can delete a directory, we always
check if all its children have been processed.

Example: A directory with 2,000,000 files was deleted
Result:
original : 1994m57.071s
patch : 1m38.554s

[FIX]
Instead of checking all children on all calls to can_rmdir(),
we keep track of the directory index offset of the child last
checked in the last call to can_rmdir(), and then use it as the
starting point for future calls to can_rmdir().

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
V2:
 fix comments
 split optimization allocations orphan_dir_info

 fs/btrfs/send.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2830871..a477268 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -247,6 +247,7 @@ struct orphan_dir_info {
 	struct rb_node node;
 	u64 ino;
 	u64 gen;
+	u64 last_dir_index_offset;
 };
 
 struct name_cache_entry {
@@ -2872,6 +2873,7 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 		return ERR_PTR(-ENOMEM);
 	odi->ino = dir_ino;
 	odi->gen = 0;
+	odi->last_dir_index_offset = 0;
 
 	rb_link_node(&odi->node, parent, p);
 	rb_insert_color(&odi->node, &sctx->orphan_dirs);
@@ -2927,6 +2929,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	struct btrfs_key found_key;
 	struct btrfs_key loc;
 	struct btrfs_dir_item *di;
+	struct orphan_dir_info *odi = NULL;
 
 	/*
 	 * Don't try to rmdir the top/root subvolume dir.
@@ -2941,6 +2944,11 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	key.objectid = dir;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = 0;
+
+	odi = get_orphan_dir_info(sctx, dir);
+	if (odi)
+		key.offset = odi->last_dir_index_offset;
+
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -2968,30 +2976,33 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 
 		dm = get_waiting_dir_move(sctx, loc.objectid);
 		if (dm) {
-			struct orphan_dir_info *odi;
-
 			odi = add_orphan_dir_info(sctx, dir);
 			if (IS_ERR(odi)) {
 				ret = PTR_ERR(odi);
 				goto out;
 			}
 			odi->gen = dir_gen;
+			odi->last_dir_index_offset = found_key.offset;
 			dm->rmdir_ino = dir;
 			ret = 0;
 			goto out;
 		}
 
 		if (loc.objectid > send_progress) {
-			struct orphan_dir_info *odi;
-
-			odi = get_orphan_dir_info(sctx, dir);
-			free_orphan_dir_info(sctx, odi);
+			odi = add_orphan_dir_info(sctx, dir);
+			if (IS_ERR(odi)) {
+				ret = PTR_ERR(odi);
+				goto out;
+			}
+			odi->gen = dir_gen;
+			odi->last_dir_index_offset = found_key.offset;
 			ret = 0;
 			goto out;
 		}
 
 		path->slots[0]++;
 	}
+	free_orphan_dir_info(sctx, odi);
 
 	ret = 1;
 
@@ -3269,13 +3280,16 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 
 	if (rmdir_ino) {
 		struct orphan_dir_info *odi;
+		u64 gen;
 
 		odi = get_orphan_dir_info(sctx, rmdir_ino);
 		if (!odi) {
 			/* already deleted */
 			goto finish;
 		}
-		ret = can_rmdir(sctx, rmdir_ino, odi->gen, sctx->cur_ino);
+		gen = odi->gen;
+
+		ret = can_rmdir(sctx, rmdir_ino, gen, sctx->cur_ino);
 		if (ret < 0)
 			goto out;
 		if (!ret)
@@ -3286,13 +3300,12 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 			ret = -ENOMEM;
 			goto out;
 		}
-		ret = get_cur_path(sctx, rmdir_ino, odi->gen, name);
+		ret = get_cur_path(sctx, rmdir_ino, gen, name);
 		if (ret < 0)
 			goto out;
 		ret = send_rmdir(sctx, name);
 		if (ret < 0)
 			goto out;
-		free_orphan_dir_info(sctx, odi);
 	}
 
 finish:
-- 
1.9.1

