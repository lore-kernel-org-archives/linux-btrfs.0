From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: kill max_extent mount option
Date: Fri, 19 Mar 2010 14:07:23 -0400
Message-ID: <20100319180722.GC2314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As Yan pointed out, theres not much reason for all this complicated math to
account for file extents being split up into max_extent chunks, since they are
likely to all end up in the same leaf anyway.  Since there isn't much reason to
use max_extent, just remove the option altogether so we have one less thing we
need to test.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h        |    1 -
 fs/btrfs/disk-io.c      |    1 -
 fs/btrfs/extent-tree.c  |    4 +-
 fs/btrfs/inode.c        |   59 +++-------------------------------------------
 fs/btrfs/ordered-data.c |    6 +++-
 fs/btrfs/super.c        |   23 ++----------------
 6 files changed, 13 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1111584..ae8c409 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -834,7 +834,6 @@ struct btrfs_fs_info {
 	u64 last_trans_log_full_commit;
 	u64 open_ioctl_trans;
 	unsigned long mount_opt;
-	u64 max_extent;
 	u64 max_inline;
 	u64 alloc_start;
 	struct btrfs_transaction *running_transaction;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 11d0ad3..dfe7a95 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1634,7 +1634,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->async_submit_draining, 0);
 	atomic_set(&fs_info->nr_async_bios, 0);
 	fs_info->sb = sb;
-	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 826120f..7bb97de 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2848,7 +2848,7 @@ int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
 	}
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
-	BTRFS_I(inode)->reserved_extents--;
+	BTRFS_I(inode)->reserved_extents -= num_items;
 	BUG_ON(BTRFS_I(inode)->reserved_extents < 0);
 
 	if (meta_sinfo->bytes_delalloc < num_bytes) {
@@ -3110,7 +3110,7 @@ again:
 		return -ENOSPC;
 	}
 
-	BTRFS_I(inode)->reserved_extents++;
+	BTRFS_I(inode)->reserved_extents += num_items;
 	check_force_delalloc(meta_sinfo);
 	spin_unlock(&meta_sinfo->lock);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2a337a0..a85b90c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -796,7 +796,7 @@ static noinline int cow_file_range(struct inode *inode,
 	while (disk_num_bytes > 0) {
 		unsigned long op;
 
-		cur_alloc_size = min(disk_num_bytes, root->fs_info->max_extent);
+		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
@@ -1227,30 +1227,9 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 static int btrfs_split_extent_hook(struct inode *inode,
 				    struct extent_state *orig, u64 split)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 size;
-
 	if (!(orig->state & EXTENT_DELALLOC))
 		return 0;
 
-	size = orig->end - orig->start + 1;
-	if (size > root->fs_info->max_extent) {
-		u64 num_extents;
-		u64 new_size;
-
-		new_size = orig->end - split + 1;
-		num_extents = div64_u64(size + root->fs_info->max_extent - 1,
-					root->fs_info->max_extent);
-
-		/*
-		 * if we break a large extent up then leave oustanding_extents
-		 * be, since we've already accounted for the large extent.
-		 */
-		if (div64_u64(new_size + root->fs_info->max_extent - 1,
-			      root->fs_info->max_extent) < num_extents)
-			return 0;
-	}
-
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	BTRFS_I(inode)->outstanding_extents++;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
@@ -1268,38 +1247,10 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 				   struct extent_state *new,
 				   struct extent_state *other)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 new_size, old_size;
-	u64 num_extents;
-
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
 		return 0;
 
-	old_size = other->end - other->start + 1;
-	if (new->start < other->start)
-		new_size = other->end - new->start + 1;
-	else
-		new_size = new->end - other->start + 1;
-
-	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= root->fs_info->max_extent) {
-		spin_lock(&BTRFS_I(inode)->accounting_lock);
-		BTRFS_I(inode)->outstanding_extents--;
-		spin_unlock(&BTRFS_I(inode)->accounting_lock);
-		return 0;
-	}
-
-	/*
-	 * If we grew by another max_extent, just return, we want to keep that
-	 * reserved amount.
-	 */
-	num_extents = div64_u64(old_size + root->fs_info->max_extent - 1,
-				root->fs_info->max_extent);
-	if (div64_u64(new_size + root->fs_info->max_extent - 1,
-		      root->fs_info->max_extent) > num_extents)
-		return 0;
-
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	BTRFS_I(inode)->outstanding_extents--;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
@@ -1328,6 +1279,7 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 		BTRFS_I(inode)->outstanding_extents++;
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
+
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += end - start + 1;
 		root->fs_info->delalloc_bytes += end - start + 1;
