Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64183 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753517AbbGQJ5I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 05:57:08 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6H9tJUF011066
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 17:55:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] [RFC] btrfs: Avoid using single-type chunk on degree mode
Date: Fri, 17 Jul 2015 17:55:30 +0800
Message-ID: <235d36018fd877b09cfc9f3d4e2fd32ef5d43cde.1437126914.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

We can get mount-fail in following operation:
  # mkfs a raid1 filesystem
  mkfs.btrfs -f -d raid1 -m raid1 /dev/vdd /dev/vde

  # destroy a disk
  dd if=/dev/zero of=/dev/vde bs=1M count=1

  # do some fs operation on degraded mode
  mount -o degraded /dev/vdd /mnt/test
  touch /mnt/test/123
  rm -f /mnt/test/123
  sync
  umount /mnt/test

  # mount fs again
  mount -o degraded /dev/vdd  /mnt/test

Above mount will output following error message:
  mount: wrong fs type, bad option, bad superblock on /dev/vdd,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
With following dmesg:
  [  127.912406] BTRFS: too many missing devices(1 > 0), writeable mount is not allowed
  [  127.918128] BTRFS: open_ctree failed

Reason:
  When we do fs operation in degraded fs, btrfs_reduce_alloc_profile()
  have possibility to clean all existing raid mode flag because
  no-enouth-disk, and return a all-zero raid flag, and use this flag
  to do find_free_extent(), then write data into single-type chunk.

  In current version of mkfs, we have 3 single-type chunks in init,
  data will write to above chunks first.
  And for mkfs after Qu Wenruo <quwenruo@cn.fujitsu.com>'s patch
  to avoid creating above 3 single-type init chunks, find_free_extent()
  will create these chunks.

  And, because filesystem have data in single-mode chunks,
  btrfs_calc_num_tolerated_disk_barrier_failures() will return 0,
  it is to say, loss-one-disk fs is not allowed to mount,
  and caused above mount fail.

Fix:
  This problem is caused by multi-reason, but the main reason may
  be: we can't write data into sinele-mode chunk in degraded mode,
  except filesystem is created with single.

  This patch add a condition before find_free_extent(), if the
  filesystem is not created with single-mode(have other raid mode),
  we forbid write new datas to single chunks.

Fix result:
  This patch fixed above bug, but we can not write any data into
  filesystem in above degraded mount.
  (data write to single-mode chunk before patch)

  It is different with old style, which is better?
  (allow or not allow to write into single-mode chunk)?

  Or we have another better way to fix this bug?

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  3 ++-
 fs/btrfs/extent-tree.c | 60 +++++++++++++++++++++++++++++++++-----------------
 fs/btrfs/inode.c       |  3 ++-
 fs/btrfs/super.c       |  2 +-
 fs/btrfs/volumes.c     |  4 ++--
 5 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3b69324..11a5c4a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3439,7 +3439,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 				       struct btrfs_root *root);
-u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
+u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data,
+			    int no_device_reduce);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
 enum btrfs_reserve_flush_enum {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1c2bd17..3cdbb1c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3737,7 +3737,8 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
  * progress (either running or paused) picks the target profile (if it's
  * already available), otherwise falls back to plain reducing.
  */
-static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
+static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags,
+				      int no_device_reduce)
 {
 	u64 num_devices = root->fs_info->fs_devices->rw_devices;
 	u64 target;
@@ -3759,13 +3760,16 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	spin_unlock(&root->fs_info->balance_lock);
 
 	/* First, mask out the RAID levels which aren't possible */
-	if (num_devices == 1)
-		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0 |
-			   BTRFS_BLOCK_GROUP_RAID5);
-	if (num_devices < 3)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID6;
-	if (num_devices < 4)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
+	if (!no_device_reduce) {
+		if (num_devices == 1)
+			flags &= ~(BTRFS_BLOCK_GROUP_RAID1 |
+				   BTRFS_BLOCK_GROUP_RAID0 |
+				   BTRFS_BLOCK_GROUP_RAID5);
+		if (num_devices < 3)
+			flags &= ~BTRFS_BLOCK_GROUP_RAID6;
+		if (num_devices < 4)
+			flags &= ~BTRFS_BLOCK_GROUP_RAID10;
+	}
 
 	tmp = flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
 		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID5 |
@@ -3786,7 +3790,8 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	return extended_to_chunk(flags | tmp);
 }
 
-static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags)
+static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags,
+			     int no_device_reduce)
 {
 	unsigned seq;
 	u64 flags;
@@ -3803,10 +3808,11 @@ static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags)
 			flags |= root->fs_info->avail_metadata_alloc_bits;
 	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
-	return btrfs_reduce_alloc_profile(root, flags);
+	return btrfs_reduce_alloc_profile(root, flags, no_device_reduce);
 }
 
-u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
+u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data,
+			    int no_device_reduce)
 {
 	u64 flags;
 	u64 ret;
@@ -3818,7 +3824,7 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 	else
 		flags = BTRFS_BLOCK_GROUP_METADATA;
 
-	ret = get_alloc_profile(root, flags);
+	ret = get_alloc_profile(root, flags, no_device_reduce);
 	return ret;
 }
 
@@ -3868,7 +3874,7 @@ again:
 			data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
 			spin_unlock(&data_sinfo->lock);
 alloc:
