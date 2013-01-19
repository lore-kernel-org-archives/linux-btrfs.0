Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38574 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3ASP17 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jan 2013 10:27:59 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] btrfs: fix potential null pointer dereference bug
Date: Sat, 19 Jan 2013 16:27:45 +0100
Message-Id: <1358609265-347-1-git-send-email-dinggnu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bug happens when rb_node == NULL. It causes variable node to be NULL and
then the NULL pointer is dereferenced this line:
	BUG_ON((struct btrfs_root *)node->data != root);

Based on my analysis, function tree_search should not return NULL to variable
rb_node in this case (otherwise here has to be something unknown thing wrong),
so I replace "if (rb_node)" with UG_ON(!rb_node).

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/btrfs/relocation.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 17c306b..d674671 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1263,10 +1263,11 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
 	spin_lock(&rc->reloc_root_tree.lock);
 	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
 			      root->commit_root->start);
-	if (rb_node) {
-		node = rb_entry(rb_node, struct mapping_node, rb_node);
-		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
-	}
+	BUG_ON(!rb_node);
+
+	node = rb_entry(rb_node, struct mapping_node, rb_node);
+	rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
+
 	spin_unlock(&rc->reloc_root_tree.lock);
 
 	BUG_ON((struct btrfs_root *)node->data != root);
-- 
1.7.10.4

