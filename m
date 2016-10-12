Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:52716 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbcJLINm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 04:13:42 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 3/5] Btrfs: incremental send, add gen in waiting_dir_move for some corner case
Date: Wed, 12 Oct 2016 16:12:48 +0800
Message-Id: <1476259970-1866-4-git-send-email-robbieko@synology.com>
In-Reply-To: <1476259970-1866-1-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

There a some case similar as before.
add compare generation with dir items,
and waiting_dir_move in the can_rmdir.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 95d3718..d908624 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -237,6 +237,7 @@ struct pending_dir_move {
 struct waiting_dir_move {
 	struct rb_node node;
 	u64 ino;
+	u64 gen;
 	/*
 	 * There might be some directory that could not be removed because it
 	 * was waiting for this directory inode to be moved first. Therefore
@@ -2931,6 +2932,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	struct btrfs_key found_key;
 	struct btrfs_key loc;
 	struct btrfs_dir_item *di;
+	u64 gen;
 
 	/*
 	 * Don't try to rmdir the top/root subvolume dir.
@@ -2970,8 +2972,13 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 				struct btrfs_dir_item);
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &loc);
 
+		ret = get_inode_info(root, loc.objectid, NULL, &gen, NULL,
+				     NULL, NULL, NULL);
+		if (ret < 0)
+			goto out;
+
 		dm = get_waiting_dir_move(sctx, loc.objectid);
-		if (dm) {
+		if (dm && dm->gen == gen) {
 			struct orphan_dir_info *odi;
 
 			odi = add_orphan_dir_info(sctx, dir);
@@ -3011,7 +3018,7 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino)
 	return entry != NULL;
 }
 
-static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
+static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, u64 gen, bool orphanized)
 {
 	struct rb_node **p = &sctx->waiting_dir_moves.rb_node;
 	struct rb_node *parent = NULL;
@@ -3021,6 +3028,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
 	if (!dm)
 		return -ENOMEM;
 	dm->ino = ino;
+	dm->gen = gen;
 	dm->rmdir_ino = 0;
 	dm->orphanized = orphanized;
 
@@ -3118,7 +3126,7 @@ static int add_pending_dir_move(struct send_ctx *sctx,
 			goto out;
 	}
 
-	ret = add_waiting_dir_move(sctx, pm->ino, is_orphan);
+	ret = add_waiting_dir_move(sctx, pm->ino, pm->gen, is_orphan);
 	if (ret)
 		goto out;
 
-- 
1.9.1

