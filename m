From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/3] Btrfs: create special free space cache inode FORMAT CHANGE
Date: Wed, 15 Sep 2010 15:08:52 -0400
Message-ID: <1284577734-3161-2-git-send-email-josef@redhat.com>
References: <1284577734-3161-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1284577734-3161-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

In order to save free space cache, we need an inode to hold the data, and we
need a special item to point at the right inode for the right block group.  So
first, create a special item that will point to the right inode, and the number
of extent entries we will have and the number of bitmaps we will have.  We
truncate and pre-allocate space everytime to make sure it's uptodate.

This is a disk format change, HOWEVER, you need to mount with -o space_cache in
order to get it, otherwise this feature won't be enabled.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |   69 +++++++++++++-
 fs/btrfs/disk-io.c          |    3 +-
 fs/btrfs/extent-tree.c      |  220 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/free-space-cache.c |  155 ++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |   11 ++
 fs/btrfs/inode.c            |   92 +++++++++++++++---
 fs/btrfs/relocation.c       |   91 +++++++++++++++++-
 fs/btrfs/super.c            |   11 ++-
 fs/btrfs/transaction.c      |   41 ++++++--
 fs/btrfs/transaction.h      |    4 +
 10 files changed, 653 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e9bf864..610710c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -99,6 +99,9 @@ struct btrfs_ordered_sum;
  */
 #define BTRFS_EXTENT_CSUM_OBJECTID -10ULL
 
+/* For storing free space cache */
+#define BTRFS_FREE_SPACE_OBJECTID -11ULL
+
 /* dummy objectid represents multiple objectids */
 #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
 
@@ -265,6 +268,22 @@ struct btrfs_chunk {
 	/* additional stripes go here */
 } __attribute__ ((__packed__));
 
+#define BTRFS_FREE_SPACE_EXTENT	1
+#define BTRFS_FREE_SPACE_BITMAP	2
+
+struct btrfs_free_space_entry {
+	__le64 offset;
+	__le64 bytes;
+	u8 type;
+} __attribute__ ((__packed__));
+
+struct btrfs_free_space_header {
+	struct btrfs_disk_key location;
+	__le64 generation;
+	__le64 num_entries;
+	__le64 num_bitmaps;
+} __attribute__ ((__packed__));
+
 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 {
 	BUG_ON(num_stripes == 0);
@@ -376,12 +395,14 @@ struct btrfs_super_block {
  */
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(2ULL << 0)
+#define BTRFS_FEATURE_INCOMPAT_SPACE_CACHE	(3ULL << 0)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
-#define BTRFS_FEATURE_INCOMPAT_SUPP		\
-	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |	\
-	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)
+#define BTRFS_FEATURE_INCOMPAT_SUPP			\
+	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
+	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
+	 BTRFS_FEATURE_INCOMPAT_SPACE_CACHE)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -750,6 +771,14 @@ enum btrfs_caching_type {
 	BTRFS_CACHE_FINISHED	= 2,
 };
 
