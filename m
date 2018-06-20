Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753970AbeFTMtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:22 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB2C4AF62
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/34] btrfs: Remove fs_info from fixup_low_keys
Date: Wed, 20 Jun 2018 15:48:47 +0300
Message-Id: <1529498956-4241-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This argument is unused. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4bc326df472e..18fd80e2f278 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3128,8 +3128,7 @@ int btrfs_search_slot_for_read(struct btrfs_root *root,
  * higher levels
  *
  */
-static void fixup_low_keys(struct btrfs_fs_info *fs_info,
-			   struct btrfs_path *path,
+static void fixup_low_keys(struct btrfs_path *path,
 			   struct btrfs_disk_key *key, int level)
 {
 	int i;
@@ -3181,7 +3180,7 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
-		fixup_low_keys(fs_info, path, &disk_key, 1);
+		fixup_low_keys(path, &disk_key, 1);
 }
 
 /*
@@ -3945,7 +3944,7 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 		clean_tree_block(fs_info, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	fixup_low_keys(fs_info, path, &disk_key, 1);
+	fixup_low_keys(path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -4320,7 +4319,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 			path->nodes[0] = right;
 			path->slots[0] = 0;
 			if (path->slots[1] == 0)
-				fixup_low_keys(fs_info, path, &disk_key, 1);
+				fixup_low_keys(path, &disk_key, 1);
 		}
 		/*
 		 * We create a new leaf 'right' for the required ins_len and
@@ -4642,7 +4641,7 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
-			fixup_low_keys(fs_info, path, &disk_key, 1);
+			fixup_low_keys(path, &disk_key, 1);
 	}
 
 	item = btrfs_item_nr(slot);
@@ -4744,7 +4743,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 	if (path->slots[0] == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		fixup_low_keys(fs_info, path, &disk_key, 1);
+		fixup_low_keys(path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 
@@ -4886,7 +4885,6 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		    int level, int slot)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
 	int ret;
@@ -4919,7 +4917,7 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		fixup_low_keys(fs_info, path, &disk_key, level + 1);
+		fixup_low_keys(path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 }
@@ -5022,7 +5020,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			fixup_low_keys(fs_info, path, &disk_key, 1);
+			fixup_low_keys(path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */
-- 
2.7.4

