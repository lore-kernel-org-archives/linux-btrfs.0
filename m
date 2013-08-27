Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56322 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3H0PxP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 11:53:15 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CE0057C069F
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 09:53:14 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <alex.btrfs@zadarastorage.com>
Subject: [PATCH] Btrfs: handle errors when doing slow caching V2
Date: Tue, 27 Aug 2013 11:53:09 -0400
Message-ID: <1377618789-3052-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alex Lyakas reported a bug where wait_block_group_cache_progress() would wait
forever if a drive failed.  This is because we just bail out if there is an
error while trying to cache a block group, we don't update anybody who may be
waiting.  So this introduces a new enum for the cache state in case of error and
makes everybody bail out if we have an error.  Alex tested and verified this
patch fixed his problem.  This fixes bz 59431.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: return an error in wait_block_group_cache_done if there is no caching
ctl and we have BTRFS_CACHE_ERROR set.

 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/extent-tree.c |   32 +++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cbb1263..c17acbc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1188,6 +1188,7 @@ enum btrfs_caching_type {
 	BTRFS_CACHE_STARTED	= 1,
 	BTRFS_CACHE_FAST	= 2,
 	BTRFS_CACHE_FINISHED	= 3,
+	BTRFS_CACHE_ERROR	= 4,
 };
 
 enum btrfs_disk_cache_state {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e868c35..a073f3e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -113,7 +113,8 @@ static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
 	smp_mb();
-	return cache->cached == BTRFS_CACHE_FINISHED;
+	return cache->cached == BTRFS_CACHE_FINISHED ||
+		cache->cached == BTRFS_CACHE_ERROR;
 }
 
 static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
@@ -389,7 +390,7 @@ static noinline void caching_thread(struct btrfs_work *work)
 	u64 total_found = 0;
 	u64 last = 0;
 	u32 nritems;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	caching_ctl = container_of(work, struct btrfs_caching_control, work);
 	block_group = caching_ctl->block_group;
@@ -517,6 +518,12 @@ err:
 
 	mutex_unlock(&caching_ctl->mutex);
 out:
+	if (ret) {
+		spin_lock(&block_group->lock);
+		block_group->caching_ctl = NULL;
+		block_group->cached = BTRFS_CACHE_ERROR;
+		spin_unlock(&block_group->lock);
+	}
 	wake_up(&caching_ctl->wait);
 
 	put_caching_control(caching_ctl);
@@ -6035,8 +6042,11 @@ static u64 stripe_align(struct btrfs_root *root,
  * for our min num_bytes.  Another option is to have it go ahead
  * and look in the rbtree for a free extent of a given size, but this
  * is a good start.
+ *
+ * Callers of this must check if cache->cached == BTRFS_CACHE_ERROR before using
+ * any of the information in this block group.
  */
-static noinline int
+static noinline void
 wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 				u64 num_bytes)
 {
@@ -6044,28 +6054,29 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
-		return 0;
+		return;
 
 	wait_event(caching_ctl->wait, block_group_cache_done(cache) ||
 		   (cache->free_space_ctl->free_space >= num_bytes));
 
 	put_caching_control(caching_ctl);
-	return 0;
 }
 
 static noinline int
 wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_caching_control *caching_ctl;
+	int ret = 0;
 
 	caching_ctl = get_caching_control(cache);
 	if (!caching_ctl)
-		return 0;
+		return (cache->cached == BTRFS_CACHE_ERROR) ? -EIO : 0;
 
 	wait_event(caching_ctl->wait, block_group_cache_done(cache));
-
+	if (cache->cached == BTRFS_CACHE_ERROR)
+		ret = -EIO;
 	put_caching_control(caching_ctl);
-	return 0;
+	return ret;
 }
 
 int __get_raid_index(u64 flags)
@@ -6248,6 +6259,8 @@ have_block_group:
 			ret = 0;
 		}
 
+		if (unlikely(block_group->cached == BTRFS_CACHE_ERROR))
+			goto loop;
 		if (unlikely(block_group->ro))
 			goto loop;
 
@@ -8230,7 +8243,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		 * We haven't cached this block group, which means we could
 		 * possibly have excluded extents on this block group.
 		 */
-		if (block_group->cached == BTRFS_CACHE_NO)
+		if (block_group->cached == BTRFS_CACHE_NO ||
+		    block_group->cached == BTRFS_CACHE_ERROR)
 			free_excluded_extents(info->extent_root, block_group);
 
 		btrfs_remove_free_space_cache(block_group);
-- 
1.7.7.6

