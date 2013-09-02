Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:57586 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab3IBLTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 07:19:20 -0400
Received: by mail-we0-f175.google.com with SMTP id m46so3504727wev.34
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Sep 2013 04:19:19 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: more efficient inode tree replace operation
Date: Mon,  2 Sep 2013 12:19:13 +0100
Message-Id: <1378120753-21061-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of removing the current inode from the red black tree
and then add the new one, just use the red black tree replace
operation, which is more efficient.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 26992ee..aa22926 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4688,11 +4688,11 @@ static void inode_tree_add(struct inode *inode)
 	struct btrfs_inode *entry;
 	struct rb_node **p;
 	struct rb_node *parent;
+	struct rb_node *new = &BTRFS_I(inode)->rb_node;
 	u64 ino = btrfs_ino(inode);
 
 	if (inode_unhashed(inode))
 		return;
-again:
 	parent = NULL;
 	spin_lock(&root->inode_lock);
 	p = &root->inode_tree.rb_node;
@@ -4707,14 +4707,14 @@ again:
 		else {
 			WARN_ON(!(entry->vfs_inode.i_state &
 				  (I_WILL_FREE | I_FREEING)));
-			rb_erase(parent, &root->inode_tree);
+			rb_replace_node(parent, new, &root->inode_tree);
 			RB_CLEAR_NODE(parent);
 			spin_unlock(&root->inode_lock);
-			goto again;
+			return;
 		}
 	}
-	rb_link_node(&BTRFS_I(inode)->rb_node, parent, p);
-	rb_insert_color(&BTRFS_I(inode)->rb_node, &root->inode_tree);
+	rb_link_node(new, parent, p);
+	rb_insert_color(new, &root->inode_tree);
 	spin_unlock(&root->inode_lock);
 }
 
-- 
1.7.9.5

