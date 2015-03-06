Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10703 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbbCFGyf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 01:54:35 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <zblaxell@furryterror.org>, <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v4 1/3] Btrfs: get more accurate output in df command.
Date: Fri, 6 Mar 2015 14:50:53 +0800
Message-ID: <1425624653-13690-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1425521918-30212-2-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1425521918-30212-2-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When function btrfs_statfs() calculate the tatol size of fs, it is calculating
the total size of disks and then dividing it by a factor. But in some usecase,
the result is not good to user.
Example:
	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
	# mount /dev/vdf1 /mnt
	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
	# df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdf1       3.0G 1018M  1.3G  45% /mnt
	# btrfs fi show /dev/vdf1
Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
	Total devices 2 FS bytes used 1001.53MiB
	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
a. df -h should report Size as 2GiB rather than as 3GiB.
Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.

b. df -h should report Avail as 0.97GiB or less, rather than as 1.3GiB.
    1.85           (the capacity of the allocated chunk)
   -1.018          (the file stored)
   +(2-1.85=0.15)  (the residual capacity of the disks
                    considering a raid1 fs)
   ---------------
=   0.97

This patch drops the factor at all and calculate the size observable to
user without considering which raid level the data is in and what's the
size exactly in disk.
After this patch applied:
	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
	# mount /dev/vdf1 /mnt
	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
	# df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdf1       2.0G  1.3G  713M  66% /mnt
	# df /mnt
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/vdf1        2097152 1359424    729536  66% /mnt
	# btrfs fi show /dev/vdf1
Label: none  uuid: e98c1321-645f-4457-b20d-4f41dc1cf2f4
	Total devices 2 FS bytes used 1001.55MiB
	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
a). The @Size is 2G as we expected.
b). @Available is 700M = 1.85G - 1.3G + (2G - 1.85G).
c). @Used is changed to 1.3G rather than 1018M as above. Because
    this patch do not treat the free space in metadata chunk
    and system chunk as available to user. It's true, user can
    not use these space to store data, then it should not be
    thought as available. At the same time, it will make the
    @Used + @Available == @Size as possible to user.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
	v3->v4:
		Fix a trailing whitespace error found by checkpatch.
 fs/btrfs/ctree.h       |  1 -
 fs/btrfs/extent-tree.c | 41 ----------------------------
 fs/btrfs/super.c       | 72 ++++++++++++++++++++++++++++----------------------
 3 files changed, 41 insertions(+), 73 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84c3b00..d1ae425 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3460,7 +3460,6 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 void btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
-u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
 				   u64 start, u64 end);
 int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 571f402..857eb0e3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8515,47 +8515,6 @@ int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			      CHUNK_ALLOC_FORCE);
 }
 
