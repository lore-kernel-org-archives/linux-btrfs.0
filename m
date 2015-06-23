Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:5902 "EHLO mail.synology.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbbFWKkB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 06:40:01 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v3 3/7] Btrfs: incremental send, avoid ancestor rename to descendant
Date: Tue, 23 Jun 2015 18:39:47 +0800
Message-Id: <1435055991-10109-4-git-send-email-robbieko@synology.com>
In-Reply-To: <1435055991-10109-1-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one more case where we can't issue a rename operation
for a directory	as soon as we process it. We move a directory
from ancestor to descendant.

|---- a
    |---- b
        |---- c
             |---- d
"Move a directory from ancestor to descendant" means moving
dir. a into dir. c

This case will happen after applying "[PATCH] Btrfs: incremental
send, don't delay directory renames unnecessarily".
Because, that patch changes behavior of wait_for_parent_move function.

Example:
Parent snapshot:
|---- @tmp/ (ino 257)
|---- pre/ (ino 260)
    |---- wait_dir (ino 261)
|---- ance/ (ino 263)
    |---- wait_at_below_ance/ (ino 259)
|---- desc/ (ino 262)
|---- other_dir/ (ino 264)

Send snapshot:
|---- @tmp/ (ino 257)
    |---- other_dir/ (ino 264)
        |---- wait_at_below_ance/ (ino 259)
            |---- pre/ (ino 260)
        |---- wait_dir/ (ino 261)
            |---- desc/ (ino 262)
                |---- ance/ (ino 263)

1. 259 must move to @tmp/other_dir, so it is waiting on other_dir(264).

2. 260 is able to rename as ance/wait_at_below_ance/pre since
wait_at_below_ance(259) is waiting and 260 is not the ancestor
of wait_at_below_ance(259).

3. 261 must move to @tmp/other_dir, so it is waiting on other_dir(264).

4. 262 is able to rename as ance/wait_at_below_ance/pre/wait_dir/desc since
wait_dir(261) is waiting and 262 is not the ancestor of wait_dir(261).

5. 263 is rename as ance/wait_at_below_ance/pre/wait_dir/desc/ance since
wait_dir(261) is waiting and 263 is not the ancestor of wait_dir(261).
  At the same time, receiving side will encounter error.
  If anyone calls get_cur_path() to any element in
ance/wait_at_below_ance/pre/wait_dir/desc/ance like wait_dir(260),
  there will cause path building loop like this : 261 -> 260 -> 259 ->
263 -> 262 -> 261

So fix the problem by check path_loop for this case.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---

V3: add error handling and modify comment and coding style

 fs/btrfs/send.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 95dc1d4..ca8cb87 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3089,13 +3089,18 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
 
 	*ancestor_ino = 0;
 	while (ino != BTRFS_FIRST_FREE_OBJECTID) {
+		struct waiting_dir_move *wdm;
 		fs_path_reset(name);
 
 		if (is_waiting_for_rm(sctx, ino))
 			break;
-		if (is_waiting_for_move(sctx, ino)) {
+
+		wdm = get_waiting_dir_move(sctx, ino);
+		if (wdm) {
 			if (*ancestor_ino == 0)
 				*ancestor_ino = ino;
+			if (wdm->orphanized)
+				break;
 			ret = get_first_ref(sctx->parent_root, ino,
 					    &parent_inode, &parent_gen, name);
 		} else {
@@ -3748,6 +3753,48 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		}
 
 		/*
+		 * need to check whether rename/move causes path loop.
+		 * If it does, need to delay the rename of the current
+		 * inode (sctx->cur_ino), then perform after the rename of
+		 * its ancestor.
+		 */
+		if (S_ISDIR(sctx->cur_inode_mode) &&
+			    sctx->parent_root && can_rename) {
+			struct fs_path *name = NULL;
+			u64 ancestor;
+			u64 old_send_progress = sctx->send_progress;
+
+			name = fs_path_alloc();
+			if (!name) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			sctx->send_progress = sctx->cur_ino + 1;
+			ret = path_loop(sctx, name, sctx->cur_ino,
+						sctx->cur_inode_gen, &ancestor);
+			if (ret) {
+				ret = add_pending_dir_move(sctx, sctx->cur_ino,
+							   sctx->cur_inode_gen,
+							   ancestor,
+							   &sctx->new_refs,
+							   &sctx->deleted_refs,
+							   is_orphan);
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
+			if (ret < 0)
+				goto out;
+		}
+
+		/*
 		 * link/move the ref to the new place. If we have an orphan
 		 * inode, move it and update valid_path. If not, link or move
 		 * it depending on the inode mode.
-- 
1.9.1

