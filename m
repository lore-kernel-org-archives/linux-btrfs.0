Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5354 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbcBBDIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:08:04 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 06/19] btrfs: dedup: Introduce function to search for an existing hash
Date: Tue,  2 Feb 2016 11:05:38 +0800
Message-Id: <1454382351-31775-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_search() to handle the job for in-memory
hash tree.

The trick is, we must ensure the delayed ref head is not being run at
the time we search the for the hash.

With inmem_search(), we can implement the btrfs_dedup_search()
interface.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 172 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index be93cf3..20749ce 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -344,3 +344,175 @@ int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 	kfree(dedup_info);
 	return 0;
 }
+
+/*
+ * Caller must ensure the corresponding ref head is not being run.
+ */
+static struct inmem_hash *
+inmem_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash)
+{
+	struct rb_node **p = &dedup_info->hash_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+	u16 hash_type = dedup_info->hash_type;
+	int hash_len = btrfs_dedup_sizes[hash_type];
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, hash_node);
+
+		if (memcmp(hash, entry->hash, hash_len) < 0) {
+			p = &(*p)->rb_left;
+		} else if (memcmp(hash, entry->hash, hash_len) > 0) {
+			p = &(*p)->rb_right;
+		} else {
+			/* Found, need to re-add it to LRU list head */
+			list_del(&entry->lru_list);
+			list_add(&entry->lru_list, &dedup_info->lru_list);
+			return entry;
+		}
+	}
+	return NULL;
+}
+
+static int inmem_search(struct btrfs_dedup_info *dedup_info,
+			struct inode *inode, u64 file_pos,
+			struct btrfs_dedup_hash *hash)
+{
+	int ret;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
+	struct btrfs_delayed_ref_head *insert_head;
+	struct btrfs_delayed_data_ref *insert_dref;
+	struct btrfs_qgroup_extent_record *insert_qrecord = NULL;
+	struct inmem_hash *found_hash;
+	int free_insert = 1;
+	u64 bytenr;
+	u32 num_bytes;
+
+	insert_head = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
+	if (!insert_head)
+		return -ENOMEM;
+	insert_head->extent_op = NULL;
+	insert_dref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
+	if (!insert_dref) {
+		kmem_cache_free(btrfs_delayed_ref_head_cachep, insert_head);
+		return -ENOMEM;
+	}
+	if (root->fs_info->quota_enabled &&
+	    is_fstree(root->root_key.objectid)) {
+		insert_qrecord = kmalloc(sizeof(*insert_qrecord), GFP_NOFS);
+		if (!insert_qrecord) {
+			kmem_cache_free(btrfs_delayed_ref_head_cachep,
+					insert_head);
+			kmem_cache_free(btrfs_delayed_data_ref_cachep,
+					insert_dref);
+			return -ENOMEM;
+		}
+	}
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto free_mem;
+	}
+
+again:
+	mutex_lock(&dedup_info->lock);
+	found_hash = inmem_search_hash(dedup_info, hash->hash);
+	/* If we don't find a duplicated extent, just return. */
+	if (!found_hash) {
+		ret = 0;
+		goto out;
+	}
+	bytenr = found_hash->bytenr;
+	num_bytes = found_hash->num_bytes;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(trans, bytenr);
+	if (!head) {
+		/*
+		 * We can safely insert a new delayed_ref as long as we
+		 * hold delayed_refs->lock.
+		 * Only need to use atomic inc_extent_ref()
+		 */
+		btrfs_add_delayed_data_ref_locked(root->fs_info, trans,
+				insert_dref, insert_head, insert_qrecord,
+				bytenr, num_bytes, 0, root->root_key.objectid,
+				btrfs_ino(inode), file_pos, 0,
+				BTRFS_ADD_DELAYED_REF);
+		spin_unlock(&delayed_refs->lock);
+
+		/* add_delayed_data_ref_locked will free unused memory */
+		free_insert = 0;
+		hash->bytenr = bytenr;
+		hash->num_bytes = num_bytes;
+		ret = 1;
+		goto out;
+	}
+
+	/*
+	 * We can't lock ref head with dedup_info->lock hold or we will cause
+	 * ABBA dead lock.
+	 */
+	mutex_unlock(&dedup_info->lock);
+	ret = btrfs_delayed_ref_lock(trans, head);
+	spin_unlock(&delayed_refs->lock);
+	if (ret == -EAGAIN)
+		goto again;
+
+	mutex_lock(&dedup_info->lock);
+	/* Search again to ensure the hash is still here */
+	found_hash = inmem_search_hash(dedup_info, hash->hash);
+	if (!found_hash) {
+		ret = 0;
+		mutex_unlock(&head->mutex);
+		goto out;
+	}
+	hash->bytenr = bytenr;
+	hash->num_bytes = num_bytes;
+
+	/*
+	 * Increase the extent ref right now, to avoid delayed ref run
+	 * Or we may increase ref on non-exist extent.
+	 */
+	btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+			     root->root_key.objectid,
+			     btrfs_ino(inode), file_pos);
+	mutex_unlock(&head->mutex);
+out:
+	mutex_unlock(&dedup_info->lock);
+	btrfs_end_transaction(trans, root);
+
+free_mem:
+	if (free_insert) {
+		kmem_cache_free(btrfs_delayed_ref_head_cachep, insert_head);
+		kmem_cache_free(btrfs_delayed_data_ref_cachep, insert_dref);
+		kfree(insert_qrecord);
+	}
+	return ret;
+}
+
+int btrfs_dedup_search(struct btrfs_dedup_info *dedup_info,
+		       struct inode *inode, u64 file_pos,
+		       struct btrfs_dedup_hash *hash)
+{
+	int ret = -EINVAL;
+
+	if (WARN_ON(!dedup_info || !hash))
+		return 0;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		ret = inmem_search(dedup_info, inode, file_pos, hash);
+
+	/* It's possible hash->bytenr/num_bytenr already changed */
+	if (ret == 0) {
+		hash->num_bytes = 0;
+		hash->bytenr = 0;
+	}
+	return ret;
+}
-- 
2.7.0