+enum btrfs_disk_cache_state {
+	BTRFS_DC_WRITTEN	= 0,
+	BTRFS_DC_ERROR		= 1,
+	BTRFS_DC_CLEAR		= 2,
+	BTRFS_DC_SETUP		= 3,
+	BTRFS_DC_NEED_WRITE	= 4,
+};
+
 struct btrfs_caching_control {
 	struct list_head list;
 	struct mutex mutex;
@@ -763,6 +792,7 @@ struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
 	struct btrfs_fs_info *fs_info;
+	struct inode *inode;
 	spinlock_t lock;
 	u64 pinned;
 	u64 reserved;
@@ -773,8 +803,11 @@ struct btrfs_block_group_cache {
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
-	int ro;
-	int dirty;
+	int ro:1;
+	int dirty:1;
+	int iref:1;
+
+	int disk_cache_state;
 
 	/* cache tracking stuff */
 	int cached;
@@ -1665,6 +1698,27 @@ static inline void btrfs_set_dir_item_key(struct extent_buffer *eb,
 	write_eb_member(eb, item, struct btrfs_dir_item, location, key);
 }
 
+BTRFS_SETGET_FUNCS(free_space_entries, struct btrfs_free_space_header,
+		   num_entries, 64);
+BTRFS_SETGET_FUNCS(free_space_bitmaps, struct btrfs_free_space_header,
+		   num_bitmaps, 64);
+BTRFS_SETGET_FUNCS(free_space_generation, struct btrfs_free_space_header,
+		   generation, 64);
+
+static inline void btrfs_free_space_key(struct extent_buffer *eb,
+					struct btrfs_free_space_header *h,
+					struct btrfs_disk_key *key)
+{
+	read_eb_member(eb, h, struct btrfs_free_space_header, location, key);
+}
+
+static inline void btrfs_set_free_space_key(struct extent_buffer *eb,
+					    struct btrfs_free_space_header *h,
+					    struct btrfs_disk_key *key)
+{
+	write_eb_member(eb, h, struct btrfs_free_space_header, location, key);
+}
+
 /* struct btrfs_disk_key */
 BTRFS_SETGET_STACK_FUNCS(disk_key_objectid, struct btrfs_disk_key,
 			 objectid, 64);
@@ -2115,6 +2169,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
 int btrfs_set_block_group_rw(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
+void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
@@ -2426,6 +2481,10 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
 			      loff_t actual_len, u64 *alloc_hint);
+int btrfs_prealloc_file_range_trans(struct inode *inode,
+				    struct btrfs_trans_handle *trans, int mode,
+				    u64 start, u64 num_bytes, u64 min_size,
+				    loff_t actual_len, u64 *alloc_hint);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..163ee07 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1685,7 +1685,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	__setup_root(4096, 4096, 4096, 4096, tree_root,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
-
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
 	if (!bh)
 		goto fail_iput;
@@ -1993,6 +1992,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		down_read(&fs_info->cleanup_work_sem);
 		btrfs_orphan_cleanup(fs_info->fs_root);
+		btrfs_orphan_cleanup(fs_info->tree_root);
 		up_read(&fs_info->cleanup_work_sem);
 	}
 
@@ -2421,6 +2421,7 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 1;
 	smp_mb();
 
+	btrfs_put_block_group_cache(fs_info);
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret =  btrfs_commit_super(root);
 		if (ret)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a46b64d..b8151ad 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2688,6 +2688,109 @@ next_block_group(struct btrfs_root *root,
 	return cache;
 }
 
+static int cache_save_setup(struct btrfs_block_group_cache *block_group,
+			    struct btrfs_trans_handle *trans,
+			    struct btrfs_path *path)
+{
+	struct btrfs_root *root = block_group->fs_info->tree_root;
+	struct inode *inode = NULL;
+	u64 alloc_hint = 0;
+	int num_pages = 0;
+	int retries = 0;
+	int ret = 0;
+
+	/*
+	 * If this block group is smaller than 100 megs don't bother caching the
+	 * block group.
+	 */
+	if (block_group->key.offset < (100 * 1024 * 1024)) {
+		spin_lock(&block_group->lock);
+		block_group->disk_cache_state = BTRFS_DC_WRITTEN;
+		spin_unlock(&block_group->lock);
+		return 0;
+	}
+
+again:
+	inode = lookup_free_space_inode(root, block_group, path);
+	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
+		ret = PTR_ERR(inode);
+		btrfs_release_path(root, path);
+		goto out;
+	}
+
+	if (IS_ERR(inode)) {
+		BUG_ON(retries);
+		retries++;
+
+		if (block_group->ro)
+			goto out_free;
+
+		ret = create_free_space_inode(root, trans, block_group, path);
+		if (ret)
+			goto out_free;
+		goto again;
+	}
+
+	/*
+	 * We want to set the generation to 0, that way if anything goes wrong
+	 * from here on out we know not to trust this cache when we load up next
+	 * time.
+	 */
+	BTRFS_I(inode)->generation = 0;
+	ret = btrfs_update_inode(trans, root, inode);
+	WARN_ON(ret);
+
+	if (i_size_read(inode) > 0) {
+		ret = btrfs_truncate_free_space_cache(root, trans, path,
+						      inode);
+		if (ret)
+			goto out_put;
+	}
+
+	spin_lock(&block_group->lock);
+	if (block_group->cached != BTRFS_CACHE_FINISHED) {
+		spin_unlock(&block_group->lock);
+		goto out_put;
+	}
+	spin_unlock(&block_group->lock);
+
+	num_pages = (int)div64_u64(block_group->key.offset, 1024 * 1024 * 1024);
+	if (!num_pages)
+		num_pages = 1;
+
+	/*
+	 * Just to make absolutely sure we have enough space, we're going to
+	 * preallocate 12 pages worth of space for each block group.  In
+	 * practice we ought to use at most 8, but we need extra space so we can
+	 * add our header and have a terminator between the extents and the
+	 * bitmaps.
+	 */
+	num_pages *= 16;
+	num_pages *= PAGE_CACHE_SIZE;
+
+	ret = btrfs_check_data_free_space(inode, num_pages);
+	if (ret)
+		goto out_put;
+
+	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, num_pages,
+					      num_pages, num_pages,
+					      &alloc_hint);
+	btrfs_free_reserved_data_space(inode, num_pages);
+out_put:
+	iput(inode);
+out_free:
+	btrfs_release_path(root, path);
+out:
+	spin_lock(&block_group->lock);
+	if (ret)
+		block_group->disk_cache_state = BTRFS_DC_ERROR;
+	else
+		block_group->disk_cache_state = BTRFS_DC_SETUP;
+	spin_unlock(&block_group->lock);
+
+	return ret;
+}
+
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
@@ -2700,6 +2803,25 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+again:
+	while (1) {
+		cache = btrfs_lookup_first_block_group(root->fs_info, last);
+		while (cache) {
+			if (cache->disk_cache_state == BTRFS_DC_CLEAR)
+				break;
+			cache = next_block_group(root, cache);
+		}
+		if (!cache) {
+			if (last == 0)
+				break;
+			last = 0;
+			continue;
+		}
+		err = cache_save_setup(cache, trans, path);
+		last = cache->key.objectid + cache->key.offset;
+		btrfs_put_block_group(cache);
+	}
+
 	while (1) {
 		if (last == 0) {
 			err = btrfs_run_delayed_refs(trans, root,
@@ -2709,6 +2831,11 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 
 		cache = btrfs_lookup_first_block_group(root->fs_info, last);
 		while (cache) {
+			if (cache->disk_cache_state == BTRFS_DC_CLEAR) {
+				btrfs_put_block_group(cache);
+				goto again;
+			}
+
 			if (cache->dirty)
 				break;
 			cache = next_block_group(root, cache);
@@ -2883,11 +3010,16 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 used;
-	int ret = 0, committed = 0;
+	int ret = 0, committed = 0, alloc_chunk = 1;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
+	if (root == root->fs_info->tree_root) {
+		alloc_chunk = 0;
+		committed = 1;
+	}
+
 	data_sinfo = BTRFS_I(inode)->space_info;
 	if (!data_sinfo)
 		goto alloc;
@@ -2906,7 +3038,7 @@ again:
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
 		 */
-		if (!data_sinfo->full) {
+		if (!data_sinfo->full && alloc_chunk) {
 			u64 alloc_target;
 
 			data_sinfo->force_alloc = 1;
@@ -3777,12 +3909,13 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc)
 {
-	struct btrfs_block_group_cache *cache;
+	struct btrfs_block_group_cache *cache = NULL;
 	struct btrfs_fs_info *info = root->fs_info;
-	int factor;
+	u64 features = btrfs_super_incompat_flags(&info->super_copy);
 	u64 total = num_bytes;
 	u64 old_val;
 	u64 byte_in_group;
+	int factor;
 
 	/* block accounting for super block */
 	spin_lock(&info->delalloc_lock);
@@ -3804,11 +3937,17 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			factor = 2;
 		else
 			factor = 1;
+
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
 
 		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
+
+		if (cache->disk_cache_state < BTRFS_DC_CLEAR &&
+		    features & BTRFS_FEATURE_INCOMPAT_SPACE_CACHE)
+			cache->disk_cache_state = BTRFS_DC_CLEAR;
+
 		cache->dirty = 1;
 		old_val = btrfs_block_group_used(&cache->item);
 		num_bytes = min(total, cache->key.offset - byte_in_group);
@@ -7814,6 +7953,39 @@ out:
 	return ret;
 }
 
+void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
+{
+	struct btrfs_block_group_cache *block_group;
+	u64 last = 0;
+
+	while (1) {
+		struct inode *inode;
+
+		block_group = btrfs_lookup_first_block_group(info, last);
+		while (block_group) {
+			spin_lock(&block_group->lock);
+			if (block_group->iref)
+				break;
+			spin_unlock(&block_group->lock);
+			block_group = next_block_group(info->tree_root,
+						       block_group);
+		}
+		if (!block_group) {
+			if (last == 0)
+				break;
+			last = 0;
+			continue;
+		}
+
+		inode = block_group->inode;
+		block_group->iref = 0;
+		spin_unlock(&block_group->lock);
+		iput(inode);
+		last = block_group->key.objectid + block_group->key.offset;
+		btrfs_put_block_group(block_group);
+	}
+}
+
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_block_group_cache *block_group;
@@ -8032,6 +8204,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->key.offset = size;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	cache->sectorsize = root->sectorsize;
+	cache->fs_info = root->fs_info;
 
 	/*
 	 * we only want to have 32k of ram per block group for keeping track
@@ -8088,7 +8261,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_free_cluster *cluster;
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
 	struct btrfs_key key;
+	struct inode *inode;
 	int ret;
 
 	root = root->fs_info->extent_root;
@@ -8097,8 +8272,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
-	memcpy(&key, &block_group->key, sizeof(key));
-
 	/* make sure this block group isn't part of an allocation cluster */
 	cluster = &root->fs_info->data_alloc_cluster;
 	spin_lock(&cluster->refill_lock);
@@ -8117,6 +8290,39 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
+	inode = lookup_free_space_inode(root, block_group, path);
+	if (!IS_ERR(inode)) {
+		btrfs_orphan_add(trans, inode);
+		clear_nlink(inode);
+		/* One for the block groups ref */
+		spin_lock(&block_group->lock);
+		if (block_group->iref) {
+			block_group->inode = NULL;
+			spin_unlock(&block_group->lock);
+			iput(inode);
+		} else {
+			spin_unlock(&block_group->lock);
+		}
+		/* One for our lookup ref */
+		iput(inode);
+	}
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.offset = block_group->key.objectid;
+	key.type = 0;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0)
+		btrfs_release_path(tree_root, path);
+	if (ret == 0) {
+		ret = btrfs_del_item(trans, tree_root, path);
+		if (ret)
+			goto out;
+		btrfs_release_path(tree_root, path);
+	}
+
 	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
@@ -8140,6 +8346,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
 	spin_unlock(&block_group->space_info->lock);
 
+	memcpy(&key, &block_group->key, sizeof(key));
+
 	btrfs_clear_space_info_full(root->fs_info);
 
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f488fac..05efcc7 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -23,10 +23,165 @@
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
+#include "disk-io.h"
 
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
 
+struct inode *lookup_free_space_inode(struct btrfs_root *root,
+				      struct btrfs_block_group_cache
+				      *block_group, struct btrfs_path *path)
+{
+	struct btrfs_key key;
+	struct btrfs_key location;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_free_space_header *header;
+	struct extent_buffer *leaf;
+	struct inode *inode = NULL;
+	int ret;
+
+	spin_lock(&block_group->lock);
+	if (block_group->inode)
+		inode = igrab(block_group->inode);
+	spin_unlock(&block_group->lock);
+	if (inode)
+		return inode;
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.offset = block_group->key.objectid;
+	key.type = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0) {
+		btrfs_release_path(root, path);
+		return ERR_PTR(-ENOENT);
+	}
+
+	leaf = path->nodes[0];
+	header = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_free_space_header);
+	btrfs_free_space_key(leaf, header, &disk_key);
+	btrfs_disk_key_to_cpu(&location, &disk_key);
+	btrfs_release_path(root, path);
+
+	inode = btrfs_iget(root->fs_info->sb, &location, root, NULL);
+	if (!inode)
+		return ERR_PTR(-ENOENT);
+	if (IS_ERR(inode))
+		return inode;
+	if (is_bad_inode(inode)) {
+		iput(inode);
+		return ERR_PTR(-ENOENT);
+	}
+
+	spin_lock(&block_group->lock);
+	if (!root->fs_info->closing) {
+		block_group->inode = igrab(inode);
+		block_group->iref = 1;
+	}
+	spin_unlock(&block_group->lock);
+
+	return inode;
+}
+
+int create_free_space_inode(struct btrfs_root *root,
+			    struct btrfs_trans_handle *trans,
+			    struct btrfs_block_group_cache *block_group,
+			    struct btrfs_path *path)
+{
+	struct btrfs_key key;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_free_space_header *header;
+	struct btrfs_inode_item *inode_item;
+	struct extent_buffer *leaf;
+	u64 objectid;
+	int ret;
+
+	ret = btrfs_find_free_objectid(trans, root, 0, &objectid);
+	if (ret < 0)
+		return ret;
+
+	ret = btrfs_insert_empty_inode(trans, root, path, objectid);
+	if (ret)
+		return ret;
+
+	leaf = path->nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_inode_item);
+	btrfs_item_key(leaf, &disk_key, path->slots[0]);
+	memset_extent_buffer(leaf, 0, (unsigned long)inode_item,
+			     sizeof(*inode_item));
+	btrfs_set_inode_generation(leaf, inode_item, trans->transid);
+	btrfs_set_inode_size(leaf, inode_item, 0);
+	btrfs_set_inode_nbytes(leaf, inode_item, 0);
+	btrfs_set_inode_uid(leaf, inode_item, 0);
+	btrfs_set_inode_gid(leaf, inode_item, 0);
+	btrfs_set_inode_mode(leaf, inode_item, S_IFREG | 0600);
+	btrfs_set_inode_flags(leaf, inode_item, BTRFS_INODE_NOCOMPRESS |
+			      BTRFS_INODE_PREALLOC | BTRFS_INODE_NODATASUM);
+	btrfs_set_inode_nlink(leaf, inode_item, 1);
+	btrfs_set_inode_transid(leaf, inode_item, trans->transid);
+	btrfs_set_inode_block_group(leaf, inode_item,
+				    block_group->key.objectid);
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.offset = block_group->key.objectid;
+	key.type = 0;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key,
+				      sizeof(struct btrfs_free_space_header));
+	if (ret < 0) {
+		btrfs_release_path(root, path);
+		return ret;
+	}
+	leaf = path->nodes[0];
+	header = btrfs_item_ptr(leaf, path->slots[0],
+				struct btrfs_free_space_header);
+	memset_extent_buffer(leaf, 0, (unsigned long)header, sizeof(*header));
+	btrfs_set_free_space_key(leaf, header, &disk_key);
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(root, path);
+
+	return 0;
+}
+
+int btrfs_truncate_free_space_cache(struct btrfs_root *root,
+				    struct btrfs_trans_handle *trans,
+				    struct btrfs_path *path,
+				    struct inode *inode)
+{
+	loff_t oldsize;
+	int ret = 0;
+
+	trans->block_rsv = root->orphan_block_rsv;
+	ret = btrfs_block_rsv_check(trans, root,
+				    root->orphan_block_rsv,
+				    0, 5);
+	if (ret)
+		return ret;
+
+	oldsize = i_size_read(inode);
+	btrfs_i_size_write(inode, 0);
+	truncate_pagecache(inode, oldsize, 0);
+
+	/*
+	 * We don't need an orphan item because truncating the free space cache
+	 * will never be split across transactions.
+	 */
+	ret = btrfs_truncate_inode_items(trans, root, inode,
+					 0, BTRFS_EXTENT_DATA_KEY);
+	if (ret) {
+		WARN_ON(1);
+		return ret;
+	}
+
+	return btrfs_update_inode(trans, root, inode);
+}
+
 static inline unsigned long offset_to_bit(u64 bitmap_start, u64 sectorsize,
 					  u64 offset)
 {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 890a8e7..45be29e 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -27,6 +27,17 @@ struct btrfs_free_space {
 	struct list_head list;
 };
 
+struct inode *lookup_free_space_inode(struct btrfs_root *root,
+				      struct btrfs_block_group_cache
+				      *block_group, struct btrfs_path *path);
+int create_free_space_inode(struct btrfs_root *root,
+			    struct btrfs_trans_handle *trans,
+			    struct btrfs_block_group_cache *block_group,
+			    struct btrfs_path *path);
+int btrfs_truncate_free_space_cache(struct btrfs_root *root,
+				    struct btrfs_trans_handle *trans,
+				    struct btrfs_path *path,
+				    struct inode *inode);
 int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 			 u64 bytenr, u64 size);
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..16b708a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1700,6 +1700,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 						ordered_extent->len);
 		BUG_ON(ret);
 	} else {
+		BUG_ON(root == root->fs_info->tree_root);
 		ret = insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->start,
@@ -3197,7 +3198,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
-	if (root->ref_cows)
+	if (root->ref_cows || root == root->fs_info->tree_root)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 
 	path = btrfs_alloc_path();
@@ -3345,7 +3346,8 @@ delete:
 		} else {
 			break;
 		}
