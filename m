Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63699 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaFILWv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jun 2014 07:22:51 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so4582444wgh.18
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jun 2014 04:22:50 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: ensure btrfs_prev_leaf doesn't miss 1 item
Date: Mon,  9 Jun 2014 13:22:13 +0100
Message-Id: <1402316533-18089-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We might have had an item with the previous key in the tree right
before we released our path. And after we released our path, that
item might have been pushed to the first slot (0) of the leaf we
were holding due to a tree balance. Alternatively, an item with the
previous key can exist as the only element of a leaf (big fat item).
Therefore account for these 2 cases, so that our callers (like
btrfs_previous_item) don't miss an existing item with a key matching
the previous key we computed above.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d99d965..4eada52 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5097,7 +5097,17 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		return ret;
 	btrfs_item_key(path->nodes[0], &found_key, 0);
 	ret = comp_keys(&found_key, &key);
-	if (ret < 0)
+	/*
+	 * We might have had an item with the previous key in the tree right
+	 * before we released our path. And after we released our path, that
+	 * item might have been pushed to the first slot (0) of the leaf we
+	 * were holding due to a tree balance. Alternatively, an item with the
+	 * previous key can exist as the only element of a leaf (big fat item).
+	 * Therefore account for these 2 cases, so that our callers (like
+	 * btrfs_previous_item) don't miss an existing item with a key matching
+	 * the previous key we computed above.
+	 */
+	if (ret <= 0)
 		return 0;
 	return 1;
 }
-- 
1.9.1

