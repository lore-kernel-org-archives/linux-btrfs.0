Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35513 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaA2Pcj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 10:32:39 -0500
Received: by mail-pb0-f42.google.com with SMTP id jt11so1904584pbb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 07:32:38 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>
Subject: [PATCH] Btrfs: convert to add transaction protection for btrfs send
Date: Wed, 29 Jan 2014 23:32:19 +0800
Message-Id: <1391009539-2326-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com>
References: <1391009539-2326-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

I sent a patch to kick off transaction from btrfs send, however it gets
a regression that btrfs send try to search extent commit root without
transaction protection.

To fix this regression, we have two ideas:

 1. don't use extent commit root for sending.

 2. add transaction protection to use extent commit root safely.

Both approaches need transaction actually, however, the first approach
will add extent tree lock contention, so we'd better adopt the second
approach.

Luckily, now we only need transaction protection when iterating
extent root, the protection's *range* is smaller than before.

Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/send.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 04c07ed..8d5e151 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4511,6 +4511,7 @@ static int process_extent(struct send_ctx *sctx,
 			  struct btrfs_key *key)
 {
 	struct clone_root *found_clone = NULL;
+	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
 	if (S_ISLNK(sctx->cur_inode_mode))
@@ -4551,10 +4552,24 @@ static int process_extent(struct send_ctx *sctx,
 			}
 		}
 	}
+	/*
+	 * We need to make sure the transaction does not get committed
+	 * while we are walking backrefs on extent commit root.
+	 */
+	trans = btrfs_join_transaction(sctx->send_root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
 	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
 			sctx->cur_inode_size, &found_clone);
-	if (ret != -ENOENT && ret < 0)
+	if (ret != -ENOENT && ret < 0) {
+		btrfs_end_transaction(trans, sctx->send_root);
+		goto out;
+	}
+	ret = btrfs_end_transaction(trans, sctx->send_root);
+	if (ret)
 		goto out;
 
 	ret = send_write_or_clone(sctx, path, key, found_clone);
-- 
1.8.4

