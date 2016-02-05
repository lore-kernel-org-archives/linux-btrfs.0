Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbcBEBZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:25:00 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 03/19] btrfs: dedup: Introduce function to add hash into in-memory tree
Date: Fri,  5 Feb 2016 09:22:23 +0800
Message-Id: <1454635359-10013-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_add() to add hash into in-memory tree.
And now we can implement the btrfs_dedup_add() interface.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 162 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 2abe178..5fa15ae 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -21,6 +21,25 @@
 #include "transaction.h"
 #include "delayed-ref.h"
 
+struct inmem_hash {
+	struct rb_node hash_node;
+	struct rb_node bytenr_node;
+	struct list_head lru_list;
+
+	u64 bytenr;
+	u32 num_bytes;
+
+	u8 hash[];
+};
+
+static inline struct inmem_hash *inmem_alloc_hash(u16 type)
+{
+	if (WARN_ON(type >= ARRAY_SIZE(btrfs_dedup_sizes)))
+		return NULL;
+	return kzalloc(sizeof(struct inmem_hash) + btrfs_dedup_sizes[type],
+			GFP_NOFS);
+}
+
 int btrfs_dedup_enable(struct btrfs_fs_info *fs_info, u16 type, u16 backend,
 		       u64 blocksize, u64 limit_nr)
 {
@@ -95,3 +114,146 @@ out:
 		kfree(dedup_info);
 	return ret;
 }
+
+static int inmem_insert_hash(struct rb_root *root,
+			     struct inmem_hash *hash, int hash_len)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, hash_node);
+		if (memcmp(hash->hash, entry->hash, hash_len) < 0)
+			p = &(*p)->rb_left;
+		else if (memcmp(hash->hash, entry->hash, hash_len) > 0)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	rb_link_node(&hash->hash_node, parent, p);
+	rb_insert_color(&hash->hash_node, root);
+	return 0;
+}
+
+static int inmem_insert_bytenr(struct rb_root *root,
+			       struct inmem_hash *hash)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
+		if (hash->bytenr < entry->bytenr)
+			p = &(*p)->rb_left;
+		else if (hash->bytenr > entry->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	rb_link_node(&hash->bytenr_node, parent, p);
+	rb_insert_color(&hash->bytenr_node, root);
+	return 0;
+}
+
+static void __inmem_del(struct btrfs_dedup_info *dedup_info,
+			struct inmem_hash *hash)
+{
+	list_del(&hash->lru_list);
+	rb_erase(&hash->hash_node, &dedup_info->hash_root);
+	rb_erase(&hash->bytenr_node, &dedup_info->bytenr_root);
+
+	if (!WARN_ON(dedup_info->current_nr == 0))
+		dedup_info->current_nr--;
+
+	kfree(hash);
+}
+
+/*
+ * Insert a hash into in-memory dedup tree
+ * Will remove exceeding last recent use hash.
+ *
+ * If the hash mathced with existing one, we won't insert it, to
+ * save memory
+ */
+static int inmem_add(struct btrfs_dedup_info *dedup_info,
+		     struct btrfs_dedup_hash *hash)
+{
+	int ret = 0;
+	u16 type = dedup_info->hash_type;
+	struct inmem_hash *ihash;
+
+	ihash = inmem_alloc_hash(type);
+
+	if (!ihash)
+		return -ENOMEM;
+
+	/* Copy the data out */
+	ihash->bytenr = hash->bytenr;
+	ihash->num_bytes = hash->num_bytes;
+	memcpy(ihash->hash, hash->hash, btrfs_dedup_sizes[type]);
+
+	mutex_lock(&dedup_info->lock);
+
+	ret = inmem_insert_bytenr(&dedup_info->bytenr_root, ihash);
+	if (ret > 0) {
+		kfree(ihash);
+		ret = 0;
+		goto out;
+	}
+
+	ret = inmem_insert_hash(&dedup_info->hash_root, ihash,
+				btrfs_dedup_sizes[type]);
+	if (ret > 0) {
+		/*
+		 * We only keep one hash in tree to save memory, so if
+		 * hash conflicts, free the one to insert.
+		 */
+		rb_erase(&ihash->bytenr_node, &dedup_info->bytenr_root);
+		kfree(ihash);
+		ret = 0;
+		goto out;
+	}
+
+	list_add(&ihash->lru_list, &dedup_info->lru_list);
+	dedup_info->current_nr++;
+
+	/* Remove the last dedup hash if we exceed limit */
+	while (dedup_info->current_nr > dedup_info->limit_nr) {
+		struct inmem_hash *last;
+
+		last = list_entry(dedup_info->lru_list.prev,
+				  struct inmem_hash, lru_list);
+		__inmem_del(dedup_info, last);
+	}
+out:
+	mutex_unlock(&dedup_info->lock);
+	return 0;
+}
+
+int btrfs_dedup_add(struct btrfs_trans_handle *trans,
+		    struct btrfs_fs_info *fs_info,
+		    struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	if (!fs_info->dedup_enabled || !hash)
+		return 0;
+
+	if (WARN_ON(dedup_info == NULL))
+		return -EINVAL;
+
+	if (WARN_ON(hash->bytenr == 0))
+		return -EINVAL;
+
+	/* ignore old hash */
+	if (dedup_info->blocksize != hash->num_bytes)
+		return 0;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		return inmem_add(dedup_info, hash);
+	return -EINVAL;
+}
-- 
2.7.0



