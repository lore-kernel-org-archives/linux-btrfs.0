From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: add better -ENOSPC handling VERSION 3
Date: Fri, 13 Feb 2009 15:40:04 -0500
Message-ID: <1234557604-28769-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This is a step in the direction of better -ENOSPC handling.  Instead of checking
the global bytes counter we check the space_info bytes counters to make sure we
have enough space.  If we don't we go ahead and try to allocate a new chunk, and
then if that fails we return -ENOSPC.  This patch adds two counters to
btrfs_space_info, bytes_delalloc and bytes_may_use.  bytes_delalloc account for
extents we've actually setup for delalloc and will be allocated at some point
down the line.  bytes_may_use is to keep track of how many bytes we may use for
delalloc at some point.  When we actually set the extent_bit for the delalloc
bytes we subtract the reserved bytes from the bytes_may_use counter.  This keeps
us from not actually being able to allocate space for any delalloc bytes.  This
has been tested with fs_mark and dbench.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    8 ++
 fs/btrfs/ctree.h       |   40 +++++++--
 fs/btrfs/extent-tree.c |  214 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/file.c        |   16 +++-
 fs/btrfs/inode.c       |   62 ++++----------
 fs/btrfs/ioctl.c       |    6 +-
 6 files changed, 270 insertions(+), 76 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a8c9693..72677ce 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -66,6 +66,9 @@ struct btrfs_inode {
 	 */
 	struct list_head delalloc_inodes;
 
+	/* the space_info for where this inode's data allocations are done */
+	struct btrfs_space_info *space_info;
+
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
 	 */
@@ -94,6 +97,11 @@ struct btrfs_inode {
 	 */
 	u64 delalloc_bytes;
 
+	/* total number of bytes that may be used for this inode for
+	 * delalloc
+	 */
+	u64 reserved_bytes;
+
 	/*
 	 * the size of the file stored in the metadata on disk.  data=ordered
 	 * means the in-memory i_size might be larger than the size on disk
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 766b31a..82491ba 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -596,13 +596,27 @@ struct btrfs_block_group_item {
 
 struct btrfs_space_info {
 	u64 flags;
-	u64 total_bytes;
-	u64 bytes_used;
-	u64 bytes_pinned;
-	u64 bytes_reserved;
-	u64 bytes_readonly;
-	int full;
-	int force_alloc;
+
+	u64 total_bytes;	/* total bytes in the space */
+	u64 bytes_used;		/* total bytes used on disk */
+	u64 bytes_pinned;	/* total bytes pinned, will be freed when the
+				   transaction finishes */
+	u64 bytes_reserved;	/* total bytes the allocator has reserved for
+				   current allocations */
+	u64 bytes_readonly;	/* total bytes that are read only */
+
+	/* delalloc accounting */
+	u64 bytes_delalloc;	/* number of bytes reserved for allocation,
+				   this space is not necessarily reserved yet
+				   by the allocator */
+	u64 bytes_may_use;	/* number of bytes that may be used for
+				   delalloc */
+
+	int full;		/* indicates that we cannot allocate any more
+				   chunks for this space */
+	int force_alloc;	/* set if we need to force a chunk alloc for
+				   this space */
+
 	struct list_head list;
 
 	/* for block groups in our same type */
@@ -1782,6 +1796,16 @@ int btrfs_add_dead_reloc_root(struct btrfs_root *root);
 int btrfs_cleanup_reloc_trees(struct btrfs_root *root);
 int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
+void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
+int btrfs_check_metadata_free_space(struct btrfs_root *root);
+int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
+				u64 bytes);
+void btrfs_free_reserved_data_space(struct btrfs_root *root,
+				    struct inode *inode, u64 bytes);
+void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
+				 u64 bytes);
+void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
+			      u64 bytes);
 /* ctree.c */
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
@@ -2027,8 +2051,6 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 unsigned long btrfs_force_ra(struct address_space *mapping,
 			      struct file_ra_state *ra, struct file *file,
 			      pgoff_t offset, pgoff_t last_index);
