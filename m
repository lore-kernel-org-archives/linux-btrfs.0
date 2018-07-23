Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbeGWJKL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 05:10:11 -0400
Received: from debian3.lan (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B443C20874
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 08:10:11 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unused key assignment when doing a full send
Date: Mon, 23 Jul 2018 09:10:09 +0100
Message-Id: <20180723081009.4884-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

At send.c:full_send_tree() we were setting the 'key' variable in the loop
while never using it later. We were also using two btrfs_key variables
to store the initial key for search and the key found in every iteration
of the loop. So remove this useless key assignment and use the same
btrfs_key variable to store the initial search key and the key found in
each iteration. This was introduced in the initial send commit but was
never used (commit 31db9f7c23fb ("Btrfs: introduce BTRFS_IOC_SEND for
btrfs send/receive").

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6ffe1c983b76..8acc0e712cfa 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6451,7 +6451,6 @@ static int full_send_tree(struct send_ctx *sctx)
 	int ret;
 	struct btrfs_root *send_root = sctx->send_root;
 	struct btrfs_key key;
-	struct btrfs_key found_key;
 	struct btrfs_path *path;
 	struct extent_buffer *eb;
 	int slot;
@@ -6473,17 +6472,13 @@ static int full_send_tree(struct send_ctx *sctx)
 	while (1) {
 		eb = path->nodes[0];
 		slot = path->slots[0];
-		btrfs_item_key_to_cpu(eb, &found_key, slot);
+		btrfs_item_key_to_cpu(eb, &key, slot);
 
-		ret = changed_cb(path, NULL, &found_key,
+		ret = changed_cb(path, NULL, &key,
 				 BTRFS_COMPARE_TREE_NEW, sctx);
 		if (ret < 0)
 			goto out;
 
-		key.objectid = found_key.objectid;
-		key.type = found_key.type;
-		key.offset = found_key.offset + 1;
-
 		ret = btrfs_next_item(send_root, path);
 		if (ret < 0)
 			goto out;
-- 
2.11.0

