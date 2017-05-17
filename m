Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750969AbdEQPiT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:38:19 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F7A8AC56
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 15:38:18 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs: cleanup root usage by btrfs_get_alloc_profile
Date: Wed, 17 May 2017 11:38:35 -0400
Message-Id: <1495035516-3217-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1495035516-3217-1-git-send-email-jeffm@suse.com>
References: <1495035516-3217-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

There are two places where we don't already know what kind of alloc
profile we need before calling btrfs_get_alloc_profile, but we need
access to a root everywhere we call it.

This patch adds helpers for btrfs_{data,metadata,system}_alloc_profile()
and relegates btrfs_system_alloc_profile to a static for use in those
two cases.  The next patch will eliminate one of those.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |  4 +++-
 fs/btrfs/extent-tree.c | 28 +++++++++++++++++++++-------
 fs/btrfs/inode.c       |  3 +--
 fs/btrfs/super.c       |  3 +--
 fs/btrfs/volumes.c     |  5 ++---
 5 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 519f3a15..f732a4c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2670,7 +2670,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *cache);
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 				       struct btrfs_fs_info *fs_info);
-u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
+u64 btrfs_data_alloc_profile(struct btrfs_fs_info *fs_info);
+u64 btrfs_metadata_alloc_profile(struct btrfs_fs_info *fs_info);
+u64 btrfs_system_alloc_profile(struct btrfs_fs_info *fs_info);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
 enum btrfs_reserve_flush_enum {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9894c4e..cc941fe 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4110,7 +4110,7 @@ static u64 get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
 	return btrfs_reduce_alloc_profile(fs_info, flags);
 }
 
-u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
+static u64 get_alloc_profile_by_root(struct btrfs_root *root, int data)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 flags;
@@ -4127,6 +4127,21 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	return ret;
 }
 
+u64 btrfs_data_alloc_profile(struct btrfs_fs_info *fs_info)
+{
+	return get_alloc_profile(fs_info, BTRFS_BLOCK_GROUP_DATA);
+}
+
+u64 btrfs_metadata_alloc_profile(struct btrfs_fs_info *fs_info)
+{
+	return get_alloc_profile(fs_info, BTRFS_BLOCK_GROUP_METADATA);
+}
+
+u64 btrfs_system_alloc_profile(struct btrfs_fs_info *fs_info)
+{
+	return get_alloc_profile(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+}
+
 static u64 btrfs_space_info_used(struct btrfs_space_info *s_info,
 				 bool may_use_included)
 {
@@ -4176,7 +4191,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 			data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
 			spin_unlock(&data_sinfo->lock);
 alloc:
-			alloc_target = btrfs_get_alloc_profile(root, 1);
+			alloc_target = btrfs_data_alloc_profile(fs_info);
 			/*
 			 * It is ugly that we don't call nolock join
 			 * transaction for the free space inode case here.
@@ -4452,9 +4467,8 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	if (left < thresh) {
-		u64 flags;
+		u64 flags = btrfs_system_alloc_profile(fs_info);
 
-		flags = btrfs_get_alloc_profile(fs_info->chunk_root, 0);
 		/*
 		 * Ignore failure to create system chunk. We might end up not
 		 * needing it, as we might not need to COW all nodes/leafs from
@@ -4618,7 +4632,7 @@ static int can_overcommit(struct btrfs_root *root,
 	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
 		return 0;
 
-	profile = btrfs_get_alloc_profile(root, 0);
+	profile = get_alloc_profile_by_root(root, 0);
 	used = btrfs_space_info_used(space_info, false);
 
 	/*
@@ -4885,7 +4899,7 @@ static int flush_space(struct btrfs_fs_info *fs_info,
 			break;
 		}
 		ret = do_chunk_alloc(trans, fs_info,
-				     btrfs_get_alloc_profile(root, 0),
+				     btrfs_metadata_alloc_profile(fs_info),
 				     CHUNK_ALLOC_NO_FORCE);
 		btrfs_end_transaction(trans);
 		if (ret > 0 || ret == -ENOSPC)
@@ -7945,7 +7959,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	u64 flags;
 	int ret;
 
-	flags = btrfs_get_alloc_profile(root, is_data);
+	flags = get_alloc_profile_by_root(root, is_data);
 again:
 	WARN_ON(num_bytes < fs_info->sectorsize);
 	ret = find_free_extent(fs_info, ram_bytes, num_bytes, empty_size,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e71f1e..35b68fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8324,7 +8324,6 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 {
 	struct inode *inode = dip->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
 	struct bio_vec *bvec;
@@ -8351,7 +8350,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	}
 
 	/* async crcs make it difficult to collect full stripe writes. */
-	if (btrfs_get_alloc_profile(root, 1) & BTRFS_BLOCK_GROUP_RAID56_MASK)
+	if (btrfs_data_alloc_profile(fs_info) & BTRFS_BLOCK_GROUP_RAID56_MASK)
 		async_submit = 0;
 	else
 		async_submit = 1;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e2315c0..fbc628a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1893,7 +1893,6 @@ static inline void btrfs_descending_sort_devices(
 static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 				       u64 *free_bytes)
 {
-	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
@@ -1927,7 +1926,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 
 	/* calc min stripe number for data space allocation */
-	type = btrfs_get_alloc_profile(root, 1);
+	type = btrfs_data_alloc_profile(fs_info);
 	if (type & BTRFS_BLOCK_GROUP_RAID0) {
 		min_stripes = 2;
 		num_stripes = nr_devices;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ab8a66d..fa10c80 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5015,20 +5015,19 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *extent_root = fs_info->extent_root;
 	u64 chunk_offset;
 	u64 sys_chunk_offset;
 	u64 alloc_profile;
 	int ret;
 
 	chunk_offset = find_next_chunk(fs_info);
-	alloc_profile = btrfs_get_alloc_profile(extent_root, 0);
+	alloc_profile = btrfs_metadata_alloc_profile(fs_info);
 	ret = __btrfs_alloc_chunk(trans, chunk_offset, alloc_profile);
 	if (ret)
 		return ret;
 
 	sys_chunk_offset = find_next_chunk(fs_info);
-	alloc_profile = btrfs_get_alloc_profile(fs_info->chunk_root, 0);
+	alloc_profile = btrfs_system_alloc_profile(fs_info);
 	ret = __btrfs_alloc_chunk(trans, sys_chunk_offset, alloc_profile);
 	return ret;
 }
-- 
1.8.5.6

