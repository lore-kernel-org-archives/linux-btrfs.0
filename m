From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs: add better -ENOSPC handling
Date: Thu, 22 Jan 2009 11:22:30 -0500
Message-ID: <1232641350-27624-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the large 85% brick wall that was keeping btrfs from panicing
because it ran out of space, and instead puts a nice 95% drywall in its place.
Instead of tracking delalloc bytes on a systemwide basis, just do it as per
space info.  For now that means basically just one space_info has anything set
for bytes_delalloc, but in the future when there are different allocation
schemes for different files this will be less overkill.  We reserve space by
using btrfs_delalloc_reserve_space, and then free space by using
btrfs_delalloc_free_space.  You need to make sure that these are always even,
IOW for every reserve you must have a free, so either free if you aren't goign
to use the reserved space, or free when the space is actually allocated.

For checkers we have btrfs_check_data_free_space which checks to make sure we
have sufficient metadata space and space for bytes allocation.  For metadata
operations we have btrfs_check_metadata_free_space, which is where the 95% wall
comes in.  We make sure that we always have at least 5% metadata space free in
order to make sure we have enough space to rm things if we run out of data
space.  So btrfs_check_data_free_space will call
btrfs_check_metadata_free_space, but every metadata operation (like
mknod/create/link etc) just needs to call btrfs_check_metadata_free_space.  If
the operation is going to result in free'd space, such as unlink and rmdir, you
don't need to do the check.

Tested this with fs_mark, dd, fsx without a problem.  Tested against head to
make sure there wasn't a performance regression and everything came out even.
Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |   33 +++++++++----
 fs/btrfs/extent-tree.c |  125 ++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/file.c        |   11 +++-
 fs/btrfs/inode.c       |   60 +++++------------------
 fs/btrfs/ioctl.c       |   16 +++++--
 5 files changed, 168 insertions(+), 77 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index de103a8..6819f3e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -600,13 +600,23 @@ struct btrfs_block_group_item {
 
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
+	u64 bytes_delalloc;	/* number of bytes reserved for allocation,
+				   this space is not necessarily reserved yet
+				   by the allocator */
+
+	int full;		/* indicates that we cannot allocate any more
+				   chunks for this space */
+	int force_alloc;	/* set if we need to force a chunk alloc for
+				   this space */
+
 	struct list_head list;
 
 	/* for block groups in our same type */
@@ -1786,6 +1796,13 @@ int btrfs_add_dead_reloc_root(struct btrfs_root *root);
 int btrfs_cleanup_reloc_trees(struct btrfs_root *root);
 int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
+int btrfs_check_metadata_free_space(struct btrfs_root *root);
+int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
+				u64 bytes);
+int btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
+				 u64 bytes);
+void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
+			      u64 bytes);
 /* ctree.c */
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
@@ -2029,8 +2046,6 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 unsigned long btrfs_force_ra(struct address_space *mapping,
 			      struct file_ra_state *ra, struct file *file,
 			      pgoff_t offset, pgoff_t last_index);
-int btrfs_check_free_space(struct btrfs_root *root, u64 num_required,
-			   int for_del);
 int btrfs_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_delete_inode(struct inode *inode);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3b26f09..6601123 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1814,6 +1814,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->bytes_pinned = 0;
 	found->bytes_reserved = 0;
 	found->bytes_readonly = 0;
+	found->bytes_delalloc = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -1877,6 +1878,114 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
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
+int btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
+				 u64 bytes)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_space_info *data_sinfo;
+	u64 alloc_target;
+
+	/* get the space info for where this inode will be storing its data */
+	alloc_target = btrfs_get_alloc_profile(root, 1);
+	data_sinfo = __find_space_info(info, alloc_target);
+
+	/* make sure we have enough space to handle the data first */
+	spin_lock(&data_sinfo->lock);
+	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
+	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
+	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly < bytes) {
+		spin_unlock(&data_sinfo->lock);
+		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
+		       ", %llu bytes_used, %llu bytes_reserved, "
+		       "%llu bytes_pinned, %llu bytes_readonly, %llu total\n",
+		       bytes, data_sinfo->bytes_delalloc,
+		       data_sinfo->bytes_used, data_sinfo->bytes_reserved,
+		       data_sinfo->bytes_pinned, data_sinfo->bytes_readonly,
+		       data_sinfo->total_bytes);
+		return -ENOSPC;
+	}
+	data_sinfo->bytes_delalloc += bytes;
+	spin_unlock(&data_sinfo->lock);
+
+	return btrfs_check_metadata_free_space(root);
+}
+
+void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
+			      u64 bytes)
+{
+	struct btrfs_space_info *info;
+	u64 alloc_target;
+
+	alloc_target = btrfs_get_alloc_profile(root, 1);
+	info = __find_space_info(root->fs_info, alloc_target);
+
+	spin_lock(&info->lock);
+	if (bytes == (u64)-1) {
+		info->bytes_delalloc = 0;
+	} else if (bytes > info->bytes_delalloc) {
+		printk(KERN_ERR "trying to free more bytes than we have\n");
+		dump_stack();
+		info->bytes_delalloc = 0;
+	} else {
+		info->bytes_delalloc -= bytes;
+	}
+	spin_unlock(&info->lock);
+}
+
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
 			  u64 flags, int force)
@@ -3039,24 +3148,10 @@ static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
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
index 3e8023e..c369371 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1091,28 +1091,33 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		WARN_ON(num_pages > nrptrs);
 		memset(pages, 0, sizeof(struct page *) * nrptrs);
 
