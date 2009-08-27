From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: account for space used by the super mirrors
Date: Thu, 27 Aug 2009 15:03:25 -0400
Message-ID: <20090827190325.GA13924@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As we get closer to proper -ENOSPC handling in btrfs, we need more accurate
space accounting for the space info's.  Currently we exclude the free space for
the super mirrors, but the space they take up isn't accounted for in any of the
counters.  This patch introduces bytes_super, which keeps track of the amount of
bytes used for a super mirror in the block group cache and space info.  This
makes sure that our free space caclucations will be completely accurate.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    2 ++
 fs/btrfs/extent-tree.c |   20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index db02e26..ef3e426 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -672,6 +672,7 @@ struct btrfs_space_info {
 	u64 bytes_reserved;	/* total bytes the allocator has reserved for
 				   current allocations */
 	u64 bytes_readonly;	/* total bytes that are read only */
+	u64 bytes_super;	/* total bytes reserved for the super blocks */
 
 	/* delalloc accounting */
 	u64 bytes_delalloc;	/* number of bytes reserved for allocation,
@@ -744,6 +745,7 @@ struct btrfs_block_group_cache {
 	spinlock_t lock;
 	u64 pinned;
 	u64 reserved;
+	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
 	int extents_thresh;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 92bc72e..3ea1f8c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -201,6 +201,7 @@ static int exclude_super_stripes(struct btrfs_root *root,
 		BUG_ON(ret);
 
 		while (nr--) {
+			cache->bytes_super += stripe_len;
 			ret = add_excluded_extent(root, logical[nr],
 						  stripe_len);
 			BUG_ON(ret);
@@ -295,6 +296,9 @@ static int caching_kthread(void *data)
 		return -ENOMEM;
 
 	exclude_super_stripes(extent_root, block_group);
+	spin_lock(&block_group->space_info->lock);
+	block_group->space_info->bytes_super += block_group->bytes_super;
+	spin_unlock(&block_group->space_info->lock);
 
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 
@@ -2785,7 +2789,8 @@ again:
 	do_div(thresh, 100);
 
 	if (meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-	    meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly > thresh) {
+	    meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
+	    meta_sinfo->bytes_super > thresh) {
 		struct btrfs_trans_handle *trans;
 		if (!meta_sinfo->full) {
 			meta_sinfo->force_alloc = 1;
@@ -2839,7 +2844,7 @@ again:
 	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
 	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
 	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
-	    data_sinfo->bytes_may_use < bytes) {
+	    data_sinfo->bytes_may_use - data_sinfo->bytes_super < bytes) {
 		struct btrfs_trans_handle *trans;
 
 		/*
@@ -6794,8 +6799,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		 * time, particularly in the full case.
 		 */
 		if (found_key.offset == btrfs_block_group_used(&cache->item)) {
+			exclude_super_stripes(root, cache);
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
+			free_excluded_extents(root, cache);
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
 			exclude_super_stripes(root, cache);
 			cache->last_byte_to_unpin = (u64)-1;
@@ -6812,6 +6819,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 					&space_info);
 		BUG_ON(ret);
 		cache->space_info = space_info;
+		spin_lock(&cache->space_info->lock);
+		cache->space_info->bytes_super += cache->bytes_super;
+		spin_unlock(&cache->space_info->lock);
+
 		down_write(&space_info->groups_sem);
 		list_add_tail(&cache->list, &space_info->block_groups);
 		up_write(&space_info->groups_sem);
@@ -6881,6 +6892,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
+
+	spin_lock(&cache->space_info->lock);
+	cache->space_info->bytes_super += cache->bytes_super;
+	spin_unlock(&cache->space_info->lock);
+
 	down_write(&cache->space_info->groups_sem);
 	list_add_tail(&cache->list, &cache->space_info->block_groups);
 	up_write(&cache->space_info->groups_sem);
-- 
1.5.4.3