-		if (found_extent && root->ref_cows) {
+		if (found_extent && (root->ref_cows ||
+				     root == root->fs_info->tree_root)) {
 			btrfs_set_path_blocking(path);
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
@@ -3883,7 +3885,14 @@ static void inode_tree_del(struct inode *inode)
 	}
 	spin_unlock(&root->inode_lock);
 
-	if (empty && btrfs_root_refs(&root->root_item) == 0) {
+	/*
+	 * Free space cache has inodes in the tree root, but the tree root has a
+	 * root_refs of 0, so this could end up dropping the tree root as a
+	 * snapshot, so we need the extra !root->fs_info->tree_root check to
+	 * make sure we don't drop it.
+	 */
+	if (empty && btrfs_root_refs(&root->root_item) == 0 &&
+	    root != root->fs_info->tree_root) {
 		synchronize_srcu(&root->fs_info->subvol_srcu);
 		spin_lock(&root->inode_lock);
 		empty = RB_EMPTY_ROOT(&root->inode_tree);
@@ -4277,14 +4286,24 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
+	bool nolock = false;
 
 	if (BTRFS_I(inode)->dummy_inode)
 		return 0;
 
+	smp_mb();
+	nolock = (root->fs_info->closing && root == root->fs_info->tree_root);
+
 	if (wbc->sync_mode == WB_SYNC_ALL) {
-		trans = btrfs_join_transaction(root, 1);
+		if (nolock)
+			trans = btrfs_join_transaction_nolock(root, 1);
+		else
+			trans = btrfs_join_transaction(root, 1);
 		btrfs_set_trans_block_group(trans, inode);
-		ret = btrfs_commit_transaction(trans, root);
+		if (nolock)
+			ret = btrfs_end_transaction_nolock(trans, root);
+		else
+			ret = btrfs_commit_transaction(trans, root);
 	}
 	return ret;
 }
@@ -6312,6 +6331,21 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 	}
 
+	if (root == root->fs_info->tree_root) {
+		struct btrfs_block_group_cache *block_group;
+
+		block_group = btrfs_lookup_block_group(root->fs_info,
+						BTRFS_I(inode)->block_group);
+		if (block_group && block_group->inode == inode) {
+			spin_lock(&block_group->lock);
+			block_group->inode = NULL;
+			spin_unlock(&block_group->lock);
+			btrfs_put_block_group(block_group);
+		} else if (block_group) {
+			btrfs_put_block_group(block_group);
+		}
+	}
+
 	spin_lock(&root->orphan_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
 		printk(KERN_INFO "BTRFS: inode %lu still on the orphan list\n",
@@ -6343,7 +6377,8 @@ free:
 void btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_item) == 0)
+	if (inode->i_nlink > 0 && (btrfs_root_refs(&root->root_item) == 0 &&
+				   root != root->fs_info->tree_root))
 		generic_delete_inode(inode);
 	else
 		generic_drop_inode(inode);
@@ -6760,27 +6795,33 @@ out_unlock:
 	return err;
 }
 
