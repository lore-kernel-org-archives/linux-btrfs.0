Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab3EOHsh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:37 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 01/17] Btrfs: fix accessing a freed tree root
Date: Wed, 15 May 2013 15:48:15 +0800
Message-Id: <1368604111-25073-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

inode_tree_del() will move the tree root into the dead root list, and
then the tree will be destroyed by the cleaner. So if we remove the
delayed node which is cached in the inode after inode_tree_del(),
we may access a freed tree root. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1669c3b..7f6e78a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4723,6 +4723,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root);
 no_delete:
+	btrfs_remove_delayed_node(inode);
 	clear_inode(inode);
 	return;
 }
@@ -7978,7 +7979,6 @@ void btrfs_destroy_inode(struct inode *inode)
 	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 free:
-	btrfs_remove_delayed_node(inode);
 	call_rcu(&inode->i_rcu, btrfs_i_callback);
 }
 
-- 
1.8.1.4