@@ -1356,6 +1308,7 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 
 		if (bits & EXTENT_DO_ACCOUNTING) {
 			spin_lock(&BTRFS_I(inode)->accounting_lock);
+			WARN_ON(!BTRFS_I(inode)->outstanding_extents);
 			BTRFS_I(inode)->outstanding_extents--;
 			spin_unlock(&BTRFS_I(inode)->accounting_lock);
 			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
@@ -5384,7 +5337,6 @@ free:
 void btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-
 	if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_item) == 0)
 		generic_delete_inode(inode);
 	else
@@ -5788,18 +5740,15 @@ static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
-	u64 alloc_size;
 	u64 cur_offset = start;
 	u64 num_bytes = end - start;
 	int ret = 0;
 	u64 i_size;
 
 	while (num_bytes > 0) {
-		alloc_size = min(num_bytes, root->fs_info->max_extent);
-
 		trans = btrfs_start_transaction(root, 1);
 
-		ret = btrfs_reserve_extent(trans, root, alloc_size,
+		ret = btrfs_reserve_extent(trans, root, num_bytes,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
 		if (ret) {
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a8ffecd..5c99882 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -303,6 +303,7 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct rb_node *node;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
@@ -312,12 +313,13 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
+	WARN_ON(!BTRFS_I(inode)->outstanding_extents);
 	BTRFS_I(inode)->outstanding_extents--;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 	btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->root,
 					      inode, 1);
 
-	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 
 	/*
@@ -329,7 +331,7 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
-	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_extent_lock);
 
 	return 0;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9ac612e..d11b12f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -64,10 +64,9 @@ static void btrfs_put_super(struct super_block *sb)
 
 enum {
 	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
-	Opt_nodatacow, Opt_max_extent, Opt_max_inline, Opt_alloc_start,
-	Opt_nobarrier, Opt_ssd, Opt_nossd, Opt_ssd_spread, Opt_thread_pool,
-	Opt_noacl, Opt_compress, Opt_compress_force, Opt_notreelog, Opt_ratio,
-	Opt_flushoncommit,
+	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
+	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
+	Opt_compress_force, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
 	Opt_discard, Opt_err,
 };
 
@@ -79,7 +78,6 @@ static match_table_t tokens = {
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_nodatacow, "nodatacow"},
 	{Opt_nobarrier, "nobarrier"},
-	{Opt_max_extent, "max_extent=%s"},
 	{Opt_max_inline, "max_inline=%s"},
 	{Opt_alloc_start, "alloc_start=%s"},
 	{Opt_thread_pool, "thread_pool=%d"},
@@ -188,18 +186,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				       info->thread_pool_size);
 			}
 			break;
-		case Opt_max_extent:
-			num = match_strdup(&args[0]);
-			if (num) {
-				info->max_extent = memparse(num, NULL);
-				kfree(num);
-
-				info->max_extent = max_t(u64,
-					info->max_extent, root->sectorsize);
-				printk(KERN_INFO "btrfs: max_extent at %llu\n",
-				       (unsigned long long)info->max_extent);
-			}
-			break;
 		case Opt_max_inline:
 			num = match_strdup(&args[0]);
 			if (num) {
@@ -529,9 +515,6 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nodatacow");
 	if (btrfs_test_opt(root, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
-	if (info->max_extent != (u64)-1)
-		seq_printf(seq, ",max_extent=%llu",
-			   (unsigned long long)info->max_extent);
 	if (info->max_inline != 8192 * 1024)
 		seq_printf(seq, ",max_inline=%llu",
 			   (unsigned long long)info->max_inline);
-- 
1.6.6

