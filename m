Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48385 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753178AbdHUJn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 029DEABF3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:55 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/10] btrfs: Remove unused parameters from various functions
Date: Mon, 21 Aug 2017 12:43:44 +0300
Message-Id: <1503308630-6652-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1503308630-6652-1-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

iterate_dir_item:found_key - introduced in 31db9f7c23fb ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive"), yet never used. 

record_ref:num - ditto

This is a first pass with the low-hanging fruit. There are still quite a few
unsued parameters in some function which have to abide by a callback interface.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/send.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 8f1d3d6e7087..85a9509a9cbd 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1002,7 +1002,6 @@ typedef int (*iterate_dir_item_t)(int num, struct btrfs_key *di_key,
  * path must point to the dir item when called.
  */
 static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
-			    struct btrfs_key *found_key,
 			    iterate_dir_item_t iterate, void *ctx)
 {
 	int ret = 0;
@@ -4116,8 +4115,8 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 	return ret;
 }
 
-static int record_ref(struct btrfs_root *root, int num, u64 dir, int index,
-		      struct fs_path *name, void *ctx, struct list_head *refs)
+static int record_ref(struct btrfs_root *root, u64 dir, struct fs_path *name,
+		      void *ctx, struct list_head *refs)
 {
 	int ret = 0;
 	struct send_ctx *sctx = ctx;
@@ -4153,8 +4152,7 @@ static int __record_new_ref(int num, u64 dir, int index,
 			    void *ctx)
 {
 	struct send_ctx *sctx = ctx;
-	return record_ref(sctx->send_root, num, dir, index, name,
-			  ctx, &sctx->new_refs);
+	return record_ref(sctx->send_root, dir, name, ctx, &sctx->new_refs);
 }
 
 
@@ -4163,8 +4161,8 @@ static int __record_deleted_ref(int num, u64 dir, int index,
 				void *ctx)
 {
 	struct send_ctx *sctx = ctx;
-	return record_ref(sctx->parent_root, num, dir, index, name,
-			  ctx, &sctx->deleted_refs);
+	return record_ref(sctx->parent_root, dir, name, ctx,
+			  &sctx->deleted_refs);
 }
 
 static int record_new_ref(struct send_ctx *sctx)
@@ -4508,7 +4506,7 @@ static int process_new_xattr(struct send_ctx *sctx)
 	int ret = 0;
 
 	ret = iterate_dir_item(sctx->send_root, sctx->left_path,
-			       sctx->cmp_key, __process_new_xattr, sctx);
+			       __process_new_xattr, sctx);
 
 	return ret;
 }
@@ -4516,7 +4514,7 @@ static int process_new_xattr(struct send_ctx *sctx)
 static int process_deleted_xattr(struct send_ctx *sctx)
 {
 	return iterate_dir_item(sctx->parent_root, sctx->right_path,
-				sctx->cmp_key, __process_deleted_xattr, sctx);
+				__process_deleted_xattr, sctx);
 }
 
 struct find_xattr_ctx {
@@ -4561,7 +4559,7 @@ static int find_xattr(struct btrfs_root *root,
 	ctx.found_data = NULL;
 	ctx.found_data_len = 0;
 
-	ret = iterate_dir_item(root, path, key, __find_xattr, &ctx);
+	ret = iterate_dir_item(root, path, __find_xattr, &ctx);
 	if (ret < 0)
 		return ret;
 
@@ -4631,11 +4629,11 @@ static int process_changed_xattr(struct send_ctx *sctx)
 	int ret = 0;
 
 	ret = iterate_dir_item(sctx->send_root, sctx->left_path,
-			sctx->cmp_key, __process_changed_new_xattr, sctx);
+			__process_changed_new_xattr, sctx);
 	if (ret < 0)
 		goto out;
 	ret = iterate_dir_item(sctx->parent_root, sctx->right_path,
-			sctx->cmp_key, __process_changed_deleted_xattr, sctx);
+			__process_changed_deleted_xattr, sctx);
 
 out:
 	return ret;
@@ -4685,8 +4683,7 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 			goto out;
 		}
 
-		ret = iterate_dir_item(root, path, &found_key,
-				       __process_new_xattr, sctx);
+		ret = iterate_dir_item(root, path, __process_new_xattr, sctx);
 		if (ret < 0)
 			goto out;
 
-- 
2.7.4

