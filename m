Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52037 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751661AbdF2D4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 23:56:12 -0400
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: [PATCH v2 04/13] btrfs: backref, add unode_aux_to_inode_list helper
Date: Wed, 28 Jun 2017 21:56:56 -0600
Message-Id: <20170629035705.1589-5-enadolski@suse.com>
In-Reply-To: <20170629035705.1589-1-enadolski@suse.com>
References: <20170629035705.1589-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Replacing the double cast and ternary conditional with a helper makes
the code easier on the eyes.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 9d6474d..4a7a4b0 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -682,6 +682,14 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static struct extent_inode_elem *
+unode_aux_to_inode_list(struct ulist_node *node)
+{
+	if (!node)
+		return NULL;
+	return (struct extent_inode_elem *)(uintptr_t)node->aux;
+}
+
 /*
  * resolve all indirect backrefs from the list
  */
@@ -736,8 +744,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		ULIST_ITER_INIT(&uiter);
 		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
-		ref->inode_list = node ?
-			(struct extent_inode_elem *)(uintptr_t)node->aux : NULL;
+		ref->inode_list = unode_aux_to_inode_list(node);
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, &uiter))) {
@@ -749,8 +756,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			}
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
-			new_ref->inode_list = (struct extent_inode_elem *)
-							(uintptr_t)node->aux;
+			new_ref->inode_list = unode_aux_to_inode_list(node);
 			list_add(&new_ref->list, &ref->list);
 		}
 		ulist_reinit(parents);
@@ -1476,7 +1482,7 @@ static void free_leaf_list(struct ulist *blocks)
 	while ((node = ulist_next(blocks, &uiter))) {
 		if (!node->aux)
 			continue;
-		eie = (struct extent_inode_elem *)(uintptr_t)node->aux;
+		eie = unode_aux_to_inode_list(node);
 		free_inode_elem_list(eie);
 		node->aux = 0;
 	}
-- 
2.10.2