-int btrfs_prealloc_file_range(struct inode *inode, int mode,
-			      u64 start, u64 num_bytes, u64 min_size,
-			      loff_t actual_len, u64 *alloc_hint)
+static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
+				       u64 start, u64 num_bytes, u64 min_size,
+				       loff_t actual_len, u64 *alloc_hint,
+				       struct btrfs_trans_handle *trans)
 {
-	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 cur_offset = start;
 	int ret = 0;
+	bool own_trans = true;
 
+	if (trans)
+		own_trans = false;
 	while (num_bytes > 0) {
-		trans = btrfs_start_transaction(root, 3);
-		if (IS_ERR(trans)) {
-			ret = PTR_ERR(trans);
-			break;
+		if (own_trans) {
+			trans = btrfs_start_transaction(root, 3);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				break;
+			}
 		}
 
 		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
 					   0, *alloc_hint, (u64)-1, &ins, 1);
 		if (ret) {
-			btrfs_end_transaction(trans, root);
+			if (own_trans)
+				btrfs_end_transaction(trans, root);
 			break;
 		}
 
@@ -6813,11 +6854,30 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
 
-		btrfs_end_transaction(trans, root);
+		if (own_trans)
+			btrfs_end_transaction(trans, root);
 	}
 	return ret;
 }
 
