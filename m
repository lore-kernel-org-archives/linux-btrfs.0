Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57973 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbeC0Suw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:50:52 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E1857AC98
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:50:50 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: use lockdep_assert_held for mutexes
Date: Tue, 27 Mar 2018 20:48:25 +0200
Message-Id: <53a7766bfd236c6f795a18423f6b4c0583ab2c3a.1522176187.git.dsterba@suse.com>
In-Reply-To: <cover.1522176187.git.dsterba@suse.com>
References: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using lockdep_assert_held is preferred, replace mutex_is_locked.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/scrub.c       |  4 ++--
 fs/btrfs/volumes.c     | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c1618ab9fecf..4116fb20b1af 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4542,7 +4542,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 	 * Needed because we can end up allocating a system chunk and for an
 	 * atomic and race free space reservation in the chunk block reserve.
 	 */
-	ASSERT(mutex_is_locked(&fs_info->chunk_mutex));
+	lockdep_assert_held(&fs_info->chunk_mutex);
 
 	info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
 	spin_lock(&info->lock);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ec56f33feea9..9cfbccdeacf3 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -371,7 +371,7 @@ static struct full_stripe_lock *insert_full_stripe_lock(
 	struct full_stripe_lock *entry;
 	struct full_stripe_lock *ret;
 
-	WARN_ON(!mutex_is_locked(&locks_root->lock));
+	lockdep_assert_held(&locks_root->lock);
 
 	p = &locks_root->root.rb_node;
 	while (*p) {
@@ -413,7 +413,7 @@ static struct full_stripe_lock *search_full_stripe_lock(
 	struct rb_node *node;
 	struct full_stripe_lock *entry;
 
-	WARN_ON(!mutex_is_locked(&locks_root->lock));
+	lockdep_assert_held(&locks_root->lock);
 
 	node = locks_root->root.rb_node;
 	while (node) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b2d05c6b1c56..350c12f1f19e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2047,7 +2047,7 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_fs_devices *fs_devices;
 
-	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
+	lockdep_assert_held(&fs_info->fs_devices->device_list_mutex);
 
 	/*
 	 * in case of fs with no seed, srcdev->fs_devices will point
@@ -2237,7 +2237,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	struct btrfs_device *device;
 	u64 super_flags;
 
-	BUG_ON(!mutex_is_locked(&uuid_mutex));
+	lockdep_assert_held(&uuid_mutex);
 	if (!fs_devices->seeding)
 		return -EINVAL;
 
@@ -2984,7 +2984,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	 * we release the path used to search the chunk/dev tree and before
 	 * the current task acquires this mutex and calls us.
 	 */
-	ASSERT(mutex_is_locked(&fs_info->delete_unused_bgs_mutex));
+	lockdep_assert_held(&fs_info->delete_unused_bgs_mutex);
 
 	ret = btrfs_can_relocate(fs_info, chunk_offset);
 	if (ret)
@@ -5068,7 +5068,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 {
 	u64 chunk_offset;
 
-	ASSERT(mutex_is_locked(&fs_info->chunk_mutex));
+	lockdep_assert_held(&fs_info->chunk_mutex);
 	chunk_offset = find_next_chunk(fs_info);
 	return __btrfs_alloc_chunk(trans, chunk_offset, type);
 }
@@ -6618,7 +6618,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 	struct btrfs_fs_devices *fs_devices;
 	int ret;
 
-	BUG_ON(!mutex_is_locked(&uuid_mutex));
+	lockdep_assert_held(&uuid_mutex);
 	ASSERT(fsid);
 
 	fs_devices = fs_info->fs_devices->seed;
-- 
2.16.2