-int btrfs_check_free_space(struct btrfs_root *root, u64 num_required,
-			   int for_del);
 int btrfs_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_delete_inode(struct inode *inode);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0a5d796..af12e9d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -59,6 +59,9 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc,
 			      int mark_free);
+static int do_chunk_alloc(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *extent_root, u64 alloc_bytes,
+			  u64 flags, int force);
 
 static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 {
@@ -1909,6 +1912,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->bytes_pinned = 0;
 	found->bytes_reserved = 0;
 	found->bytes_readonly = 0;
+	found->bytes_delalloc = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -1972,6 +1976,196 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	return flags;
 }
 
+static u64 btrfs_get_alloc_profile(struct btrfs_root *root, u64 data)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	u64 alloc_profile;
+
+	if (data) {
+		alloc_profile = info->avail_data_alloc_bits &
+			info->data_alloc_profile;
+		data = BTRFS_BLOCK_GROUP_DATA | alloc_profile;
+	} else if (root == root->fs_info->chunk_root) {
+		alloc_profile = info->avail_system_alloc_bits &
+			info->system_alloc_profile;
+		data = BTRFS_BLOCK_GROUP_SYSTEM | alloc_profile;
+	} else {
+		alloc_profile = info->avail_metadata_alloc_bits &
+			info->metadata_alloc_profile;
+		data = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
+	}
+
+	return btrfs_reduce_alloc_profile(root, data);
+}
+
+void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *inode)
+{
+	u64 alloc_target;
+
+	alloc_target = btrfs_get_alloc_profile(root, 1);
+	BTRFS_I(inode)->space_info = __find_space_info(root->fs_info,
+						       alloc_target);
+}
+
+/*
+ * for now this just makes sure we have at least 5% of our metadata space free
+ * for use.
+ */
+int btrfs_check_metadata_free_space(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_space_info *meta_sinfo;
+	u64 alloc_target, thresh;
+
+	/* get the space info for where the metadata will live */
+	alloc_target = btrfs_get_alloc_profile(root, 0);
+	meta_sinfo = __find_space_info(info, alloc_target);
+
+	/*
+	 * if the metadata area isn't maxed out then there is no sense in
+	 * checking how much is used, since we can always allocate a new chunk
+	 */
+	if (!meta_sinfo->full)
+		return 0;
+
+	spin_lock(&meta_sinfo->lock);
+	thresh = meta_sinfo->total_bytes * 95;
+
+	do_div(thresh, 100);
+
+	if (meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
+	    meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly > thresh) {
+		spin_unlock(&meta_sinfo->lock);
+		return -ENOSPC;
+	}
+	spin_unlock(&meta_sinfo->lock);
+
+	return 0;
+}
+
+/*
+ * This will check the space that the inode allocates from to make sure we have
+ * enough space for bytes.
+ */
+int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
+				u64 bytes)
+{
+	struct btrfs_space_info *data_sinfo;
+	int ret = 0;
+
+	/* make sure bytes are sectorsize aligned */
+	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+
+	data_sinfo = BTRFS_I(inode)->space_info;
+again:
+	/* make sure we have enough space to handle the data first */
+	spin_lock(&data_sinfo->lock);
+	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
+	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
+	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
+	    data_sinfo->bytes_may_use < bytes) {
+		/*
+		 * if we don't have enough free bytes in this space then we need
+		 * to alloc a new chunk.
+		 */
+		if (!data_sinfo->full) {
+			u64 alloc_target;
+			struct btrfs_trans_handle *trans;
+
+			data_sinfo->force_alloc = 1;
+			spin_unlock(&data_sinfo->lock);
+
+			alloc_target = btrfs_get_alloc_profile(root, 1);
+			trans = btrfs_start_transaction(root, 1);
+			if (!trans)
+				return -ENOMEM;
+
+			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+					     bytes + 2 * 1024 * 1024,
+					     alloc_target, 0);
+			btrfs_end_transaction(trans, root);
+			if (ret)
+				return ret;
+			goto again;
+		}
+		spin_unlock(&data_sinfo->lock);
+		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
+		       ", %llu bytes_used, %llu bytes_reserved, "
+		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use"
+		       "%llu total\n", bytes, data_sinfo->bytes_delalloc,
+		       data_sinfo->bytes_used, data_sinfo->bytes_reserved,
+		       data_sinfo->bytes_pinned, data_sinfo->bytes_readonly,
+		       data_sinfo->bytes_may_use, data_sinfo->total_bytes);
+		return -ENOSPC;
+	}
+	data_sinfo->bytes_may_use += bytes;
+	BTRFS_I(inode)->reserved_bytes += bytes;
+	spin_unlock(&data_sinfo->lock);
+
+	return btrfs_check_metadata_free_space(root);
+}
+
+/*
+ * if there was an error for whatever reason after calling
+ * btrfs_check_data_free_space, call this so we can cleanup the counters.
+ */
+void btrfs_free_reserved_data_space(struct btrfs_root *root,
+				    struct inode *inode, u64 bytes)
+{
+	struct btrfs_space_info *data_sinfo;
+
+	/* make sure bytes are sectorsize aligned */
+	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+
+	data_sinfo = BTRFS_I(inode)->space_info;
+	spin_lock(&data_sinfo->lock);
+	data_sinfo->bytes_may_use -= bytes;
+	BTRFS_I(inode)->reserved_bytes -= bytes;
+	spin_unlock(&data_sinfo->lock);
+}
+
+/* called when we are adding a delalloc extent to the inode's io_tree */
+void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
+				  u64 bytes)
+{
+	struct btrfs_space_info *data_sinfo;
+
+	/* get the space info for where this inode will be storing its data */
+	data_sinfo = BTRFS_I(inode)->space_info;
+
+	/* make sure we have enough space to handle the data first */
+	spin_lock(&data_sinfo->lock);
+	data_sinfo->bytes_delalloc += bytes;
+
+	/*
+	 * we are adding a delalloc extent without calling
+	 * btrfs_check_data_free_space first.  This happens on a weird
+	 * writepage condition, but shouldn't hurt our accounting
+	 */
+	if (unlikely(bytes > BTRFS_I(inode)->reserved_bytes)) {
+		data_sinfo->bytes_may_use -= BTRFS_I(inode)->reserved_bytes;
+		BTRFS_I(inode)->reserved_bytes = 0;
+	} else {
+		data_sinfo->bytes_may_use -= bytes;
+		BTRFS_I(inode)->reserved_bytes -= bytes;
+	}
+
+	spin_unlock(&data_sinfo->lock);
+}
+
+/* called when we are clearing an delalloc extent from the inode's io_tree */
+void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
+			      u64 bytes)
+{
+	struct btrfs_space_info *info;
+
+	info = BTRFS_I(inode)->space_info;
+
+	spin_lock(&info->lock);
+	info->bytes_delalloc -= bytes;
+	spin_unlock(&info->lock);
+}
+
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force)
@@ -3105,6 +3299,10 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
 				    info->bytes_pinned - info->bytes_reserved),
 	       (info->full) ? "" : "not ");
