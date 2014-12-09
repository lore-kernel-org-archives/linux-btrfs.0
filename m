Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30674 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756701AbaLILXZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 06:23:25 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <lists@colorremedies.com>
CC: <linux-btrfs@vger.kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs: get more accurate output in fd command.
Date: Tue, 9 Dec 2014 19:20:37 +0800
Message-ID: <1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
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

b. df -h should report Avail as 0.15GiB or less, rather than as 1.3GiB.
2 - 1.85 = 0.15

This patch drops the factor at all and calculate the size observable to
user without considering which raid level the data is in and what's the
size exactly in disk.

After this patch applied:
	# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
	# mount /dev/vdf1 /mnt
	# dd if=/dev/zero of=/mnt/zero bs=1M count=1000
	# df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdf1       2.0G 1018M  713M  59% /mnt

	# btrfs fi show /dev/vdf1
Label: none  uuid: e98c1321-645f-4457-b20d-4f41dc1cf2f4
	Total devices 2 FS bytes used 1001.55MiB
	devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
	devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 13 ++-----------
 fs/btrfs/super.c       | 47 +++++++++++++++++++----------------------------
 2 files changed, 21 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a84e00d..9954d60 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8571,7 +8571,6 @@ static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
 {
 	struct btrfs_block_group_cache *block_group;
 	u64 free_bytes = 0;
-	int factor;
 
 	list_for_each_entry(block_group, groups_list, list) {
 		spin_lock(&block_group->lock);
@@ -8581,16 +8580,8 @@ static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
 			continue;
 		}
 
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
+		free_bytes += block_group->key.offset -
+			      btrfs_block_group_used(&block_group->item);
 
 		spin_unlock(&block_group->lock);
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54bd91e..83c2c3c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1641,6 +1641,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	u64 used_space;
 	u64 min_stripe_size;
 	int min_stripes = 1, num_stripes = 1;
+	/* How many stripes used to store data, without considering mirrors. */
+	int data_stripes = 1;
 	int i = 0, nr_devices;
 	int ret;
 
@@ -1657,12 +1659,15 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	if (type & BTRFS_BLOCK_GROUP_RAID0) {
 		min_stripes = 2;
 		num_stripes = nr_devices;
+		data_stripes = 2;
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
@@ -1740,7 +1745,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 			int j;
 			u64 alloc_size;
 
-			avail_space += devices_info[i].max_avail * num_stripes;
+			avail_space += devices_info[i].max_avail * data_stripes;
 			alloc_size = devices_info[i].max_avail;
 			for (j = i + 1 - num_stripes; j <= i; j++)
 				devices_info[j].max_avail -= alloc_size;
@@ -1772,14 +1777,13 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
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
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 
@@ -1792,38 +1796,17 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
 		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
-			int i;
-
-			total_free_data += found->disk_total - found->disk_used;
+			total_free_data += found->total_bytes - found->bytes_used;
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
-
-			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
-				if (!list_empty(&found->block_groups[i])) {
-					switch (i) {
-					case BTRFS_RAID_DUP:
-					case BTRFS_RAID_RAID1:
-					case BTRFS_RAID_RAID10:
-						factor = 2;
-					}
-				}
-			}
 		}
 
-		total_used += found->disk_used;
+		total_used += found->bytes_used;
+		total_alloc += found->total_bytes;
 	}
 
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
 	buf->f_bavail = total_free_data;
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret) {
@@ -1831,8 +1814,16 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		return ret;
 	}
-	buf->f_bavail += div_u64(total_free_data, factor);
+	buf->f_bavail += total_free_data;
 	buf->f_bavail = buf->f_bavail >> bits;
+	buf->f_blocks = total_alloc + total_free_data;
+	buf->f_blocks >>= bits;
+	buf->f_bfree = buf->f_blocks - (total_used >> bits);
+	/* Account global block reserve as used, it's in logical size already */
+	spin_lock(&block_rsv->lock);
+	buf->f_bfree -= block_rsv->size >> bits;
+	spin_unlock(&block_rsv->lock);
+
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
-- 
1.8.4.2

