Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6590 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbaJFS0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 14:26:09 -0400
Received: from pps.filterd (m0004346 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s96IOZJc023464
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Oct 2014 11:26:09 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1psx81vy5f-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 06 Oct 2014 11:26:08 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: rename do_chunk_alloc to btrfs_maybe_chunk_alloc
Date: Mon, 6 Oct 2014 14:26:05 -0400
Message-ID: <1412619965-4322-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already have btrfs_chunk_alloc, and that actually does the work to allocate
the chunk.  do_chunk_alloc would decide wether we really needed to allocate a
chunk or not, so rename it to btrfs_maybe_chunk_alloc.  Also change it to take
fs_info instead of root and fix all the callers since a root isn't needed.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/block-group.c | 83 +++++++++++++++++++++++++-------------------------
 fs/btrfs/block-group.h |  9 +++---
 fs/btrfs/block-rsv.c   |  6 ++--
 fs/btrfs/relocation.c  |  2 +-
 4 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 7ae5bd8..f2044ab 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1095,9 +1095,9 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
  * progress (either running or paused) picks the target profile (if it's
  * already available), otherwise falls back to plain reducing.
  */
-static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
+static u64 btrfs_reduce_alloc_profile(struct btrfs_fs_info *fs_info, u64 flags)
 {
-	u64 num_devices = root->fs_info->fs_devices->rw_devices;
+	u64 num_devices = fs_info->fs_devices->rw_devices;
 	u64 target;
 	u64 tmp;
 
@@ -1105,16 +1105,16 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	 * see if restripe for this chunk_type is in progress, if so
 	 * try to reduce to the target profile
 	 */
-	spin_lock(&root->fs_info->balance_lock);
-	target = get_restripe_target(root->fs_info, flags);
+	spin_lock(&fs_info->balance_lock);
+	target = get_restripe_target(fs_info, flags);
 	if (target) {
 		/* pick target profile only if it's already available */
 		if ((flags & target) & BTRFS_EXTENDED_PROFILE_MASK) {
-			spin_unlock(&root->fs_info->balance_lock);
+			spin_unlock(&fs_info->balance_lock);
 			return extended_to_chunk(target);
 		}
 	}
-	spin_unlock(&root->fs_info->balance_lock);
+	spin_unlock(&fs_info->balance_lock);
 
 	/* First, mask out the RAID levels which aren't possible */
 	if (num_devices == 1)
@@ -1144,24 +1144,24 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	return extended_to_chunk(flags | tmp);
 }
 
-static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags)
+static u64 get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
 {
 	unsigned seq;
 	u64 flags;
 
 	do {
 		flags = orig_flags;
-		seq = read_seqbegin(&root->fs_info->profiles_lock);
+		seq = read_seqbegin(&fs_info->profiles_lock);
 
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
-			flags |= root->fs_info->avail_data_alloc_bits;
+			flags |= fs_info->avail_data_alloc_bits;
 		else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-			flags |= root->fs_info->avail_system_alloc_bits;
+			flags |= fs_info->avail_system_alloc_bits;
 		else if (flags & BTRFS_BLOCK_GROUP_METADATA)
-			flags |= root->fs_info->avail_metadata_alloc_bits;
-	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
+			flags |= fs_info->avail_metadata_alloc_bits;
+	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
-	return btrfs_reduce_alloc_profile(root, flags);
+	return btrfs_reduce_alloc_profile(fs_info, flags);
 }
 
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
@@ -1176,7 +1176,7 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	else
 		flags = BTRFS_BLOCK_GROUP_METADATA;
 
-	ret = get_alloc_profile(root, flags);
+	ret = get_alloc_profile(root->fs_info, flags);
 	return ret;
 }
 