-		ret = btrfs_check_free_space(root, write_bytes, 0);
+		ret = btrfs_delalloc_reserve_space(root, inode, write_bytes);
 		if (ret)
 			goto out;
 
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
 				    write_bytes);
-		if (ret)
+		if (ret) {
+			btrfs_delalloc_free_space(root, inode, write_bytes);
 			goto out;
+		}
 
 		ret = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, buf);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
+			btrfs_delalloc_free_space(root, inode, write_bytes);
 			goto out;
 		}
 
 		ret = dirty_and_release_pages(NULL, root, file, pages,
 					      num_pages, pos, write_bytes);
 		btrfs_drop_pages(pages, num_pages);
-		if (ret)
+		if (ret) {
+			btrfs_delalloc_free_space(root, inode, write_bytes);
 			goto out;
+		}
 
 		if (will_write) {
 			btrfs_fdatawrite_range(inode->i_mapping, pos,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 288c2cd..910907b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -91,34 +91,6 @@ static noinline int cow_file_range(struct inode *inode,
 				   unsigned long *nr_written, int unlock);
 
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
@@ -1198,9 +1170,12 @@ static int btrfs_clear_bit_hook(struct inode *inode, u64 start, u64 end,
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
@@ -2217,10 +2192,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	root = BTRFS_I(dir)->root;
 
-	ret = btrfs_check_free_space(root, 1, 1);
-	if (ret)
-		goto fail;
-
 	trans = btrfs_start_transaction(root, 1);
 
 	btrfs_set_trans_block_group(trans, dir);
@@ -2233,7 +2204,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	nr = trans->blocks_used;
 
 	btrfs_end_transaction_throttle(trans, root);
-fail:
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
@@ -2256,10 +2226,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -ENOTEMPTY;
 	}
 
-	ret = btrfs_check_free_space(root, 1, 1);
-	if (ret)
-		goto fail;
-
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2276,7 +2242,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 fail_trans:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
-fail:
 	btrfs_btree_balance_dirty(root, nr);
 
 	if (ret && !err)
@@ -2786,7 +2751,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	if (size <= hole_start)
 		return 0;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		return err;
 
@@ -3563,7 +3528,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto fail;
 
@@ -3626,7 +3591,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto fail;
 	trans = btrfs_start_transaction(root, 1);
@@ -3694,7 +3659,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -ENOENT;
 
 	btrfs_inc_nlink(inode);
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto fail;
 	err = btrfs_set_inode_index(dir, &index);
@@ -3740,7 +3705,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto out_unlock;
 
@@ -4297,7 +4262,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	u64 page_start;
 	u64 page_end;
 
-	ret = btrfs_check_free_space(root, PAGE_CACHE_SIZE, 0);
+	ret = btrfs_delalloc_reserve_space(root, inode, PAGE_CACHE_SIZE);
 	if (ret)
 		goto out;
 
@@ -4310,6 +4275,7 @@ again:
 
 	if ((page->mapping != inode->i_mapping) ||
 	    (page_start >= size)) {
+		btrfs_delalloc_free_space(root, inode, PAGE_CACHE_SIZE);
 		/* page got truncated out from underneath us */
 		goto out_unlock;
 	}
@@ -4332,6 +4298,8 @@ again:
 	}
 
 	btrfs_set_extent_delalloc(inode, page_start, page_end);
+	btrfs_delalloc_free_space(root, inode, PAGE_CACHE_SIZE -
+				  (page_end - page_start + 1));
 	ret = 0;
 
 	/* page is wholly or partially inside EOF */
@@ -4592,7 +4560,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -EXDEV;
 
-	ret = btrfs_check_free_space(root, 1, 0);
+	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
 		goto out_unlock;
 
@@ -4710,7 +4678,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
-	err = btrfs_check_free_space(root, 1, 0);
+	err = btrfs_check_metadata_free_space(root);
 	if (err)
 		goto out_fail;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 988fdc8..d2ac10f 100644
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
 
@@ -371,10 +371,11 @@ static int btrfs_defrag_file(struct file *file)
 	unsigned long total_read = 0;
 	u64 page_start;
 	u64 page_end;
+	u64 size = inode->i_size;
 	unsigned long i;
 	int ret;
 
-	ret = btrfs_check_free_space(root, inode->i_size, 0);
+	ret = btrfs_delalloc_reserve_space(root, inode, size);
 	if (ret)
 		return -ENOSPC;
 
@@ -388,14 +389,18 @@ static int btrfs_defrag_file(struct file *file)
 		total_read++;
 again:
 		page = grab_cache_page(inode->i_mapping, i);
-		if (!page)
+		if (!page) {
+			btrfs_delalloc_free_space(root, inode, size);
 			goto out_unlock;
+		}
+
 		if (!PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
 			lock_page(page);
 			if (!PageUptodate(page)) {
 				unlock_page(page);
 				page_cache_release(page);
+				btrfs_delalloc_free_space(root, inode, size);
 				goto out_unlock;
 			}
 		}
@@ -424,6 +429,9 @@ again:
 		clear_page_dirty_for_io(page);
 
 		btrfs_set_extent_delalloc(inode, page_start, page_end);
+		btrfs_delalloc_free_space(root, inode, size -
+					  (page_end - page_start + 1));
+		size -= page_end - page_start + 1;
 
 		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
 		set_page_dirty(page);
-- 
1.5.4.3

