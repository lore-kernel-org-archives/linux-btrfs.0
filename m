Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2559 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932182AbcFOCKO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 22:10:14 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v11 03/13] btrfs: dedupe: Introduce function to add hash into in-memory tree
Date: Wed, 15 Jun 2016 10:09:51 +0800
Message-Id: <20160615021001.9588-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_add() to add hash into in-memory tree.
And now we can implement the btrfs_dedupe_add() interface.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/dedupe.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 941ee37..be83aca 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -32,6 +32,14 @@ struct inmem_hash {
 	u8 hash[];
 };
 
+static inline struct inmem_hash *inmem_alloc_hash(u16 type)
+{
+	if (WARN_ON(type >= ARRAY_SIZE(btrfs_dedupe_sizes)))
+		return NULL;
+	return kzalloc(sizeof(struct inmem_hash) + btrfs_dedupe_sizes[type],
+			GFP_NOFS);
+}
+
 static int init_dedupe_info(struct btrfs_dedupe_info **ret_info, u16 type,
 			    u16 backend, u64 blocksize, u64 limit)
 {
@@ -158,3 +166,146 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	/* Place holder for bisect, will be implemented in later patches */
 	return 0;
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
+static void __inmem_del(struct btrfs_dedupe_info *dedupe_info,
+			struct inmem_hash *hash)
+{
+	list_del(&hash->lru_list);
+	rb_erase(&hash->hash_node, &dedupe_info->hash_root);
+	rb_erase(&hash->bytenr_node, &dedupe_info->bytenr_root);
+
+	if (!WARN_ON(dedupe_info->current_nr == 0))
+		dedupe_info->current_nr--;
+
+	kfree(hash);
+}
+
+/*
+ * Insert a hash into in-memory dedupe tree
+ * Will remove exceeding last recent use hash.
+ *
+ * If the hash mathced with existing one, we won't insert it, to
+ * save memory
+ */
+static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
+		     struct btrfs_dedupe_hash *hash)
+{
+	int ret = 0;
+	u16 type = dedupe_info->hash_type;
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
+	memcpy(ihash->hash, hash->hash, btrfs_dedupe_sizes[type]);
+
+	mutex_lock(&dedupe_info->lock);
+
+	ret = inmem_insert_bytenr(&dedupe_info->bytenr_root, ihash);
+	if (ret > 0) {
+		kfree(ihash);
+		ret = 0;
+		goto out;
+	}
+
+	ret = inmem_insert_hash(&dedupe_info->hash_root, ihash,
+				btrfs_dedupe_sizes[type]);
+	if (ret > 0) {
+		/*
+		 * We only keep one hash in tree to save memory, so if
+		 * hash conflicts, free the one to insert.
+		 */
+		rb_erase(&ihash->bytenr_node, &dedupe_info->bytenr_root);
+		kfree(ihash);
+		ret = 0;
+		goto out;
+	}
+
+	list_add(&ihash->lru_list, &dedupe_info->lru_list);
+	dedupe_info->current_nr++;
+
+	/* Remove the last dedupe hash if we exceed limit */
+	while (dedupe_info->current_nr > dedupe_info->limit_nr) {
+		struct inmem_hash *last;
+
+		last = list_entry(dedupe_info->lru_list.prev,
+				  struct inmem_hash, lru_list);
+		__inmem_del(dedupe_info, last);
+	}
+out:
+	mutex_unlock(&dedupe_info->lock);
+	return 0;
+}
+
+int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
+		     struct btrfs_fs_info *fs_info,
+		     struct btrfs_dedupe_hash *hash)
+{
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+
+	if (!fs_info->dedupe_enabled || !hash)
+		return 0;
+
+	if (WARN_ON(dedupe_info == NULL))
+		return -EINVAL;
+
+	if (WARN_ON(!btrfs_dedupe_hash_hit(hash)))
+		return -EINVAL;
+
+	/* ignore old hash */
+	if (dedupe_info->blocksize != hash->num_bytes)
+		return 0;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		return inmem_add(dedupe_info, hash);
+	return -EINVAL;
+}
-- 
2.8.3