+int btrfs_prealloc_file_range(struct inode *inode, int mode,
+			      u64 start, u64 num_bytes, u64 min_size,
+			      loff_t actual_len, u64 *alloc_hint)
+{
+	return __btrfs_prealloc_file_range(inode, mode, start, num_bytes,
+					   min_size, actual_len, alloc_hint,
+					   NULL);
+}
+
+int btrfs_prealloc_file_range_trans(struct inode *inode,
+				    struct btrfs_trans_handle *trans, int mode,
+				    u64 start, u64 num_bytes, u64 min_size,
+				    loff_t actual_len, u64 *alloc_hint)
+{
+	return __btrfs_prealloc_file_range(inode, mode, start, num_bytes,
+					   min_size, actual_len, alloc_hint, trans);
+}
+
 static long btrfs_fallocate(struct inode *inode, int mode,
 			    loff_t offset, loff_t len)
 {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b37d723..af339ee 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -29,6 +29,7 @@
 #include "locking.h"
 #include "btrfs_inode.h"
 #include "async-thread.h"
+#include "free-space-cache.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3191,6 +3192,54 @@ static int block_use_full_backref(struct reloc_control *rc,
 	return ret;
 }
 
+static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
+				    struct inode *inode, u64 ino)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_trans_handle *trans;
+	unsigned long nr;
+	int ret = 0;
+
+	if (inode)
+		goto truncate;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
+	if (!inode || IS_ERR(inode) || is_bad_inode(inode)) {
+		if (inode && !IS_ERR(inode))
+			iput(inode);
+		return -ENOENT;
+	}
+
+truncate:
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	trans = btrfs_join_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		goto out;
+	}
+
+	ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
+
+	btrfs_free_path(path);
+	nr = trans->blocks_used;
+	btrfs_end_transaction(trans, root);
+	btrfs_btree_balance_dirty(root, nr);
+out:
+	iput(inode);
+	return ret;
+}
+
 /*
  * helper to add tree blocks for backref of type BTRFS_EXTENT_DATA_REF_KEY
  * this function scans fs tree to find blocks reference the data extent
@@ -3217,15 +3266,27 @@ static int find_data_references(struct reloc_control *rc,
 	int counted;
 	int ret;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
 	ref_root = btrfs_extent_data_ref_root(leaf, ref);
 	ref_objectid = btrfs_extent_data_ref_objectid(leaf, ref);
 	ref_offset = btrfs_extent_data_ref_offset(leaf, ref);
 	ref_count = btrfs_extent_data_ref_count(leaf, ref);
 
+	/*
+	 * This is an extent belonging to the free space cache, lets just delete
+	 * it and redo the search.
+	 */
+	if (ref_root == BTRFS_ROOT_TREE_OBJECTID) {
+		ret = delete_block_group_cache(rc->extent_root->fs_info,
+					       NULL, ref_objectid);
+		if (ret != -ENOENT)
+			return ret;
+		ret = 0;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	root = read_fs_root(rc->extent_root->fs_info, ref_root);
 	if (IS_ERR(root)) {
 		err = PTR_ERR(root);
@@ -3860,6 +3921,8 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 {
 	struct btrfs_fs_info *fs_info = extent_root->fs_info;
 	struct reloc_control *rc;
+	struct inode *inode;
+	struct btrfs_path *path;
 	int ret;
 	int rw = 0;
 	int err = 0;
@@ -3882,6 +3945,26 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		rw = 1;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	inode = lookup_free_space_inode(fs_info->tree_root, rc->block_group,
+					path);
+	btrfs_free_path(path);
+
+	if (!IS_ERR(inode))
+		ret = delete_block_group_cache(fs_info, inode, 0);
+	else
+		ret = PTR_ERR(inode);
+
+	if (ret && ret != -ENOENT) {
+		err = ret;
+		goto out;
+	}
+
 	rc->data_inode = create_reloc_inode(fs_info, rc->block_group);
 	if (IS_ERR(rc->data_inode)) {
 		err = PTR_ERR(rc->data_inode);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 859ddaa..6a625e9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -68,7 +68,7 @@ enum {
 	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
 	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
 	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
-	Opt_discard, Opt_err,
+	Opt_discard, Opt_space_cache, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -92,6 +92,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_space_cache, "space_cache"},
 	{Opt_err, NULL},
 };
 
@@ -104,6 +105,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
 	char *p, *num, *orig;
+	struct btrfs_super_block *disk_super;
+	u64 features;
 	int intarg;
 	int ret = 0;
 
@@ -235,6 +238,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_space_cache:
+			disk_super = &info->super_copy;
+			features = btrfs_super_incompat_flags(disk_super);
+			features |= BTRFS_FEATURE_INCOMPAT_SPACE_CACHE;
+			btrfs_set_super_incompat_flags(disk_super, features);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 66e4c66..db0da35 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -163,6 +163,7 @@ enum btrfs_trans_type {
 	TRANS_START,
 	TRANS_JOIN,
 	TRANS_USERSPACE,
+	TRANS_JOIN_NOLOCK,
 };
 
 static int may_wait_transaction(struct btrfs_root *root, int type)
@@ -186,7 +187,8 @@ again:
 	if (!h)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_lock(&root->fs_info->trans_mutex);
+	if (type != TRANS_JOIN_NOLOCK)
+		mutex_lock(&root->fs_info->trans_mutex);
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
 
@@ -195,7 +197,8 @@ again:
 
 	cur_trans = root->fs_info->running_transaction;
 	cur_trans->use_count++;
-	mutex_unlock(&root->fs_info->trans_mutex);
+	if (type != TRANS_JOIN_NOLOCK)
+		mutex_unlock(&root->fs_info->trans_mutex);
 
 	h->transid = cur_trans->transid;
 	h->transaction = cur_trans;
@@ -224,9 +227,11 @@ again:
 		}
 	}
 
-	mutex_lock(&root->fs_info->trans_mutex);
+	if (type != TRANS_JOIN_NOLOCK)
+		mutex_lock(&root->fs_info->trans_mutex);
 	record_root_in_trans(h, root);
-	mutex_unlock(&root->fs_info->trans_mutex);
+	if (type != TRANS_JOIN_NOLOCK)
+		mutex_unlock(&root->fs_info->trans_mutex);
 
 	if (!current->journal_info && type != TRANS_USERSPACE)
 		current->journal_info = h;
@@ -244,6 +249,12 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 	return start_transaction(root, 0, TRANS_JOIN);
 }
 
+struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root,
+							  int num_blocks)
+{
+	return start_transaction(root, 0, TRANS_JOIN_NOLOCK);
+}
+
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
 							 int num_blocks)
 {
@@ -348,7 +359,7 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 }
 
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, int throttle)
+			  struct btrfs_root *root, int throttle, int lock)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *info = root->fs_info;
@@ -376,18 +387,19 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_metadata(trans, root);
 
-	if (!root->fs_info->open_ioctl_trans &&
+	if (lock && !root->fs_info->open_ioctl_trans &&
 	    should_end_transaction(trans, root))
 		trans->transaction->blocked = 1;
 
-	if (cur_trans->blocked && !cur_trans->in_commit) {
+	if (lock && cur_trans->blocked && !cur_trans->in_commit) {
 		if (throttle)
 			return btrfs_commit_transaction(trans, root);
 		else
 			wake_up_process(info->transaction_kthread);
 	}
 
-	mutex_lock(&info->trans_mutex);
+	if (lock)
+		mutex_lock(&info->trans_mutex);
 	WARN_ON(cur_trans != info->running_transaction);
 	WARN_ON(cur_trans->num_writers < 1);
 	cur_trans->num_writers--;
@@ -395,7 +407,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (waitqueue_active(&cur_trans->writer_wait))
 		wake_up(&cur_trans->writer_wait);
 	put_transaction(cur_trans);
-	mutex_unlock(&info->trans_mutex);
+	if (lock)
+		mutex_unlock(&info->trans_mutex);
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
@@ -411,13 +424,19 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root)
 {
-	return __btrfs_end_transaction(trans, root, 0);
+	return __btrfs_end_transaction(trans, root, 0, 1);
 }
 
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root)
 {
-	return __btrfs_end_transaction(trans, root, 1);
+	return __btrfs_end_transaction(trans, root, 1, 1);
+}
+
+int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root)
+{
+	return __btrfs_end_transaction(trans, root, 0, 0);
 }
 
 /*
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e104986..15f83e1 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -87,10 +87,14 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
+int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 						  int num_blocks);
+struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root,
+							  int num_blocks);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
 							 int num_blocks);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-- 
1.6.6.1

