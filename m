Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18213 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3DYKNy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 06:13:54 -0400
Message-ID: <51790196.6040606@cn.fujitsu.com>
Date: Thu, 25 Apr 2013 18:12:38 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>, Jim Schutt <jaschut@sandia.gov>
Subject: [PATCH] Btrfs: allocate new chunks if the space is not enough for
 global rsv
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running the 208th of xfstests, the fs returned the enospc
error when there was lots of free space in the disk.

By bisect debug, we found it was introduced by commit 96f1bb5777.
This commit makes the space check for the global reservation in
can_overcommit() be inconsistent with should_alloc_chunk().
can_overcommit() requires that the free space is 2 times the size
of the global reservation, or we can't do overcommit. And instead,
we need reclaim some reserved space, and if we still don't have
enough free space, we need allocate a new chunk. But unfortunately,
should_alloc_chunk() just requires that the free space is 1 time
the size of the global reservation, that is we would not try to
allocate a new chunk if the free space size is in the middle of
these two requires, and just return the enospc error. Fix it.

Cc: Jim Schutt <jaschut@sandia.gov>
Cc: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d84787..4976f93 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3557,6 +3557,11 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
+static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
+{
+	return (global->size << 1);
+}
+
 static int should_alloc_chunk(struct btrfs_root *root,
 			      struct btrfs_space_info *sinfo, int force)
 {
@@ -3574,7 +3579,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	 * global_rsv, it doesn't change except when the transaction commits.
 	 */
 	if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA)
-		num_allocated += global_rsv->size;
+		num_allocated += calc_global_rsv_need_space(global_rsv);
 
 	/*
 	 * in limited mode, we want to have some free space up to
@@ -3746,7 +3751,7 @@ static int can_overcommit(struct btrfs_root *root,
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	u64 profile = btrfs_get_alloc_profile(root, 0);
-	u64 rsv_size = 0;
+	u64 space_size;
 	u64 avail;
 	u64 used;
 	u64 to_add;
@@ -3754,18 +3759,16 @@ static int can_overcommit(struct btrfs_root *root,
 	used = space_info->bytes_used + space_info->bytes_reserved +
 		space_info->bytes_pinned + space_info->bytes_readonly;
 
-	spin_lock(&global_rsv->lock);
-	rsv_size = global_rsv->size;
-	spin_unlock(&global_rsv->lock);
-
 	/*
 	 * We only want to allow over committing if we have lots of actual space
 	 * free, but if we don't have enough space to handle the global reserve
 	 * space then we could end up having a real enospc problem when trying
 	 * to allocate a chunk or some other such important allocation.
 	 */
-	rsv_size <<= 1;
-	if (used + rsv_size >= space_info->total_bytes)
+	spin_lock(&global_rsv->lock);
+	space_size = calc_global_rsv_need_space(global_rsv);
+	spin_unlock(&global_rsv->lock);
+	if (used + space_size >= space_info->total_bytes)
 		return 0;
 
 	used += space_info->bytes_may_use;
-- 
1.8.0.1
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
