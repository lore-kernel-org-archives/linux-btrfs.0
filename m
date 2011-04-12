From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: avoid taking the chunk_mutex in do_chunk_alloc
Date: Mon, 11 Apr 2011 20:30:24 -0400
Message-ID: <1302568224-4567-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Everytime we try to allocate disk space we try and see if we can pre-emptively
allocate a chunk, but in the common case we don't allocate anything, so there is
no sense in taking the chunk_mutex at all.  So instead if we are allocating a
chunk, mark it in the space_info so we don't get two people trying to allocate
at the same time.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    5 +++--
 fs/btrfs/extent-tree.c |   24 ++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d00a07..a566780 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -740,10 +740,11 @@ struct btrfs_space_info {
 	 */
 	unsigned long reservation_progress;
 
-	int full;		/* indicates that we cannot allocate any more
+	int full:1;		/* indicates that we cannot allocate any more
 				   chunks for this space */
-	int force_alloc;	/* set if we need to force a chunk alloc for
+	int force_alloc:1;	/* set if we need to force a chunk alloc for
 				   this space */
+	int chunk_alloc:1;	/* set if we are allocating a chunk */
 
 	struct list_head list;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f619c3c..80c048f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3020,6 +3020,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->bytes_may_use = 0;
 	found->full = 0;
 	found->force_alloc = 0;
+	found->chunk_alloc = 0;
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
@@ -3273,10 +3274,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_info *fs_info = extent_root->fs_info;
+	int wait_for_alloc = 0;
 	int ret = 0;
 
-	mutex_lock(&fs_info->chunk_mutex);
-
 	flags = btrfs_reduce_alloc_profile(extent_root, flags);
 
 	space_info = __find_space_info(extent_root->fs_info, flags);
@@ -3287,6 +3287,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	}
 	BUG_ON(!space_info);
 
+again:
 	spin_lock(&space_info->lock);
 	if (space_info->force_alloc)
 		force = 1;
@@ -3299,9 +3300,27 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 					  alloc_bytes)) {
 		spin_unlock(&space_info->lock);
 		goto out;
+	} else if (space_info->chunk_alloc) {
+		wait_for_alloc = 1;
+	} else {
+		space_info->chunk_alloc = 1;
 	}
 	spin_unlock(&space_info->lock);
 
+	mutex_lock(&fs_info->chunk_mutex);
+
+	/*
+	 * The chunk_mutex is held throughout the entirety of a chunk
+	 * allocation, so once we've acquired the chunk_mutex we know that the
+	 * other guy is done and we need to recheck and see if we should
+	 * allocate.
+	 */
+	if (wait_for_alloc) {
+		mutex_unlock(&fs_info->chunk_mutex);
+		wait_for_alloc = 0;
+		goto again;
+	}
+
 	/*
 	 * If we have mixed data/metadata chunks we want to make sure we keep
 	 * allocating mixed chunks instead of individual chunks.
@@ -3327,6 +3346,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 		space_info->full = 1;
 	else
 		ret = 1;
+	space_info->chunk_alloc = 0;
 	space_info->force_alloc = 0;
 	spin_unlock(&space_info->lock);
 out:
-- 
1.7.2.3

