From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: change the ordered tree to use a spinlock instead
	of a mutex
Date: Tue, 2 Feb 2010 16:48:28 -0500
Message-ID: <20100202214828.GF15957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The ordered tree used to need a mutex, but currently all we use it for is to
protect the rb_tree, and a spin_lock is just fine for that.  Using a spin_lock
instead makes dbench run a little faster, 58 mb/s instead of 51 mb/s, and have
less latency, 3445.138 ms instead of 3820.633 ms.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ordered-data.c |   32 ++++++++++++++++----------------
 fs/btrfs/ordered-data.h |    4 ++--
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c44054b..724d73f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -174,7 +174,6 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	if (!entry)
 		return -ENOMEM;
 
-	mutex_lock(&tree->mutex);
 	entry->file_offset = file_offset;
 	entry->start = start;
 	entry->len = len;
@@ -190,16 +189,17 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	INIT_LIST_HEAD(&entry->list);
 	INIT_LIST_HEAD(&entry->root_extent_list);
 
+	spin_lock(&tree->lock);
 	node = tree_insert(&tree->tree, file_offset,
 			   &entry->rb_node);
 	BUG_ON(node);
+	spin_unlock(&tree->lock);
 
 	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
 	list_add_tail(&entry->root_extent_list,
 		      &BTRFS_I(inode)->root->fs_info->ordered_extents);
 	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
 
-	mutex_unlock(&tree->mutex);
 	BUG_ON(node);
 	return 0;
 }
@@ -216,9 +216,9 @@ int btrfs_add_ordered_sum(struct inode *inode,
 	struct btrfs_ordered_inode_tree *tree;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	return 0;
 }
 
@@ -241,7 +241,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 	int ret;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node) {
 		ret = 1;
@@ -269,7 +269,7 @@ out:
 		*cached = entry;
 		atomic_inc(&entry->refs);
 	}
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	return ret == 0;
 }
 
@@ -345,9 +345,9 @@ int btrfs_remove_ordered_extent(struct inode *inode,
 	int ret;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	ret = __btrfs_remove_ordered_extent(inode, entry);
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	wake_up(&entry->wait);
 
 	return ret;
@@ -572,7 +572,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node)
 		goto out;
@@ -583,7 +583,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	if (entry)
 		atomic_inc(&entry->refs);
 out:
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	return entry;
 }
 
@@ -599,7 +599,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 	struct btrfs_ordered_extent *entry = NULL;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node)
 		goto out;
@@ -607,7 +607,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 	atomic_inc(&entry->refs);
 out:
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	return entry;
 }
 
@@ -634,7 +634,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	else
 		offset = ALIGN(offset, BTRFS_I(inode)->root->sectorsize);
 
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	disk_i_size = BTRFS_I(inode)->disk_i_size;
 
 	/* truncate file */
@@ -740,7 +740,7 @@ out:
 	 */
 	if (ordered)
 		__btrfs_remove_ordered_extent(inode, ordered);
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	if (ordered)
 		wake_up(&ordered->wait);
 	return ret;
@@ -767,7 +767,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	if (!ordered)
 		return 1;
 
-	mutex_lock(&tree->mutex);
+	spin_lock(&tree->lock);
 	list_for_each_entry_reverse(ordered_sum, &ordered->list, list) {
 		if (disk_bytenr >= ordered_sum->bytenr) {
 			num_sectors = ordered_sum->len / sectorsize;
@@ -782,7 +782,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 		}
 	}
 out:
-	mutex_unlock(&tree->mutex);
+	spin_unlock(&tree->lock);
 	btrfs_put_ordered_extent(ordered);
 	return ret;
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 398bfc6..d7f359a 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -21,7 +21,7 @@
 
 /* one of these per inode */
 struct btrfs_ordered_inode_tree {
-	struct mutex mutex;
+	spinlock_t lock;
 	struct rb_root tree;
 	struct rb_node *last;
 };
@@ -128,7 +128,7 @@ static inline int btrfs_ordered_sum_size(struct btrfs_root *root,
 static inline void
 btrfs_ordered_inode_tree_init(struct btrfs_ordered_inode_tree *t)
 {
-	mutex_init(&t->mutex);
+	spin_lock_init(&t->lock);
 	t->tree.rb_node = NULL;
 	t->last = NULL;
 }
-- 
1.6.6

