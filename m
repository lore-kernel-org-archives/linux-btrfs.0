Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2I2IH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 04:07:56 -0400
Received: by pbbrr4 with SMTP id rr4so6051662pbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 01:07:56 -0700 (PDT)
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 1/2] btrfs: remove unused function btrfs_insert_some_items()
Date: Sat, 29 Sep 2012 16:07:46 +0800
Message-Id: <1348906067-9348-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The function btrfs_insert_some_items() would not be called by any other functions,
so remove it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/btrfs/ctree.c |  143 ------------------------------------------------------
 1 files changed, 0 insertions(+), 143 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d183f6..3878c0a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4402,149 +4402,6 @@ void btrfs_extend_item(struct btrfs_trans_handle *trans,
 }
 
 /*
- * Given a key and some data, insert items into the tree.
- * This does all the path init required, making room in the tree if needed.
- * Returns the number of keys that were inserted.
- */
-int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    struct btrfs_path *path,
-			    struct btrfs_key *cpu_key, u32 *data_size,
-			    int nr)
-{
-	struct extent_buffer *leaf;
-	struct btrfs_item *item;
-	int ret = 0;
-	int slot;
-	int i;
-	u32 nritems;
-	u32 total_data = 0;
-	u32 total_size = 0;
-	unsigned int data_end;
-	struct btrfs_disk_key disk_key;
-	struct btrfs_key found_key;
-	struct btrfs_map_token token;
-
-	btrfs_init_map_token(&token);
-
-	for (i = 0; i < nr; i++) {
-		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
-		    BTRFS_LEAF_DATA_SIZE(root)) {
-			break;
-			nr = i;
-		}
-		total_data += data_size[i];
-		total_size += data_size[i] + sizeof(struct btrfs_item);
-	}
-	BUG_ON(nr == 0);
-
-	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
-	if (ret == 0)
-		return -EEXIST;
-	if (ret < 0)
-		goto out;
-
-	leaf = path->nodes[0];
-
-	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(root, leaf);
-
-	if (btrfs_leaf_free_space(root, leaf) < total_size) {
-		for (i = nr; i >= 0; i--) {
-			total_data -= data_size[i];
-			total_size -= data_size[i] + sizeof(struct btrfs_item);
-			if (total_size < btrfs_leaf_free_space(root, leaf))
-				break;
-		}
-		nr = i;
-	}
-
-	slot = path->slots[0];
-	BUG_ON(slot < 0);
-
-	if (slot != nritems) {
-		unsigned int old_data = btrfs_item_end_nr(leaf, slot);
-
-		item = btrfs_item_nr(leaf, slot);
-		btrfs_item_key_to_cpu(leaf, &found_key, slot);
-
-		/* figure out how many keys we can insert in here */
-		total_data = data_size[0];
-		for (i = 1; i < nr; i++) {
-			if (btrfs_comp_cpu_keys(&found_key, cpu_key + i) <= 0)
-				break;
-			total_data += data_size[i];
-		}
-		nr = i;
-
-		if (old_data < data_end) {
-			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d old_data %d data_end %d\n",
-			       slot, old_data, data_end);
-			BUG_ON(1);
-		}
-		/*
-		 * item0..itemN ... dataN.offset..dataN.size .. data0.size
-		 */
-		/* first correct the data pointers */
-		for (i = slot; i < nritems; i++) {
-			u32 ioff;
-
-			item = btrfs_item_nr(leaf, i);
-			ioff = btrfs_token_item_offset(leaf, item, &token);
-			btrfs_set_token_item_offset(leaf, item,
-						    ioff - total_data, &token);
-		}
-		/* shift the items */
-		memmove_extent_buffer(leaf, btrfs_item_nr_offset(slot + nr),
-			      btrfs_item_nr_offset(slot),
-			      (nritems - slot) * sizeof(struct btrfs_item));
-
-		/* shift the data */
-		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
-			      data_end - total_data, btrfs_leaf_data(leaf) +
-			      data_end, old_data - data_end);
-		data_end = old_data;
-	} else {
-		/*
-		 * this sucks but it has to be done, if we are inserting at
-		 * the end of the leaf only insert 1 of the items, since we
-		 * have no way of knowing whats on the next leaf and we'd have
-		 * to drop our current locks to figure it out
-		 */
-		nr = 1;
-	}
-
-	/* setup the item for the new data */
-	for (i = 0; i < nr; i++) {
-		btrfs_cpu_key_to_disk(&disk_key, cpu_key + i);
-		btrfs_set_item_key(leaf, &disk_key, slot + i);
-		item = btrfs_item_nr(leaf, slot + i);
-		btrfs_set_token_item_offset(leaf, item,
-					    data_end - data_size[i], &token);
-		data_end -= data_size[i];
-		btrfs_set_token_item_size(leaf, item, data_size[i], &token);
-	}
-	btrfs_set_header_nritems(leaf, nritems + nr);
-	btrfs_mark_buffer_dirty(leaf);
-
-	ret = 0;
-	if (slot == 0) {
-		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		fixup_low_keys(trans, root, path, &disk_key, 1);
-	}
-
-	if (btrfs_leaf_free_space(root, leaf) < 0) {
-		btrfs_print_leaf(root, leaf);
-		BUG();
-	}
-out:
-	if (!ret)
-		ret = nr;
-	return ret;
-}
-
-/*
  * this is a helper for btrfs_insert_empty_items, the main goal here is
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
-- 
1.7.3.2