+	printk(KERN_INFO "space_info total=%llu, pinned=%llu, delalloc=%llu,"
+	       " may_use=%llu, used=%llu\n", info->total_bytes,
+	       info->bytes_pinned, info->bytes_delalloc, info->bytes_may_use,
+	       info->bytes_used);
 
 	down_read(&info->groups_sem);
 	list_for_each_entry(cache, &info->block_groups, list) {
@@ -3131,24 +3329,10 @@ static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	u64 search_start = 0;
-	u64 alloc_profile;
 	struct btrfs_fs_info *info = root->fs_info;
 
-	if (data) {
-		alloc_profile = info->avail_data_alloc_bits &
-			info->data_alloc_profile;
-		data = BTRFS_BLOCK_GROUP_DATA | alloc_profile;
-	} else if (root == root->fs_info->chunk_root) {
-		alloc_profile = info->avail_system_alloc_bits &
-			info->system_alloc_profile;
-		data = BTRFS_BLOCK_GROUP_SYSTEM | alloc_profile;
-	} else {
-		alloc_profile = info->avail_metadata_alloc_bits &
-			info->metadata_alloc_profile;
-		data = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
-	}
+	data = btrfs_get_alloc_profile(root, data);
 again:
-	data = btrfs_reduce_alloc_profile(root, data);
 	/*
 	 * the only place that sets empty_size is btrfs_realloc_node, which
 	 * is not called recursively on allocations
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3e8023e..1c7d106 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1091,19 +1091,24 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		WARN_ON(num_pages > nrptrs);
 		memset(pages, 0, sizeof(struct page *) * nrptrs);
 
-		ret = btrfs_check_free_space(root, write_bytes, 0);
+		ret = btrfs_check_data_free_space(root, inode, write_bytes);
 		if (ret)
 			goto out;
 
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
 				    write_bytes);
-		if (ret)
+		if (ret) {
+			btrfs_free_reserved_data_space(root, inode,
+						       write_bytes);
 			goto out;
+		}
 
 		ret = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, buf);
 		if (ret) {
+			btrfs_free_reserved_data_space(root, inode,
+						       write_bytes);
 			btrfs_drop_pages(pages, num_pages);
 			goto out;
 		}
@@ -1111,8 +1116,11 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		ret = dirty_and_release_pages(NULL, root, file, pages,
 					      num_pages, pos, write_bytes);
 		btrfs_drop_pages(pages, num_pages);
-		if (ret)
+		if (ret) {
+			btrfs_free_reserved_data_space(root, inode,
+						       write_bytes);
 			goto out;
+		}
 
 		if (will_write) {
 			btrfs_fdatawrite_range(inode->i_mapping, pos,
@@ -1136,6 +1144,8 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	}
 out:
 	mutex_unlock(&inode->i_mutex);
+	if (ret)
+		err = ret;
 
 out_nolock:
 	kfree(pages);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3cee77a..7d4f948 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -102,34 +102,6 @@ static int btrfs_init_inode_security(struct inode *inode,  struct inode *dir)
 }
 
 /*
- * a very lame attempt at stopping writes when the FS is 85% full.  There
- * are countless ways this is incorrect, but it is better than nothing.
- */
-int btrfs_check_free_space(struct btrfs_root *root, u64 num_required,
-			   int for_del)
-{
-	u64 total;
-	u64 used;
-	u64 thresh;
-	int ret = 0;
-
-	spin_lock(&root->fs_info->delalloc_lock);
-	total = btrfs_super_total_bytes(&root->fs_info->super_copy);
-	used = btrfs_super_bytes_used(&root->fs_info->super_copy);
-	if (for_del)
-		thresh = total * 90;
-	else
-		thresh = total * 85;
-
-	do_div(thresh, 100);
-
-	if (used + root->fs_info->delalloc_bytes + num_required > thresh)
-		ret = -ENOSPC;
-	spin_unlock(&root->fs_info->delalloc_lock);
-	return ret;
-}
-
-/*
  * this does all the hard work for inserting an inline extent into
  * the btree.  The caller should have done a btrfs_drop_extents so that
  * no overlapping inline items exist in the btree
@@ -1190,6 +1162,7 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 	 */
 	if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
+		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += end - start + 1;
 		root->fs_info->delalloc_bytes += end - start + 1;
@@ -1223,9 +1196,12 @@ static int btrfs_clear_bit_hook(struct inode *inode, u64 start, u64 end,
 			       (unsigned long long)end - start + 1,
 			       (unsigned long long)
 			       root->fs_info->delalloc_bytes);
+			btrfs_delalloc_free_space(root, inode, (u64)-1);
 			root->fs_info->delalloc_bytes = 0;
 			BTRFS_I(inode)->delalloc_bytes = 0;
 		} else {
+			btrfs_delalloc_free_space(root, inode,
+						  end - start + 1);
 			root->fs_info->delalloc_bytes -= end - start + 1;
 			BTRFS_I(inode)->delalloc_bytes -= end - start + 1;
 		}
