Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753278AbbL2IC2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:02:28 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 9336C41890EB
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:27 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 05/14] btrfs: dedup: Introduce function to search for an existing hash
Date: Tue, 29 Dec 2015 16:01:14 +0800
Message-ID: <1451376083-30474-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 fs/btrfs/dedup.c | 154 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 658c493..4b8676b 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -287,3 +287,157 @@ int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 		inmem_destroy(fs_info);
 	return 0;
 }
+
+/*
+ * Caller must ensure the corresponding ref head is not being run.
+ */
+static struct btrfs_dedup_hash *
+inmem_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash)
+{
+	struct rb_node **p = &dedup_info->hash_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_dedup_hash *entry = NULL;
+	u16 hash_type = dedup_info->hash_type;
+	int hash_len = btrfs_dedup_sizes[hash_type];
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_dedup_hash, hash_node);
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
+static int inmem_search(struct inode *inode, u64 file_pos,
+			struct btrfs_dedup_hash *hash)
+{
+	int ret;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
+	struct btrfs_dedup_hash *found_hash;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+	u64 bytenr, num_bytes;
+
+	spin_lock(&dedup_info->lock);
+	found_hash = inmem_search_hash(dedup_info, hash->hash);
+	/* If we don't find a duplicated extent, just return. */
+	if (!found_hash) {
+		spin_unlock(&dedup_info->lock);
+		return 0;
+	}
+	bytenr = found_hash->bytenr;
+	num_bytes = found_hash->num_bytes;
+	spin_unlock(&dedup_info->lock);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+again:
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(trans, bytenr);
+	if (!head || head->processing == 1) {
+		/*
+		 * Somebody else may be trying to run the refs, the found
+		 * duplicated extent may be freed, so here we just
+		 * choose to abort this dedup handle.
+		 * XXX: we need to find a better method to improve it.
+		 */
+		spin_unlock(&delayed_refs->lock);
+		goto out;
+	}
+
+	/*
+	 * we may have dropped the delayed_refs->lock to get the head mutex
+	 * lock, and that might have given someone else time to free the head.
+	 * If that's true, it has been removed from our list and we can move on.
+	 */
+	ret = btrfs_delayed_ref_lock(trans, head);
+	spin_unlock(&delayed_refs->lock);
+	if (ret == -EAGAIN) {
+		spin_lock(&dedup_info->lock);
+		found_hash = inmem_search_hash(dedup_info, hash->hash);
+		if (!found_hash) {
+			spin_unlock(&dedup_info->lock);
+			goto out;
+		}
+		bytenr = found_hash->bytenr;
+		num_bytes = found_hash->num_bytes;
+		spin_unlock(&dedup_info->lock);
+		goto again;
+	}
+
+	/* We still need to look up the hash again... */
+	spin_lock(&dedup_info->lock);
+	found_hash = inmem_search_hash(dedup_info, hash->hash);
+	if (!found_hash) {
+		spin_unlock(&dedup_info->lock);
+		mutex_unlock(&head->mutex);
+		goto out;
+	}
+
+	/* The bytenr has changed, we need to re-lock the delayed_ref head */
+	if (found_hash->bytenr != bytenr) {
+		bytenr = found_hash->bytenr;
+		num_bytes = found_hash->num_bytes;
+		spin_unlock(&dedup_info->lock);
+		mutex_unlock(&head->mutex);
+		goto again;
+	}
+
+	hash->bytenr = bytenr;
+	hash->num_bytes = num_bytes;
+	spin_unlock(&dedup_info->lock);
+
+	/*
+	 * Increase the extent ref right now, to avoid delayed ref run
+	 * Or we may increase ref on non-exist extent.
+	 */
+	btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+			     root->root_key.objectid,
+			     btrfs_ino(inode), file_pos);
+	mutex_unlock(&head->mutex);
+	btrfs_end_transaction(trans, root);
+
+	return 1;
+
+out:
+	btrfs_end_transaction(trans, root);
+	return 0;
+}
+
+int btrfs_dedup_search(struct inode *inode, u64 file_pos,
+		       struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+	int ret = 0;
+
+	if (WARN_ON(!dedup_info || !hash))
+		return 0;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		ret = inmem_search(inode, file_pos, hash);
+
+	/* It's possible hash->bytenr/num_bytenr already changed */
+	if (ret == 0) {
+		hash->num_bytes = 0;
+		hash->bytenr = 0;
+	}
+	return ret;
+}
-- 
2.6.4



