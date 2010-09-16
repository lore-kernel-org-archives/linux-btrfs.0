From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add support for mixed data+metadata block groups
Date: Thu, 16 Sep 2010 16:20:55 -0400
Message-ID: <1284668455-20634-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are just a few things that need to be fixed in the kernel to support mixed
data+metadata block groups.  Mostly we just need to make sure that if we are
using mixed block groups that we continue to allocate mixed block groups as we
need them.  Also we need to make sure __find_space_info will find our space info
if we search for DATA or METADATA only.  Tested this with xfstests and it works
nicely.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 91a0a41..c0a9ad3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -547,7 +547,7 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags == flags) {
+		if (found->flags & flags) {
 			rcu_read_unlock();
 			return found;
 		}
@@ -3267,6 +3267,13 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	spin_unlock(&space_info->lock);
 
 	/*
+	 * If we have mixed data/metadata chunks we want to make sure we keep
+	 * allocating mixed chunks instead of individual chunks.
+	 */
+	if (space_info->flags != flags)
+		flags = space_info->flags;
+
+	/*
 	 * if we're doing a data chunk, go ahead and make sure that
 	 * we keep a reasonable number of metadata chunks allocated in the
 	 * FS as well.
@@ -4793,6 +4800,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
+	bool use_cluster = true;
 	u64 ideal_cache_percent = 0;
 	u64 ideal_cache_offset = 0;
 
@@ -4807,16 +4815,26 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		return -ENOSPC;
 	}
 
+	/*
+	 * If the space info is for both data and metadata it means we have a
+	 * small filesystem and we can't use the clustering stuff.
+	 */
+	if ((space_info->flags & (BTRFS_BLOCK_GROUP_METADATA |
+				  BTRFS_BLOCK_GROUP_DATA)) ==
+	   ((BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA)))
+		use_cluster = false;
+
 	if (orig_root->ref_cows || empty_size)
 		allowed_chunk_alloc = 1;
 
-	if (data & BTRFS_BLOCK_GROUP_METADATA) {
+	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
 		last_ptr = &root->fs_info->meta_alloc_cluster;
 		if (!btrfs_test_opt(root, SSD))
 			empty_cluster = 64 * 1024;
 	}
 
-	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD)) {
+	if ((data & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
+	    btrfs_test_opt(root, SSD)) {
 		last_ptr = &root->fs_info->data_alloc_cluster;
 	}
 
-- 
1.6.6.1

