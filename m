Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaCJP0b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 11:26:31 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v4 1/2] Btrfs: rename waiting_dir_move
Date: Mon, 10 Mar 2014 23:26:03 +0800
Message-Id: <1394465164-18394-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparation work, rename waiting_dir_move to send_dir_node.
We'd like to share waiting_dir_move structure in new did_create_dir() code.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v4: Rebase onto the latest btrfs-next.
v3: Nothing.
v2: Fix wrong patch name.

 fs/btrfs/send.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6463691..1a528d0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -233,7 +233,7 @@ struct pending_dir_move {
 	struct list_head update_refs;
 };
 
-struct waiting_dir_move {
+struct send_dir_node {
 	struct rb_node node;
 	u64 ino;
 	/*
@@ -273,7 +273,7 @@ struct name_cache_entry {
 
 static int is_waiting_for_move(struct send_ctx *sctx, u64 ino);
 
-static struct waiting_dir_move *
+static struct send_dir_node *
 get_waiting_dir_move(struct send_ctx *sctx, u64 ino);
 
 static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino);
@@ -2802,7 +2802,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 		goto out;
 
 	while (1) {
-		struct waiting_dir_move *dm;
+		struct send_dir_node *dm;
 
 		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
 			ret = btrfs_next_leaf(root, path);
@@ -2854,7 +2854,7 @@ out:
 
 static int is_waiting_for_move(struct send_ctx *sctx, u64 ino)
 {
-	struct waiting_dir_move *entry = get_waiting_dir_move(sctx, ino);
+	struct send_dir_node *entry = get_waiting_dir_move(sctx, ino);
 
 	return entry != NULL;
 }
@@ -2863,7 +2863,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 {
 	struct rb_node **p = &sctx->waiting_dir_moves.rb_node;
 	struct rb_node *parent = NULL;
-	struct waiting_dir_move *entry, *dm;
+	struct send_dir_node *entry, *dm;
 
 	dm = kmalloc(sizeof(*dm), GFP_NOFS);
 	if (!dm)
@@ -2873,7 +2873,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 
 	while (*p) {
 		parent = *p;
-		entry = rb_entry(parent, struct waiting_dir_move, node);
+		entry = rb_entry(parent, struct send_dir_node, node);
 		if (ino < entry->ino) {
 			p = &(*p)->rb_left;
 		} else if (ino > entry->ino) {
@@ -2889,14 +2889,14 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 	return 0;
 }
 
-static struct waiting_dir_move *
+static struct send_dir_node *
 get_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 {
 	struct rb_node *n = sctx->waiting_dir_moves.rb_node;
-	struct waiting_dir_move *entry;
+	struct send_dir_node *entry;
 
 	while (n) {
-		entry = rb_entry(n, struct waiting_dir_move, node);
+		entry = rb_entry(n, struct send_dir_node, node);
 		if (ino < entry->ino)
 			n = n->rb_left;
 		else if (ino > entry->ino)
@@ -2908,7 +2908,7 @@ get_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 }
 
 static void free_waiting_dir_move(struct send_ctx *sctx,
-				  struct waiting_dir_move *dm)
+				  struct send_dir_node *dm)
 {
 	if (!dm)
 		return;
@@ -3004,7 +3004,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	u64 orig_progress = sctx->send_progress;
 	struct recorded_ref *cur;
 	u64 parent_ino, parent_gen;
-	struct waiting_dir_move *dm = NULL;
+	struct send_dir_node *dm = NULL;
 	u64 rmdir_ino = 0;
 	int ret;
 
@@ -5696,10 +5696,10 @@ out:
 	WARN_ON(sctx && !ret && !RB_EMPTY_ROOT(&sctx->waiting_dir_moves));
 	while (sctx && !RB_EMPTY_ROOT(&sctx->waiting_dir_moves)) {
 		struct rb_node *n;
-		struct waiting_dir_move *dm;
+		struct send_dir_node *dm;
 
 		n = rb_first(&sctx->waiting_dir_moves);
-		dm = rb_entry(n, struct waiting_dir_move, node);
+		dm = rb_entry(n, struct send_dir_node, node);
 		rb_erase(&dm->node, &sctx->waiting_dir_moves);
 		kfree(dm);
 	}
-- 
1.8.1.4