-			alloc_target = btrfs_get_alloc_profile(root, 1);
+			alloc_target = btrfs_get_alloc_profile(root, 1, 0);
 			/*
 			 * It is ugly that we don't call nolock join
 			 * transaction for the free space inode case here.
@@ -4094,7 +4100,8 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 	if (left < thresh) {
 		u64 flags;
 
-		flags = btrfs_get_alloc_profile(root->fs_info->chunk_root, 0);
+		flags = btrfs_get_alloc_profile(root->fs_info->chunk_root, 0,
+						0);
 		/*
 		 * Ignore failure to create system chunk. We might end up not
 		 * needing it, as we might not need to COW all nodes/leafs from
@@ -4222,7 +4229,7 @@ static int can_overcommit(struct btrfs_root *root,
 			  enum btrfs_reserve_flush_enum flush)
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
-	u64 profile = btrfs_get_alloc_profile(root, 0);
+	u64 profile = btrfs_get_alloc_profile(root, 0, 0);
 	u64 space_size;
 	u64 avail;
 	u64 used;
@@ -4488,7 +4495,7 @@ static int flush_space(struct btrfs_root *root,
 			break;
 		}
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     btrfs_get_alloc_profile(root, 0),
+				     btrfs_get_alloc_profile(root, 0, 0),
 				     CHUNK_ALLOC_NO_FORCE);
 		btrfs_end_transaction(trans, root);
 		if (ret == -ENOSPC)
@@ -7155,9 +7162,22 @@ int btrfs_reserve_extent(struct btrfs_root *root,
 {
 	bool final_tried = false;
 	u64 flags;
+	u64 org_flags;
 	int ret;
 
-	flags = btrfs_get_alloc_profile(root, is_data);
+	flags = btrfs_get_alloc_profile(root, is_data, 0);
+	org_flags = btrfs_get_alloc_profile(root, is_data, 1);
+
+	/*
+	 * For a non-single fs(as raid1), if current num_devices is too small,
+	 * BLOCK_GROUPS in flags is reduced to 0, but we don't want to write
+	 * data to new-created single block-group, or existence single-type bg
+	 * created my fsck.
+	 */
+	if ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
+	    (org_flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0)
+		return -ENOSPC;
+
 again:
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(root, num_bytes, empty_size, hint_byte, ins,
@@ -8792,7 +8812,7 @@ again:
 	ret = set_block_group_ro(cache, 0);
 	if (!ret)
 		goto out;
-	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
+	alloc_flags = get_alloc_profile(root, cache->space_info->flags, 0);
 	ret = do_chunk_alloc(trans, root, alloc_flags,
 			     CHUNK_ALLOC_FORCE);
 	if (ret < 0)
@@ -8814,7 +8834,7 @@ out:
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 type)
 {
-	u64 alloc_flags = get_alloc_profile(root, type);
+	u64 alloc_flags = get_alloc_profile(root, type, 0);
 	return do_chunk_alloc(trans, root, alloc_flags,
 			      CHUNK_ALLOC_FORCE);
 }
@@ -9404,7 +9424,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	}
 
 	list_for_each_entry_rcu(space_info, &root->fs_info->space_info, list) {
-		if (!(get_alloc_profile(root, space_info->flags) &
+		if (!(get_alloc_profile(root, space_info->flags, 0) &
 		      (BTRFS_BLOCK_GROUP_RAID10 |
 		       BTRFS_BLOCK_GROUP_RAID1 |
 		       BTRFS_BLOCK_GROUP_RAID5 |
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b33c0cf..1a79791 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8075,7 +8075,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	}
 
 	/* async crcs make it difficult to collect full stripe writes. */
-	if (btrfs_get_alloc_profile(root, 1) & BTRFS_BLOCK_GROUP_RAID56_MASK)
+	if (btrfs_get_alloc_profile(root, 1, 0) &
+	    BTRFS_BLOCK_GROUP_RAID56_MASK)
 		async_submit = 0;
 	else
 		async_submit = 1;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cd7ef34..fd546a3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1803,7 +1803,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 		return -ENOMEM;
 
 	/* calc min stripe number for data space alloction */
-	type = btrfs_get_alloc_profile(root, 1);
+	type = btrfs_get_alloc_profile(root, 1, 0);
 	if (type & BTRFS_BLOCK_GROUP_RAID0) {
 		min_stripes = 2;
 		num_stripes = nr_devices;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d739915..e0dcebb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4789,14 +4789,14 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	int ret;
 
 	chunk_offset = find_next_chunk(fs_info);
-	alloc_profile = btrfs_get_alloc_profile(extent_root, 0);
+	alloc_profile = btrfs_get_alloc_profile(extent_root, 0, 0);
 	ret = __btrfs_alloc_chunk(trans, extent_root, chunk_offset,
 				  alloc_profile);
 	if (ret)
 		return ret;
 
 	sys_chunk_offset = find_next_chunk(root->fs_info);
-	alloc_profile = btrfs_get_alloc_profile(fs_info->chunk_root, 0);
+	alloc_profile = btrfs_get_alloc_profile(fs_info->chunk_root, 0, 0);
 	ret = __btrfs_alloc_chunk(trans, extent_root, sys_chunk_offset,
 				  alloc_profile);
 	return ret;
-- 
1.8.5.1

