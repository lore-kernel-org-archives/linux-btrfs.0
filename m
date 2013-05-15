Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab3EOHsj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:39 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 02/17] Btrfs: fix unprotected root node of the subvolume's inode rb-tree
Date: Wed, 15 May 2013 15:48:16 +0800
Message-Id: <1368604111-25073-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root node of the rb-tree may be changed, so we should get it under
the lock. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7f6e78a..bf5c399 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4839,14 +4839,13 @@ static void inode_tree_add(struct inode *inode)
 	struct rb_node **p;
 	struct rb_node *parent;
 	u64 ino = btrfs_ino(inode);
-again:
-	p = &root->inode_tree.rb_node;
-	parent = NULL;
 
 	if (inode_unhashed(inode))
 		return;
-
+again:
+	parent = NULL;
 	spin_lock(&root->inode_lock);
+	p = &root->inode_tree.rb_node;
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
-- 
1.8.1.4

