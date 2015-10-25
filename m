Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32875 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbbJYRPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Oct 2015 13:15:40 -0400
Date: Sun, 25 Oct 2015 20:15:06 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com
Subject: [PATCH v2] btrfs: zero out delayed node upon allocation
Message-ID: <20151025201506.GA10121@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's slightly cleaner to zero-out the delayed node upon allocation
than to do it by hand in btrfs_init_delayed_node() for a few members

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
v2: Thanks Jeff Mahoney for pointing out the mistake of removing
the atomic_set in v1 of the patch. atomic_set() call restored.

 fs/btrfs/delayed-inode.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a2ae427..0a00c4f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -54,16 +54,11 @@ static inline void btrfs_init_delayed_node(
 	delayed_node->root = root;
 	delayed_node->inode_id = inode_id;
 	atomic_set(&delayed_node->refs, 0);
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
@@ -132,7 +127,7 @@ again:
 	if (node)
 		return node;
 
-	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS);
+	node = kmem_cache_zalloc(delayed_node_cache, GFP_NOFS);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	btrfs_init_delayed_node(node, root, ino);
-- 
2.6.2

