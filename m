Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45703 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbeC3J6v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 05:58:51 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E986AE1C
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 09:58:50 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Replace owner argument in add_pinned_bytes with a boolean
Date: Fri, 30 Mar 2018 12:58:47 +0300
Message-Id: <1522403927-16945-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_pinned_bytes reallyc ares whether the bytes being pinned are either
data or metadata. To that effect is checks whether the 'owner' argument
is less than BTRFS_FIRST_FREE_OBJECTID (256). This works because
owner can really have 2 types of values:
 a) For metadata extents it holds the level at which the parent is in
 the btree. This amounts to owner having the values 0-7

 b) In case of modifying data extentsi, owner is the inode number
 to which those extents belongs.

Let's make this more explicit byt converting the owner parameter to a
boolean value and either pass it directly when we know the type of
extents we are working with (i.e. in btrfs_free_tree_block). In cases
when the parent function can be called on both metadata/data extents
perform the check in the caller. This hopefully makes the interface
of add_pinned_bytes more intuitive.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

As an added bonus (but not changelog noteworthy) we even get a slight 
reduction in size (likely due to de-inlining):

add/remove: 0/0 grow/shrink: 2/2 up/down: 21/-65 (-44)
Function                                     old     new   delta
btrfs_free_extent                            238     249     +11
btrfs_inc_extent_ref                         197     207     +10
add_pinned_bytes                             109     104      -5
btrfs_free_tree_block                        906     846     -60
Total: Before=89122, After=89078, chg -0.05%

 fs/btrfs/extent-tree.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0fe196f19e66..1a663b820a7b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -756,12 +756,12 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 }
 
 static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
-			     u64 owner, u64 root_objectid)
+			     bool metadata, u64 root_objectid)
 {
 	struct btrfs_space_info *space_info;
 	u64 flags;
 
-	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
+	if (metadata) {
 		if (root_objectid == BTRFS_CHUNK_TREE_OBJECTID)
 			flags = BTRFS_BLOCK_GROUP_SYSTEM;
 		else
@@ -2212,8 +2212,10 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
-	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
-		add_pinned_bytes(fs_info, -num_bytes, owner, root_objectid);
+	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0) {
+		bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
+		add_pinned_bytes(fs_info, -num_bytes, metadata, root_objectid);
+	}
 
 	return ret;
 }
@@ -7231,7 +7233,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	}
 out:
 	if (pin)
-		add_pinned_bytes(fs_info, buf->len, btrfs_header_level(buf),
+		add_pinned_bytes(fs_info, buf->len, true,
 				 root->root_key.objectid);
 
 	if (last_ref) {
@@ -7285,8 +7287,10 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 						 &old_ref_mod, &new_ref_mod);
 	}
 
-	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
-		add_pinned_bytes(fs_info, num_bytes, owner, root_objectid);
+	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0) {
+		bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
+		add_pinned_bytes(fs_info, num_bytes, metadata, root_objectid);
+	}
 
 	return ret;
 }
-- 
2.7.4