-/*
- * helper to account the unused space of all the readonly block group in the
- * space_info. takes mirrors into account.
- */
-u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
-{
-	struct btrfs_block_group_cache *block_group;
-	u64 free_bytes = 0;
-	int factor;
-
-	/* It's df, we don't care if it's racey */
-	if (list_empty(&sinfo->ro_bgs))
-		return 0;
-
-	spin_lock(&sinfo->lock);
-	list_for_each_entry(block_group, &sinfo->ro_bgs, ro_list) {
-		spin_lock(&block_group->lock);
-
-		if (!block_group->ro) {
-			spin_unlock(&block_group->lock);
-			continue;
-		}
-
-		if (block_group->flags & (BTRFS_BLOCK_GROUP_RAID1 |
-					  BTRFS_BLOCK_GROUP_RAID10 |
-					  BTRFS_BLOCK_GROUP_DUP))
-			factor = 2;
-		else
-			factor = 1;
-
-		free_bytes += (block_group->key.offset -
-			       btrfs_block_group_used(&block_group->item)) *
-			       factor;
-
-		spin_unlock(&block_group->lock);
-	}
-	spin_unlock(&sinfo->lock);
-
-	return free_bytes;
-}
-
 void btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache)
 {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef19..2e8029f6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1659,6 +1659,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	u64 used_space;
 	u64 min_stripe_size;
 	int min_stripes = 1, num_stripes = 1;
+	/* How many stripes used to store data, without considering mirrors. */
+	int data_stripes = 1;
 	int i = 0, nr_devices;
 	int ret;
 
@@ -1687,12 +1689,15 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	if (type & BTRFS_BLOCK_GROUP_RAID0) {
 		min_stripes = 2;
 		num_stripes = nr_devices;
+		data_stripes = num_stripes;
 	} else if (type & BTRFS_BLOCK_GROUP_RAID1) {
 		min_stripes = 2;
 		num_stripes = 2;
+		data_stripes = 1;
 	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
 		min_stripes = 4;
 		num_stripes = 4;
+		data_stripes = 2;
 	}
 
 	if (type & BTRFS_BLOCK_GROUP_DUP)
@@ -1780,14 +1785,17 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	i = nr_devices - 1;
 	avail_space = 0;
 	while (nr_devices >= min_stripes) {
-		if (num_stripes > nr_devices)
+		if (num_stripes > nr_devices) {
 			num_stripes = nr_devices;
+			if (type & BTRFS_BLOCK_GROUP_RAID0)
+				data_stripes = num_stripes;
+		}
 
 		if (devices_info[i].max_avail >= min_stripe_size) {
 			int j;
 			u64 alloc_size;
 
-			avail_space += devices_info[i].max_avail * num_stripes;
+			avail_space += devices_info[i].max_avail * data_stripes;
 			alloc_size = devices_info[i].max_avail;
 			for (j = i + 1 - num_stripes; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;
@@ -1819,15 +1827,13 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(dentry->d_sb);
-	struct btrfs_super_block *disk_super = fs_info->super_copy;
 	struct list_head *head = &fs_info->space_info;
 	struct btrfs_space_info *found;
 	u64 total_used = 0;
+	u64 total_alloc = 0;
 	u64 total_free_data = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)fs_info->fsid;
-	unsigned factor = 1;
-	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 
 	/*
@@ -1836,45 +1842,49 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
-			int i;
-
-			total_free_data += found->disk_total - found->disk_used;
-			total_free_data -=
-				btrfs_account_ro_block_groups_free_space(found);
+		if ((found->flags & BTRFS_BLOCK_GROUP_DATA)) {
+			struct btrfs_block_group_cache *block_group;
+			int index = __get_raid_index(btrfs_get_alloc_profile(fs_info->extent_root, 1));
+			int i = 0;
 
 			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
-				if (!list_empty(&found->block_groups[i])) {
-					switch (i) {
-					case BTRFS_RAID_DUP:
-					case BTRFS_RAID_RAID1:
-					case BTRFS_RAID_RAID10:
-						factor = 2;
+				list_for_each_entry(block_group, &found->block_groups[i], list) {
+					if (i == index) {
+						u64 used = btrfs_block_group_used(&block_group->item);
+
+						used += block_group->pinned;
+						used += block_group->reserved;
+						used += block_group->bytes_super;
+
+						total_used += used;
+						total_free_data += block_group->key.offset - used;
+					} else {
+						/* For block group in other raid level, treat the total_bytes
+						 * as used.
+						 **/
+						total_used += block_group->key.offset;
 					}
 				}
 			}
+		} else {
+			/* For metadata and system, we treat the total_bytes as
+			 * not available to file data. So show it as Used in df.
+			 **/
+			total_used += found->total_bytes;
 		}
-
-		total_used += found->disk_used;
+		total_alloc += found->total_bytes;
 	}
-
 	rcu_read_unlock();
 
-	buf->f_blocks = div_u64(btrfs_super_total_bytes(disk_super), factor);
-	buf->f_blocks >>= bits;
-	buf->f_bfree = buf->f_blocks - (div_u64(total_used, factor) >> bits);
-
-	/* Account global block reserve as used, it's in logical size already */
-	spin_lock(&block_rsv->lock);
-	buf->f_bfree -= block_rsv->size >> bits;
-	spin_unlock(&block_rsv->lock);
-
-	buf->f_bavail = div_u64(total_free_data, factor);
+	buf->f_bavail = total_free_data;
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret)
 		return ret;
-	buf->f_bavail += div_u64(total_free_data, factor);
+	buf->f_bavail += total_free_data;
 	buf->f_bavail = buf->f_bavail >> bits;
+	buf->f_blocks = total_alloc + total_free_data;
+	buf->f_blocks >>= bits;
+	buf->f_bfree = buf->f_blocks - (total_used >> bits);
 
 	buf->f_type = BTRFS_SUPER_MAGIC;
 	buf->f_bsize = dentry->d_sb->s_blocksize;
-- 
1.8.4.2

