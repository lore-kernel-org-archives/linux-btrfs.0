Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55413 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225AbbG1Ic7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 04:32:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S8V5LY019646
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 16:31:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 04/14] btrfs: dedup: Add internal add/remove/search function for btrfs dedup.
Date: Tue, 28 Jul 2015 16:30:40 +0800
Message-ID: <1438072250-2871-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic internal add/remove/search functions for btrfs_dedup.
They are all internal use only as caller shouldn't call this low level
functions

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 167 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 41f70f5..2bce303 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -78,11 +78,176 @@ fail:
 	return ret;
 }
 
+static void __dedup_del_hash(struct btrfs_dedup_root *root,
+			     struct btrfs_dedup_hash *hash)
+{
+	list_del(&hash->lru_list);
+	rb_erase(&hash->hash_node, &root->hash_root);
+	rb_erase(&hash->bytenr_node, &root->bytenr_root);
+
+	WARN_ON(root->current_nr == 0);
+	root->current_nr--;
+}
+
 void btrfs_free_dedup(struct btrfs_fs_info *fs_info)
 {
-	if (!fs_info->dedup_root)
+	struct btrfs_dedup_hash *entry, *tmp;
+	struct btrfs_dedup_root *dedup_root = fs_info->dedup_root;
+
+	if (!dedup_root)
 		return;
 
-	kfree(fs_info->dedup_root);
+	spin_lock(&dedup_root->lock);
+	list_for_each_entry_safe(entry, tmp, &dedup_root->lru_list, lru_list) {
+		__dedup_del_hash(dedup_root, entry);
+		kmem_cache_free(btrfs_dedup_hash_cachep, entry);
+	}
+	spin_unlock(&dedup_root->lock);
+	kfree(dedup_root);
 	return;
 }
+
+static int __hash_page(struct btrfs_dedup_root *root, struct page *page,
+		       char *out)
+{
+	struct crypto_shash *tfm = root->dedup_driver;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tfm)];
+	} sdesc;
+	char *kaddr;
+	int ret = 0;
+
+	sdesc.desc.tfm = tfm;
+	sdesc.desc.flags = 0;
+
+	kaddr = kmap_atomic(page);
+	ret = crypto_shash_digest(&sdesc.desc, kaddr, PAGE_SIZE,
+				  out);
+	kunmap_atomic(kaddr);
+
+	return ret;
+}
+
+/*
+ * Return 1 when the extent already exists
+ * Return 0 when inserted the one into bytenr tree.
+ */
+static int insert_bytenr(struct rb_root *root, struct btrfs_dedup_hash *hash)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_dedup_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_dedup_hash,
+				 bytenr_node);
+		if (hash->bytenr + hash->offset < entry->bytenr + entry->offset)
+			p = &(*p)->rb_left;
+		else if (hash->bytenr + hash->offset > entry->bytenr +
+			 entry->offset)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	rb_link_node(&hash->bytenr_node, parent, p);
+	rb_insert_color(&hash->bytenr_node, root);
+	return 0;
+}
+
+/*
+ * Must ensure insert_bytenr is called before, ensure this dedup_hash
+ * is not already in the tree
+ */
+static int insert_hash(struct rb_root *root, struct btrfs_dedup_hash *hash,
+			int hash_len)
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
+		/* Now hash matches, still allow it to be inserted */
+		else if (hash->bytenr + hash->offset < entry->bytenr +
+			 entry->offset)
+			p = &(*p)->rb_left;
+		else if (hash->bytenr + hash->offset > entry->bytenr +
+			 entry->offset)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	rb_link_node(&hash->hash_node, parent, p);
+	rb_insert_color(&hash->hash_node, root);
+	return 0;
+}
+
+static int dedup_add_hash(struct btrfs_dedup_root *root,
+			  struct btrfs_dedup_hash *hash)
+{
+	int ret = 0;
+
+	WARN_ON(hash->bytenr == 0);
+
+	spin_lock(&root->lock);
+
+	ret = insert_bytenr(&root->bytenr_root, hash);
+	/* Already in tree */
+	if (ret > 0)
+		goto out;
+	insert_hash(&root->hash_root, hash,
+		    btrfs_dedup_sizes[root->dedup_type]);
+	list_add(&hash->lru_list, &root->lru_list);
+
+	root->current_nr++;
+
+	/* Remove the last dedup hash if we exceed limit */
+	while (root->limit_nr && root->current_nr > root->limit_nr) {
+		struct btrfs_dedup_hash *last;
+
+		last = list_entry(root->lru_list.prev, struct btrfs_dedup_hash,
+				  lru_list);
+		__dedup_del_hash(root, last);
+		kmem_cache_free(btrfs_dedup_hash_cachep, last);
+	}
+out:
+	spin_unlock(&root->lock);
+	return ret;
+}
+
+/*
+ * Caller must hold lock on dedup_root->lock during the use of the hash.
+ * As the dedup_hash hash can be freed at anytime.
+ */
+static struct btrfs_dedup_hash *
+dedup_search_by_hash(struct btrfs_dedup_root *root, u8 *hash)
+{
+	struct rb_node **p = &root->hash_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_dedup_hash *entry = NULL;
+	int hash_len = btrfs_dedup_sizes[root->dedup_type];
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_dedup_hash, hash_node);
+		if (memcmp(hash, entry->hash, hash_len) < 0)
+			p = &(*p)->rb_left;
+		else if (memcmp(hash, entry->hash, hash_len) > 0)
+			p = &(*p)->rb_right;
+		else {
+			/* Found, need to re-add it to LRU list head */
+			list_del(&entry->lru_list);
+			list_add(&entry->lru_list, &root->lru_list);
+			return entry;
+		}
+	}
+	return NULL;
+}
-- 
2.4.6