@@ -2245,10 +2221,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	root = BTRFS_I(dir)->root;
 
-	ret = btrfs_check_free_space(root, 1, 1);
-	if (ret)
-		goto fail;
-
 	trans = btrfs_start_transaction(root, 1);
 
 	btrfs_set_trans_block_group(trans, dir);
@@ -2261,7 +2233,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	nr = trans->blocks_used;
 
 	btrfs_end_transaction_throttle(trans, root);
-fail:
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
@@ -2284,10 +2255,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -ENOTEMPTY;
 	}
 
-	ret = btrfs_check_free_space(root, 1, 1);
-	if (ret)
-		goto fail;
-
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2304,7 +2271,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 fail_trans:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
-fail:
 	btrfs_btree_balance_dirty(root, nr);
 
 	if (ret && !err)
@@ -2818,7 +2784,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	if (size <= hole_start)
 		return 0;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		return err;
 
@@ -3014,6 +2980,7 @@ static noinline void init_btrfs_i(struct inode *inode)
 	bi->last_trans = 0;
 	bi->logged_trans = 0;
 	bi->delalloc_bytes = 0;
+	bi->reserved_bytes = 0;
 	bi->disk_i_size = 0;
 	bi->flags = 0;
 	bi->index_cnt = (u64)-1;
