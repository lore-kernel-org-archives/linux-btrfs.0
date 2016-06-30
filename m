Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbcF3JS4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:18:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH V12 06/14] btrfs: dedupe: Introduce function to search for an existing hash
Date: Thu, 30 Jun 2016 17:18:25 +0800
Message-Id: <20160630091833.26975-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160630091833.26975-1-quwenruo@cn.fujitsu.com>
References: <20160630091833.26975-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_search() to handle the job for in-memory
hash tree.

The trick is, we must ensure the delayed ref head is not being run at
the time we search the for the hash.

With inmem_search(), we can implement the btrfs_dedupe_search()
interface.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/dedupe.c | 185 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 14c57fa..eb1b110 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -20,6 +20,7 @@
 #include "btrfs_inode.h"
 #include "transaction.h"
 #include "delayed-ref.h"
+#include "qgroup.h"
 
 struct inmem_hash {
 	struct rb_node hash_node;
@@ -454,3 +455,187 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	kfree(dedupe_info);
 	return 0;
 }
+
+/*
+ * Caller must ensure the corresponding ref head is not being run.
+ */
+static struct inmem_hash *
+inmem_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash)
+{
+	struct rb_node **p = &dedupe_info->hash_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+	u16 hash_algo = dedupe_info->hash_algo;
+	int hash_len = btrfs_hash_sizes[hash_algo];
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
+			list_add(&entry->lru_list, &dedupe_info->lru_list);
+			return entry;
+		}
+	}
+	return NULL;
+}
+
+static int inmem_search(struct btrfs_dedupe_info *dedupe_info,
+			struct inode *inode, u64 file_pos,
+			struct btrfs_dedupe_hash *hash)
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
+	mutex_lock(&dedupe_info->lock);
+	found_hash = inmem_search_hash(dedupe_info, hash->hash);
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
+	 * We can't lock ref head with dedupe_info->lock hold or we will cause
+	 * ABBA dead lock.
+	 */
+	mutex_unlock(&dedupe_info->lock);
+	ret = btrfs_delayed_ref_lock(trans, head);
+	spin_unlock(&delayed_refs->lock);
+	if (ret == -EAGAIN)
+		goto again;
+
+	mutex_lock(&dedupe_info->lock);
+	/* Search again to ensure the hash is still here */
+	found_hash = inmem_search_hash(dedupe_info, hash->hash);
+	if (!found_hash) {
+		ret = 0;
+		mutex_unlock(&head->mutex);
+		goto out;
+	}
+	ret = 1;
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
+	mutex_unlock(&dedupe_info->lock);
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
+int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
+			struct inode *inode, u64 file_pos,
+			struct btrfs_dedupe_hash *hash)
+{
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	int ret = -EINVAL;
+
+	if (!hash)
+		return 0;
+
+	/*
+	 * This function doesn't follow fs_info->dedupe_enabled as it will need
+	 * to ensure any hashed extent to go through dedupe routine
+	 */
+	if (WARN_ON(dedupe_info == NULL))
+		return -EINVAL;
+
+	if (WARN_ON(btrfs_dedupe_hash_hit(hash)))
+		return -EINVAL;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		ret = inmem_search(dedupe_info, inode, file_pos, hash);
+
+	/* It's possible hash->bytenr/num_bytenr already changed */
+	if (ret == 0) {
+		hash->num_bytes = 0;
+		hash->bytenr = 0;
+	}
+	return ret;
+}
-- 
2.9.0



