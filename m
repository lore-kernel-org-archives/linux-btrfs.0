Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752754AbeFHMsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:05 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD2CFAF8D
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 12/15] btrfs-progs: Add __free_extent2 function
Date: Fri,  8 Jun 2018 15:47:55 +0300
Message-Id: <1528462078-24490-13-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a simple adapter to convert the arguments delayed ref arguments
to the existing arguments of __free_extent.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index aff00e536c9c..8789a43c7fea 100644
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