@@ -1239,9 +1239,9 @@ alloc:
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-					     alloc_target,
-					     CHUNK_ALLOC_NO_FORCE);
+			ret = btrfs_maybe_chunk_alloc(trans, root->fs_info,
+						      alloc_target,
+						      CHUNK_ALLOC_NO_FORCE);
 			btrfs_end_transaction(trans, root);
 			if (ret < 0) {
 				if (ret != -ENOSPC)
@@ -1326,10 +1326,10 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
-static int should_alloc_chunk(struct btrfs_root *root,
+static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 			      struct btrfs_space_info *sinfo, int force)
 {
-	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
 	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved;
 	u64 thresh;
@@ -1350,7 +1350,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	 * about 1% of the FS size.
 	 */
 	if (force == CHUNK_ALLOC_LIMITED) {
-		thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
+		thresh = btrfs_super_total_bytes(fs_info->super_copy);
 		thresh = max_t(u64, 64 * 1024 * 1024,
 			       div_factor_fine(thresh, 1));
 
@@ -1409,11 +1409,11 @@ static void check_system_chunk(struct btrfs_trans_handle *trans,
 	}
 }
 
-int do_chunk_alloc(struct btrfs_trans_handle *trans,
-		   struct btrfs_root *extent_root, u64 flags, int force)
+int btrfs_maybe_chunk_alloc(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info, u64 flags,
+			    enum btrfs_chunk_alloc_policy force)
 {
 	struct btrfs_space_info *space_info;
-	struct btrfs_fs_info *fs_info = extent_root->fs_info;
 	int wait_for_alloc = 0;
 	int ret = 0;
 
@@ -1421,9 +1421,9 @@ int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	if (trans->allocating_chunk)
 		return -ENOSPC;
 
-	space_info = __find_space_info(extent_root->fs_info, flags);
+	space_info = __find_space_info(fs_info, flags);
 	if (!space_info) {
-		ret = update_space_info(extent_root->fs_info, flags,
+		ret = update_space_info(fs_info, flags,
 					0, 0, &space_info);
 		BUG_ON(ret); /* -ENOMEM */
 	}
@@ -1434,7 +1434,7 @@ again:
 	if (force < space_info->force_alloc)
 		force = space_info->force_alloc;
 	if (space_info->full) {
-		if (should_alloc_chunk(extent_root, space_info, force))
+		if (should_alloc_chunk(fs_info, space_info, force))
 			ret = -ENOSPC;
 		else
 			ret = 0;
@@ -1442,7 +1442,7 @@ again:
 		return ret;
 	}
 
-	if (!should_alloc_chunk(extent_root, space_info, force)) {
+	if (!should_alloc_chunk(fs_info, space_info, force)) {
 		spin_unlock(&space_info->lock);
 		return 0;
 	} else if (space_info->chunk_alloc) {
@@ -1492,9 +1492,9 @@ again:
 	 * Check if we have enough space in SYSTEM chunk because we may need
 	 * to update devices.
 	 */
-	check_system_chunk(trans, extent_root, flags);
+	check_system_chunk(trans, fs_info->extent_root, flags);
 
-	ret = btrfs_alloc_chunk(trans, extent_root, flags);
+	ret = btrfs_alloc_chunk(trans, fs_info->extent_root, flags);
 	trans->allocating_chunk = false;
 
 	spin_lock(&space_info->lock);
@@ -2585,8 +2585,9 @@ loop:
 				goto out;
 			}
 
-			ret = do_chunk_alloc(trans, root, flags,
-					     CHUNK_ALLOC_FORCE);
+			ret = btrfs_maybe_chunk_alloc(trans, root->fs_info,
+						      flags,
+						      CHUNK_ALLOC_FORCE);
 			/*
 			 * Do not bail out on ENOSPC since we
 			 * can do more things.
@@ -2847,8 +2848,8 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 
 	alloc_flags = update_block_group_flags(root, cache->flags);
 	if (alloc_flags != cache->flags) {
-		ret = do_chunk_alloc(trans, root, alloc_flags,
-				     CHUNK_ALLOC_FORCE);
+		ret = btrfs_maybe_chunk_alloc(trans, root->fs_info,
+					      alloc_flags, CHUNK_ALLOC_FORCE);
 		if (ret < 0)
 			goto out;
 	}
@@ -2856,9 +2857,9 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 	ret = set_block_group_ro(cache, 0);
 	if (!ret)
 		goto out;
-	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
-	ret = do_chunk_alloc(trans, root, alloc_flags,
-			     CHUNK_ALLOC_FORCE);
+	alloc_flags = get_alloc_profile(root->fs_info, cache->space_info->flags);
+	ret = btrfs_maybe_chunk_alloc(trans, root->fs_info, alloc_flags,
+				      CHUNK_ALLOC_FORCE);
 	if (ret < 0)
 		goto out;
 	ret = set_block_group_ro(cache, 0);
@@ -2868,11 +2869,11 @@ out:
 }
 
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 type)
+			    struct btrfs_fs_info *fs_info, u64 type)
 {
-	u64 alloc_flags = get_alloc_profile(root, type);
-	return do_chunk_alloc(trans, root, alloc_flags,
-			      CHUNK_ALLOC_FORCE);
+	u64 alloc_flags = get_alloc_profile(fs_info, type);
+	return btrfs_maybe_chunk_alloc(trans, fs_info, alloc_flags,
+				       CHUNK_ALLOC_FORCE);
 }
 
 /*
@@ -3469,7 +3470,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	}
 
 	list_for_each_entry_rcu(space_info, &root->fs_info->space_info, list) {
-		if (!(get_alloc_profile(root, space_info->flags) &
+		if (!(get_alloc_profile(info, space_info->flags) &
 		      (BTRFS_BLOCK_GROUP_RAID10 |
 		       BTRFS_BLOCK_GROUP_RAID1 |
 		       BTRFS_BLOCK_GROUP_RAID5 |
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 105a00e..5dc4514 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -34,7 +34,7 @@
  * CHUNK_ALLOC_FORCE means it must try to allocate one
  *
  */
-enum {
+enum btrfs_chunk_alloc_policy {
 	CHUNK_ALLOC_NO_FORCE = 0,
 	CHUNK_ALLOC_LIMITED = 1,
 	CHUNK_ALLOC_FORCE = 2,
@@ -184,8 +184,6 @@ struct btrfs_block_group_cache {
 	struct list_head bg_list;
 };
 
-int do_chunk_alloc(struct btrfs_trans_handle *trans,
-		   struct btrfs_root *extent_root, u64 flags, int force);
 void add_pinned_bytes(struct btrfs_fs_info *fs_info, u64 num_bytes,
 		      u64 owner, u64 root_objectid);
 int update_block_group(struct btrfs_root *root,
@@ -226,8 +224,11 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root,
 				   u64 start, u64 end);
 int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
 			       u64 num_bytes, u64 *actual_bytes);
+int btrfs_maybe_chunk_alloc(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info, u64 flags,
+			    enum btrfs_chunk_alloc_policy force);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 type);
+			    struct btrfs_fs_info *fs_info, u64 type);
 int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range);
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len,
 			       int delalloc);
diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index f804a65..c4bf1e6 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -342,9 +342,9 @@ static int flush_space(struct btrfs_root *root,
 			ret = PTR_ERR(trans);
 			break;
 		}
-		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     btrfs_get_alloc_profile(root, 0),
-				     CHUNK_ALLOC_NO_FORCE);
+		ret = btrfs_maybe_chunk_alloc(trans, root->fs_info,
+					      btrfs_get_alloc_profile(root, 0),
+					      CHUNK_ALLOC_NO_FORCE);
 		btrfs_end_transaction(trans, root);
 		if (ret == -ENOSPC)
 			ret = 0;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0fa7a75..9a3e657 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4054,7 +4054,7 @@ restart:
 		}
 	}
 	if (trans && progress && err == -ENOSPC) {
-		ret = btrfs_force_chunk_alloc(trans, rc->extent_root,
+		ret = btrfs_force_chunk_alloc(trans, rc->extent_root->fs_info,
 					      rc->block_group->flags);
 		if (ret == 0) {
 			err = 0;
-- 
1.8.3.1

