Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41931 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaF1ACl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 20:02:41 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <mfasheh@suse.de>
Subject: [PATCH] Btrfs: make sure to use btrfs_header_owner when freeing tree block
Date: Fri, 27 Jun 2014 17:02:30 -0700
Message-ID: <1403913750-20135-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark noticed that his qgroup accounting for snapshot deletion wasn't working
properly on a particular file system.  Turns out we pass the root->objectid of
the root we are deleting to btrfs_free_extent, and use that root always when we
call btrfs_free_tree_block.  This isn't correct, the owner must match the
btrfs_header_owner() of the eb.  So to fix this we need to use that when we call
btrfs_free_extent, and we also need to use btrfs_header_owner(eb) in
btrfs_free_tree_block as the root we pass in may not be the owner in the case of
snapshot delete (though it is for all the normal cases which is why it wasn't
noticed before.)  With this patch on top of Mark's snapshot delete patch
everything is working a-ok.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7671b15..7f9bb7c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6189,7 +6189,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
 					buf->start, buf->len,
-					parent, root->root_key.objectid,
+					parent, btrfs_header_owner(eb),
 					btrfs_header_level(buf),
 					BTRFS_DROP_DELAYED_REF, NULL, 0);
 		BUG_ON(ret); /* -ENOMEM */
@@ -7925,7 +7925,8 @@ skip:
 		}
 
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
-				root->root_key.objectid, level - 1, 0, 0);
+					btrfs_header_owner(next), level - 1, 0,
+					0);
 		BUG_ON(ret); /* -ENOMEM */
 	}
 	btrfs_tree_unlock(next);
-- 
2.0.0

