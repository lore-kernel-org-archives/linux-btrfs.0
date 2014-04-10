Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32200 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152AbaDJDte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:49:34 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 03/16] Btrfs: introduce dedup tree operations
Date: Thu, 10 Apr 2014 11:48:33 +0800
Message-Id: <1397101727-20806-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The operations consist of finding matched items, adding new items and
removing items.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h     |   9 +++
 fs/btrfs/file-item.c | 210 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 219 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index da4320d..ca1b516 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3760,6 +3760,15 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
 
+int noinline_for_stack
+btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash);
+int noinline_for_stack
+btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_dedup_hash *hash);
+int noinline_for_stack
+btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 hash, u64 bytenr);
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 127555b..6437ebe 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -885,3 +885,213 @@ out:
 fail_unlock:
 	goto out;
 }
+
+/* 1 means we find one, 0 means we dont. */
+int noinline_for_stack
+btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *dedup_root;
+	struct btrfs_dedup_item *item;
+	u64 hash_value;
+	u64 length;
+	u64 dedup_size;
+	int compression;
+	int found = 0;
+	int index;
+	int ret;
+
+	if (!hash) {
+		WARN_ON(1);
+		return 0;
+	}
+	if (!root->fs_info->dedup_root) {
+		WARN(1, KERN_INFO "dedup not enabled\n");
+		return 0;
+	}
+	dedup_root = root->fs_info->dedup_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return 0;
+
+	/*
+	 * For SHA256 dedup algorithm, we store the last 64bit as the
+	 * key.objectid, and the rest in the tree item.
+	 */
+	index = btrfs_dedup_lens[hash->type] - 1;
+	dedup_size = btrfs_dedup_sizes[hash->type] - sizeof(u64);
+
+	hash_value = hash->hash[index];
+
+	key.objectid = hash_value;
+	key.offset = (u64)-1;
+	btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
+
+	ret = btrfs_search_slot(NULL, dedup_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret == 0) {
+		WARN_ON(1);
+		goto out;
+	}
+
+prev_slot:
+	/* this will do match checks. */
+	ret = btrfs_previous_item(dedup_root, path, hash_value,
+				  BTRFS_DEDUP_ITEM_KEY);
+	if (ret)
+		goto out;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	if (key.objectid != hash_value)
+		goto out;
+
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dedup_item);
+	/* disk length of dedup range */
+	length = btrfs_dedup_len(leaf, item);
+
+	compression = btrfs_dedup_compression(leaf, item);
+	if (compression > BTRFS_COMPRESS_TYPES) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	if (btrfs_dedup_type(leaf, item) != hash->type)
+		goto prev_slot;
+
+	if (memcmp_extent_buffer(leaf, hash->hash, (unsigned long)(item + 1),
+				 dedup_size)) {
+		pr_info("goto prev\n");
+		goto prev_slot;
+	}
+
+	hash->bytenr = key.offset;
+	hash->num_bytes = length;
+	hash->compression = compression;
+	found = 1;
+out:
+	btrfs_free_path(path);
+	return found;
+}
+
+int noinline_for_stack
+btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
+			  struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *dedup_root;
+	struct btrfs_dedup_item *dedup_item;
+	u64 ins_size;
+	u64 dedup_size;
+	int index;
+	int ret;
+
+	if (!hash) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	WARN_ON(hash->num_bytes > root->fs_info->dedup_bs);
+
+	if (!root->fs_info->dedup_root) {
+		WARN(1, KERN_INFO "dedup not enabled\n");
+		return 0;
+	}
+	dedup_root = root->fs_info->dedup_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/*
+	 * For SHA256 dedup algorithm, we store the last 64bit as the
+	 * key.objectid, and the rest in the tree item.
+	 */
+	index = btrfs_dedup_lens[hash->type] - 1;
+	dedup_size = btrfs_dedup_sizes[hash->type] - sizeof(u64);
+
+	ins_size = sizeof(*dedup_item) + dedup_size;
+
+	key.objectid = hash->hash[index];
+	key.offset = hash->bytenr;
+	btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
+
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(trans, dedup_root, path, &key, ins_size);
+	if (ret < 0)
+		goto out;
+	leaf = path->nodes[0];
+
+	dedup_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_dedup_item);
+	/* disk length of dedup range */
+	btrfs_set_dedup_len(leaf, dedup_item, hash->num_bytes);
+	btrfs_set_dedup_compression(leaf, dedup_item, hash->compression);
+	btrfs_set_dedup_encryption(leaf, dedup_item, 0);
+	btrfs_set_dedup_other_encoding(leaf, dedup_item, 0);
+	btrfs_set_dedup_type(leaf, dedup_item, hash->type);
+
+	write_extent_buffer(leaf, hash->hash, (unsigned long)(dedup_item + 1),
+			    dedup_size);
+
+	btrfs_mark_buffer_dirty(leaf);
+out:
+	WARN_ON(ret == -EEXIST);
+	btrfs_free_path(path);
+	return ret;
+}
+
+int noinline_for_stack
+btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 hash, u64 bytenr)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *dedup_root;
+	int ret = 0;
+
+	if (!root->fs_info->dedup_root)
+		return 0;
+
+	dedup_root = root->fs_info->dedup_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return ret;
+
+	key.objectid = hash;
+	key.offset = bytenr;
+	btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
+
+	ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		WARN_ON(1);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+
+	ret = -ENOENT;
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	if (btrfs_key_type(&key) != BTRFS_DEDUP_ITEM_KEY)
+		goto out;
+	if (key.objectid != hash || key.offset != bytenr)
+		goto out;
+
+	ret = btrfs_del_item(trans, dedup_root, path);
+	WARN_ON(ret);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
1.8.1.4

