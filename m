Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59982 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754096AbeGCJKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 05:10:17 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE856AD79
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 09:10:15 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs: relocation: Only remove reloc rb_trees if reloc control has been initialized
Date: Tue,  3 Jul 2018 17:10:07 +0800
Message-Id: <20180703091009.16399-4-wqu@suse.com>
In-Reply-To: <20180703091009.16399-1-wqu@suse.com>
References: <20180703091009.16399-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Invalid tree reloc tree can cause kernel NULL pointer dereference when
btrfs does some cleanup for reloc roots.

It turns out that fs_info->reloc_ctl can be NULL in
btrfs_recover_relocation() as we allocate relocation control after all
reloc roots are verified.
So when we hit out: tag, we haven't call set_reloc_control() thus
fs_info->reloc_ctl is still NULL.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199833
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..be94c65bb4d2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1321,18 +1321,19 @@ static void __del_reloc_root(struct btrfs_root *root)
 	struct mapping_node *node = NULL;
 	struct reloc_control *rc = fs_info->reloc_ctl;
 
-	spin_lock(&rc->reloc_root_tree.lock);
-	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
-			      root->node->start);
-	if (rb_node) {
-		node = rb_entry(rb_node, struct mapping_node, rb_node);
-		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
+	if (rc) {
+		spin_lock(&rc->reloc_root_tree.lock);
+		rb_node = tree_search(&rc->reloc_root_tree.rb_root,
+				      root->node->start);
+		if (rb_node) {
+			node = rb_entry(rb_node, struct mapping_node, rb_node);
+			rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
+		}
+		spin_unlock(&rc->reloc_root_tree.lock);
+		if (!node)
+			return;
+		BUG_ON((struct btrfs_root *)node->data != root);
 	}
-	spin_unlock(&rc->reloc_root_tree.lock);
-
-	if (!node)
-		return;
-	BUG_ON((struct btrfs_root *)node->data != root);
 
 	spin_lock(&fs_info->trans_lock);
 	list_del_init(&root->root_list);
-- 
2.18.0

