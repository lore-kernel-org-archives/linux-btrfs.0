Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3LQL6D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 06:58:03 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] Btrfs: remove transaction from btrfs send
Date: Tue, 17 Dec 2013 19:57:21 +0800
Message-Id: <1387281441-16386-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since daivd did the work that force us to use readonly snapshot,
we can safely remove transaction protection from btrfs send.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/send.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 945d1db..9e832f2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4522,7 +4522,6 @@ out:
 static int full_send_tree(struct send_ctx *sctx)
 {
 	int ret;
-	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_root *send_root = sctx->send_root;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -4544,19 +4543,6 @@ static int full_send_tree(struct send_ctx *sctx)
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
-join_trans:
-	/*
-	 * We need to make sure the transaction does not get committed
-	 * while we do anything on commit roots. Join a transaction to prevent
-	 * this.
-	 */
-	trans = btrfs_join_transaction(send_root);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		trans = NULL;
-		goto out;
-	}
-
 	/*
 	 * Make sure the tree has not changed after re-joining. We detect this
 	 * by comparing start_ctransid and ctransid. They should always match.
@@ -4580,19 +4566,6 @@ join_trans:
 		goto out_finish;
 
 	while (1) {
-		/*
-		 * When someone want to commit while we iterate, end the
-		 * joined transaction and rejoin.
-		 */
-		if (btrfs_should_end_transaction(trans, send_root)) {
-			ret = btrfs_end_transaction(trans, send_root);
-			trans = NULL;
-			if (ret < 0)
-				goto out;
-			btrfs_release_path(path);
-			goto join_trans;
-		}
-
 		eb = path->nodes[0];
 		slot = path->slots[0];
 		btrfs_item_key_to_cpu(eb, &found_key, slot);
@@ -4620,12 +4593,6 @@ out_finish:
 
 out:
 	btrfs_free_path(path);
-	if (trans) {
-		if (!ret)
-			ret = btrfs_end_transaction(trans, send_root);
-		else
-			btrfs_end_transaction(trans, send_root);
-	}
 	return ret;
 }
 
-- 
1.8.3.1

