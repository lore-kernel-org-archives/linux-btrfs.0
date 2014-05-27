Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaE0Rx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 13:53:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3A8CEAC6E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 May 2014 17:53:25 +0000 (UTC)
Message-ID: <5384D110.1070006@suse.com>
Date: Tue, 27 May 2014 13:53:20 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: free delayed node outside of root->inode_lock
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On heavy workloads, we're seeing soft lockup warnings on
root->inode_lock in __btrfs_release_delayed_node. The low hanging fruit
is to reduce the size of the critical section.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 33e561a..da775bf 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -149,8 +149,8 @@ again:
 	spin_lock(&root->inode_lock);
 	ret = radix_tree_insert(&root->delayed_nodes_tree, ino, node);
 	if (ret == -EEXIST) {
-		kmem_cache_free(delayed_node_cache, node);
 		spin_unlock(&root->inode_lock);
+		kmem_cache_free(delayed_node_cache, node);
 		radix_tree_preload_end();
 		goto again;
 	}
@@ -267,14 +267,17 @@ static void __btrfs_release_delayed_node(
 	mutex_unlock(&delayed_node->mutex);
 
 	if (atomic_dec_and_test(&delayed_node->refs)) {
+		bool free = false;
 		struct btrfs_root *root = delayed_node->root;
 		spin_lock(&root->inode_lock);
 		if (atomic_read(&delayed_node->refs) == 0) {
 			radix_tree_delete(&root->delayed_nodes_tree,
 					  delayed_node->inode_id);
-			kmem_cache_free(delayed_node_cache, delayed_node);
+			free = true;
 		}
 		spin_unlock(&root->inode_lock);
+		if (free)
+			kmem_cache_free(delayed_node_cache, delayed_node);
 	}
 }
 

-- 
Jeff Mahoney
SUSE Labs
