Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:27298 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbbFVJJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 05:09:00 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 1/7] Revert "Btrfs: incremental send, remove dead code"
Date: Mon, 22 Jun 2015 17:08:42 +0800
Message-Id: <1434964128-31757-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1434964128-31757-1-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 5f806c3ae2ff6263a10a6901f97abb74dac03d36.

Btrfs: incremental send, avoid ancestor rename to descendant

There's one more case where we can't issue a rename operation for a directory
as soon as we process it. We move a directory from ancestor to descendant.

|---- a
    |---- b
        |---- c
             |---- d
"Move a directory from ancestor to descendant" means moving dir. a into dir. c

This case will happen after applying "[PATCH] Btrfs: incremental send,
don't delay directory renames unnecessarily".
Because, that patch changes behavior of wait_for_parent_move function.

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

1. 259 can not move under 258 because 263 needs to move to 263 first.
So 259 is waiting on ance(263).

2. 260 must move to @tmp/other_dir, so it is waiting on other_dir(264).

3. 262 is able to rename as pre/wait_dir/finish_dir2(261)/desc since
wait_dir(260) is waiting and 262 is not the ancestor of wait_dir(260).

4.263 is able to rename as pre/wait_dir/finish_dir2(261)/ance since
wait_dir(260) is waiting and 263 is not the ancestor of wait_dir(260).

5. After wait_dir(263) is finished, all pending dirs. start to run.
    /pre(259) in apply_dir_move() renames /pre as
pre/wait_dir/finish_dir2/desc/ance/finish_dir1/pre
  At the same time, receiving side will encounter error.
  If anyone calls get_cur_path() to any element in
pre/wait_dir/finish_dir2/desc/ance/finish_dir1/pre like wait_dir(260)
,
  there will cause path building loop like this : 260 -> 259 -> 258 ->
263 -> 262 -> 261 -> 260

So fix the problem by check path_loop for this case.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1c1f161..257753b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3080,6 +3080,48 @@ static struct pending_dir_move *get_pending_dir_moves(struct send_ctx *sctx,
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
+		fs_path_reset(name);
+
+		if (is_waiting_for_rm(sctx, ino))
+			break;
+		if (is_waiting_for_move(sctx, ino)) {
+			if (*ancestor_ino == 0)
+				*ancestor_ino = ino;
+			ret = get_first_ref(sctx->parent_root, ino,
+					    &parent_inode, &parent_gen, name);
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
@@ -3091,6 +3133,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	struct waiting_dir_move *dm = NULL;
 	u64 rmdir_ino = 0;
 	int ret;
+	u64 ancestor = 0;
 
 	name = fs_path_alloc();
 	from_path = fs_path_alloc();
@@ -3122,6 +3165,22 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 		goto out;
 
 	sctx->send_progress = sctx->cur_ino + 1;
+	ret = path_loop(sctx, name, pm->ino, pm->gen, &ancestor);
+	if (ret) {
+		LIST_HEAD(deleted_refs);
+		ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
+		ret = add_pending_dir_move(sctx, pm->ino, pm->gen, ancestor,
+					   &pm->update_refs, &deleted_refs,
+					   pm->is_orphan);
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
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
