Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36651 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943100AbcJ1BlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:24 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 3/6] Btrfs: incremental send, add generation for waiting_dir_move struct and check it in can_rmdir.
Date: Fri, 28 Oct 2016 09:40:47 +0800
Message-Id: <1477618850-12922-4-git-send-email-robbieko@synology.com>
In-Reply-To: <1477618850-12922-1-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Example scenario:
Parent snapshot:
|---- dir258/ (ino 258, gen 27)
    |---- dir257/ (ino 257, gen 27)
|---- dir259/ (ino 259, gen 27)

Send snapshot:
|---- new_dir259/ (ino 259, gen 38)
    |---- new_dir258/ (ino 258, gen 38)
        |---- new_dir257/ (ino 257, gen 38)

rmdir dir258/dir257
mkdir o257-38-0
mkdir o258-38-0
chown o257-38-0 - uid=0, gid=0
chmod o257-38-0 - mode=0755
rename dir258 -> o258-27-0  -----> dir is empty, but waiting o257-38-0
mkdir o259-38-0
chown o258-38-0 - uid=0, gid=0
chmod o258-38-0 - mode=0755
rmdir dir259
rename o259-38-0 -> new_dir259
utimes
chown new_dir259 - uid=0, gid=0
chmod new_dir259 - mode=0755
rename o258-38-0 -> new_dir259/new_dir258
utimes new_dir259/new_dir258
utimes new_dir259
rename o257-38-0 -> new_dir259/new_dir258/new_dir257
rmdir o258-27-0             -----> when o257-38-0 finish, delete
utimes new_dir259/new_dir258/new_dir257
utimes new_dir259/new_dir258
utimes new_dir259

While computing the send stream the following steps happen:

1) While processing inode 257 we delete dir258/dir257 immediately.
   After create o257-38-0, we then delay its rename operation
   because its new parent in the send snapshot, inode 258,
   was not yet processed and therefore not yet renamed.

2) On processing inode 258, we need to check if all under files are done
   before rmdir dir258. However, the waiting o257-38-0 (ino 257) will
   mislead the check making it think dir257 (ino 257) is still there.
   dir258 will be orphanized at first but in fact it has become empty.

Fix this by adding generation to waiting_dir_move struct, so can_rmdir
can use it to correct the result.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 22eca86..eaf1c92 100644
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
@@ -2930,6 +2931,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 	struct btrfs_key found_key;
 	struct btrfs_key loc;
 	struct btrfs_dir_item *di;
+	u64 gen;
 
 	/*
 	 * Don't try to rmdir the top/root subvolume dir.
@@ -2969,8 +2971,13 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
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
@@ -3010,7 +3017,8 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino)
 	return entry != NULL;
 }
 
-static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
+static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, u64 gen,
+		     bool orphanized)
 {
 	struct rb_node **p = &sctx->waiting_dir_moves.rb_node;
 	struct rb_node *parent = NULL;
@@ -3020,6 +3028,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
 	if (!dm)
 		return -ENOMEM;
 	dm->ino = ino;
+	dm->gen = gen;
 	dm->rmdir_ino = 0;
 	dm->orphanized = orphanized;
 
@@ -3117,7 +3126,7 @@ static int add_pending_dir_move(struct send_ctx *sctx,
 			goto out;
 	}
 
-	ret = add_waiting_dir_move(sctx, pm->ino, is_orphan);
+	ret = add_waiting_dir_move(sctx, pm->ino, pm->gen, is_orphan);
 	if (ret)
 		goto out;
 
-- 
1.9.1

