Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36090 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbbJYOsz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 10:48:55 -0400
Date: Sun, 25 Oct 2015 17:48:20 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: zero out delayed node upon allocation
Message-ID: <20151025174820.GA24972@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This allows us to trim out half of btrfs_init_delayed_node()
which is now reduntant.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/delayed-inode.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a2ae427..7aa84be 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -53,17 +53,11 @@ static inline void btrfs_init_delayed_node(
 {
 	delayed_node->root = root;
 	delayed_node->inode_id = inode_id;
-	atomic_set(&delayed_node->refs, 0);
-	delayed_node->count = 0;
-	delayed_node->flags = 0;
 	delayed_node->ins_root = RB_ROOT;
 	delayed_node->del_root = RB_ROOT;
 	mutex_init(&delayed_node->mutex);
-	delayed_node->index_cnt = 0;
 	INIT_LIST_HEAD(&delayed_node->n_list);
 	INIT_LIST_HEAD(&delayed_node->p_list);
-	delayed_node->bytes_reserved = 0;
-	memset(&delayed_node->inode_item, 0, sizeof(delayed_node->inode_item));
 }
 
 static inline int btrfs_is_continuous_delayed_item(
@@ -132,7 +126,7 @@ again:
 	if (node)
 		return node;
 
-	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS);
+	node = kmem_cache_zalloc(delayed_node_cache, GFP_NOFS);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	btrfs_init_delayed_node(node, root, ino);
-- 
2.6.2