@@ -3035,6 +3002,7 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
 	inode->i_ino = args->ino;
 	init_btrfs_i(inode);
 	BTRFS_I(inode)->root = args->root;
+	btrfs_set_inode_space_info(args->root, inode);
 	return 0;
 }
 
@@ -3455,6 +3423,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->index_cnt = 2;
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
+	btrfs_set_inode_space_info(root, inode);
 
 	if (mode & S_IFDIR)
 		owner = 0;
@@ -3602,7 +3571,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto fail;
 
@@ -3665,7 +3634,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto fail;
 	trans = btrfs_start_transaction(root, 1);
@@ -3733,7 +3702,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -ENOENT;
 
 	btrfs_inc_nlink(inode);
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto fail;
 	err = btrfs_set_inode_index(dir, &index);
@@ -3779,7 +3748,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto out_unlock;
 
@@ -4336,7 +4305,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	u64 page_start;
 	u64 page_end;
 
-	ret = btrfs_check_free_space(root, PAGE_CACHE_SIZE, 0);
+	ret = btrfs_check_data_free_space(root, inode, PAGE_CACHE_SIZE);
 	if (ret)
 		goto out;
 
@@ -4349,6 +4318,7 @@ again:
 
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_start >= size)) {
+		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
 		/* page got truncated out from underneath us */
 		goto out_unlock;
 	}
@@ -4631,7 +4601,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -EXDEV;
 
-	ret = btrfs_check_free_space(root, 1, 0);
+	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
 		goto out_unlock;
 
@@ -4749,7 +4719,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto out_fail;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 988fdc8..bca729f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -70,7 +70,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	ret = btrfs_check_free_space(root, 1, 0);
+	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
 		goto fail_commit;
 
@@ -203,7 +203,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	if (!root->ref_cows)
 		return -EINVAL;
 
-	ret = btrfs_check_free_space(root, 1, 0);
+	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
 		goto fail_unlock;
 
@@ -374,7 +374,7 @@ static int btrfs_defrag_file(struct file *file)
 	unsigned long i;
 	int ret;
 
-	ret = btrfs_check_free_space(root, inode->i_size, 0);
+	ret = btrfs_check_data_free_space(root, inode, inode->i_size);
 	if (ret)
 		return -ENOSPC;
 
-- 
1.5.4.3

