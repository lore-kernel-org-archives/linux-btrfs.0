Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33273 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaBHPsq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 10:48:46 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so4491889pbc.38
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 07:48:46 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>
Subject: [RFC PATCH 2/2] Revert "Btrfs: remove transaction from btrfs send"
Date: Sat,  8 Feb 2014 23:46:36 +0800
Message-Id: <1391874396-2273-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391874396-2273-1-git-send-email-wangshilong1991@gmail.com>
References: <1391874396-2273-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

This reverts commit 41ce9970a8a6a362ae8df145f7a03d789e9ef9d2.
Previously i was thinking we can use readonly root's commit root
safely while it is not true, readonly root may be cowed with the
following cases.

1.snapshot send root will cow source root.
2.balance,device operations will also cow readonly send root
to relocate.

So i have two ideas to make us safe to use commit root.

-->approach 1:
make it protected by transaction and end transaction properly and we research
next item from root node(see btrfs_search_slot_for_read()).

-->approach 2:
add another counter to local root structure to sync snapshot with send.
and add a global counter to sync send with exclusive device operations.

So with approach 2, send can use commit root safely, because we make sure
send root can not be cowed during send. Unfortunately, it make codes *ugly*
and more complex to maintain.

To make snapshot and send exclusively, device operations and send operation
exclusively with each other is a little confusing for common users.

So why not drop into previous way.

Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Josef, if we reach agreement to adopt this approach, please revert
Filipe's patch(Btrfs: make some tree searches in send.c more efficient)
from btrfs-next.
---
 fs/btrfs/send.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 168b9ec..e9d1265 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5098,6 +5098,7 @@ out:
 static int full_send_tree(struct send_ctx *sctx)
 {
 	int ret;
+	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_root *send_root = sctx->send_root;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -5119,6 +5120,19 @@ static int full_send_tree(struct send_ctx *sctx)
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
+join_trans:
+	/*
+	 * We need to make sure the transaction does not get committed
+	 * while we do anything on commit roots. Join a transaction to prevent
+	 * this.
+	 */
+	trans = btrfs_join_transaction(send_root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		goto out;
+	}
+
 	/*
 	 * Make sure the tree has not changed after re-joining. We detect this
 	 * by comparing start_ctransid and ctransid. They should always match.
@@ -5142,6 +5156,19 @@ static int full_send_tree(struct send_ctx *sctx)
 		goto out_finish;
 
 	while (1) {
+		/*
+		 * When someone want to commit while we iterate, end the
+		 * joined transaction and rejoin.
+		 */
+		if (btrfs_should_end_transaction(trans, send_root)) {
+			ret = btrfs_end_transaction(trans, send_root);
+			trans = NULL;
+			if (ret < 0)
+				goto out;
+			btrfs_release_path(path);
+			goto join_trans;
+		}
+
 		eb = path->nodes[0];
 		slot = path->slots[0];
 		btrfs_item_key_to_cpu(eb, &found_key, slot);
@@ -5169,6 +5196,12 @@ out_finish:
 
 out:
 	btrfs_free_path(path);
+	if (trans) {
+		if (!ret)
+			ret = btrfs_end_transaction(trans, send_root);
+		else
+			btrfs_end_transaction(trans, send_root);
+	}
 	return ret;
 }
 
-- 
1.8.4

