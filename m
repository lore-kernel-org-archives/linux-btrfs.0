Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403797AbeHPQJJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:09 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD811AE66
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:37 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 1/8] btrfs-progs: Add __free_extent2 function
Date: Thu, 16 Aug 2018 16:10:28 +0300
Message-Id: <1534425035-323-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a simple adapter to convert the arguments delayed ref arguments
to the existing arguments of __free_extent.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 extent-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index 5d49af5a901e..34409e600087 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2136,6 +2136,17 @@ void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 	update_pinned_extents(fs_info, bytenr, num_bytes, 0);
 }
 
+static int __free_extent2(struct btrfs_trans_handle *trans,
+			  struct btrfs_delayed_ref_node *node,
+			  struct btrfs_delayed_extent_op *extent_op)
+{
+
+	struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
+
+	return __free_extent(trans, node->bytenr, node->num_bytes,
+			     ref->parent, ref->root, ref->level, 0, 1);
+}
+
 /*
  * remove an extent from the root, returns 0 on success
  */
-- 
2.7.4
