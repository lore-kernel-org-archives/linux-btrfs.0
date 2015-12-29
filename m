Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbbL2ICT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:02:19 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 6B6A4409256C
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:26 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 03/14] btrfs: dedup: Introduce function to add hash into in-memory tree
Date: Tue, 29 Dec 2015 16:01:12 +0800
Message-ID: <1451376083-30474-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_add() to add hash into in-memory tree.
And now we can implement the btrfs_dedup_add() interface.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index c1fadff..cafbce1 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -94,3 +94,119 @@ out:
 	}
 	return ret;
 }
+
+static int inmem_insert_hash(struct rb_root *root,
+			     struct btrfs_dedup_hash *hash, int hash_len)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_dedup_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_dedup_hash,
+				 hash_node);
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
+			       struct btrfs_dedup_hash *hash)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_dedup_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_dedup_hash, bytenr_node);
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
+			struct btrfs_dedup_hash *hash)
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
+			   struct btrfs_dedup_hash *hash)
+{
+	int ret = 0;
+	u16 type = dedup_info->hash_type;
+
+	spin_lock(&dedup_info->lock);
+	ret = inmem_insert_hash(&dedup_info->hash_root, hash,
+				btrfs_dedup_sizes[type]);
+	if (ret > 0) {
+		/* Same hash already in tree, don't insert */
+		kfree(hash);
+		ret = 0;
+		goto out;
+	}
+
+	inmem_insert_bytenr(&dedup_info->bytenr_root, hash);
+
+	list_add(&hash->lru_list, &dedup_info->lru_list);
+	dedup_info->current_nr++;
+
+	/* Remove the last dedup hash if we exceed limit */
+	while (dedup_info->current_nr > dedup_info->limit_nr) {
+		struct btrfs_dedup_hash *last;
+
+		last = list_entry(dedup_info->lru_list.prev,
+				  struct btrfs_dedup_hash, lru_list);
+		__inmem_del(dedup_info, last);
+	}
+out:
+	spin_unlock(&dedup_info->lock);
+	return 0;
+}
+
+int btrfs_dedup_add(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    struct btrfs_dedup_hash *hash)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	if (!dedup_info || !hash)
+		return 0;
+
+	if (WARN_ON(hash->bytenr == 0))
+		return -EINVAL;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		return inmem_add(dedup_info, hash);
+	return -EINVAL;
+}
-- 
2.6.4



