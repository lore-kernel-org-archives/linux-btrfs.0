Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60428 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751106AbdFTQGA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 12:06:00 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65A51AC14
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 16:05:59 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 04/13] btrfs: backref, add unode_aux_to_inode_list helper
Date: Tue, 20 Jun 2017 10:06:44 -0600
Message-Id: <20170620160653.19907-5-enadolski@suse.com>
In-Reply-To: <20170620160653.19907-1-enadolski@suse.com>
References: <20170620160653.19907-1-enadolski@suse.com>
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

