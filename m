From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 6/6] btrfs: fix wrong free space information of btrfs
Date: Wed, 22 Dec 2010 18:47:39 +0800
Message-ID: <4D11D74B.8050204@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we store data by raid profile in btrfs with two or more different size
disks, df command shows there is some free space in the filesystem, but the
user can not write any data in fact, df command shows the wrong free space
information of btrfs.

 # mkfs.btrfs -d raid1 /dev/sda9 /dev/sda10
 # btrfs-show
 Label: none  uuid: a95cd49e-6e33-45b8-8741-a36153ce4b64
 	Total devices 2 FS bytes used 28.00KB
 	devid    1 size 5.01GB used 2.03GB path /dev/sda9
 	devid    2 size 10.00GB used 2.01GB path /dev/sda10
 # btrfs device scan /dev/sda9 /dev/sda10
 # mount /dev/sda9 /mnt
 # dd if=/dev/zero of=tmpfile0 bs=4K count=9999999999
   (fill the filesystem)
 # sync
 # df -TH
 Filesystem	Type	Size	Used	Avail	Use%	Mounted on
 /dev/sda9	btrfs	17G	8.6G	5.4G	62%	/mnt
 # btrfs-show
 Label: none  uuid: a95cd49e-6e33-45b8-8741-a36153ce4b64
 	Total devices 2 FS bytes used 3.99GB
 	devid    1 size 5.01GB used 5.01GB path /dev/sda9
 	devid    2 size 10.00GB used 4.99GB path /dev/sda10

It is because btrfs cannot allocate chunks when one of the pairing disks has
no space, the free space on the other disks can not be used for ever, and should
be subtracted from the total space, but btrfs doesn't subtract this space from
the total. It is strange to the user.

This patch fixes it by calcing the free space that can be used to allocate
chunks.

Implementation:
1. get all the devices free space, and align them by stripe length.
2. sort the devices by the free space.
3. check the free space of the devices,
   3.1. if it is not zero, and then check the number of the devices that has
        more free space than this device,
        if the number of the devices is beyond the min stripe number, the free
        space can be used, and add into total free space.
        if the number of the devices is below the min stripe number, we can not
        use the free space, the check ends.
   3.2. if the free space is zero, check the next devices, goto 3.1

This implementation is just likely fake chunk allocation.

After appling this patch, df can show correct space information:
 # df -TH
 Filesystem	Type	Size	Used	Avail	Use%	Mounted on
 /dev/sda9	btrfs	17G	8.6G	0	100%	/mnt

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    2 +
 fs/btrfs/extent-tree.c |   58 +++++++++++++++++++-
 fs/btrfs/super.c       |  146 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.c     |   84 +++++++++++++++++++++++++++
 fs/btrfs/volumes.h     |    3 +
 5 files changed, 286 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index af52f6d..a068a5d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2145,6 +2145,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
+u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
@@ -2188,6 +2189,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 int btrfs_set_block_group_rw(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
+u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7c1a053..fd465e1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3090,7 +3090,7 @@ static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 	return btrfs_reduce_alloc_profile(root, flags);
 }
 
-static u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
+u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 {
 	u64 flags;
 
@@ -8018,6 +8018,62 @@ out:
 	return ret;
 }
 
+/*
+ * helper to account the unused space of all the readonly block group in the
+ * list. takes mirrors into account.
+ */
+static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
+{
+	struct btrfs_block_group_cache *block_group;
+	u64 free_bytes = 0;
+	int factor;
+
+	list_for_each_entry(block_group, groups_list, list) {
+		spin_lock(&block_group->lock);
+
+		if (!block_group->ro) {
+			spin_unlock(&block_group->lock);
+			continue;
+		}
+
+		if (block_group->flags & (BTRFS_BLOCK_GROUP_RAID1 |
+					  BTRFS_BLOCK_GROUP_RAID10 |
+					  BTRFS_BLOCK_GROUP_DUP))
+			factor = 2;
+		else
+			factor = 1;
+
+		free_bytes += (block_group->key.offset -
+			       btrfs_block_group_used(&block_group->item)) *
+			       factor;
+
+		spin_unlock(&block_group->lock);
+	}
+
+	return free_bytes;
+}
+
+/*
+ * helper to account the unused space of all the readonly block group in the
+ * space_info. takes mirrors into account.
+ */
+u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
+{
+	int i;
+	u64 free_bytes = 0;
+
+	spin_lock(&sinfo->lock);
+
+	for(i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+		if (!list_empty(&sinfo->block_groups[i]))
+			free_bytes += __btrfs_get_ro_block_group_free_space(
+						&sinfo->block_groups[i]);
+
+	spin_unlock(&sinfo->lock);
+
+	return free_bytes;
+}
+
 int btrfs_set_block_group_rw(struct btrfs_root *root,
 			      struct btrfs_block_group_cache *cache)
 {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1d21208..61157ba 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -755,6 +755,127 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
+/*
+ * The helper to calc the free space on the devices that can be used to store
+ * file data.
+ */
+static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_device_info *devices_info;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	u64 skip_space;
+	u64 type;
+	u64 avail_space;
+	u64 used_space;
+	u64 min_stripe_size;
+	int min_stripes = 1;
+	int i = 0, nr_devices;
+	int ret;
+
+	nr_devices = fs_info->fs_devices->rw_devices;
+	BUG_ON(!nr_devices);
+
+	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
+			       GFP_NOFS);
+	if (!devices_info)
+		return -ENOMEM;
+
+	/* calc min stripe number for data space alloction */
+	type = btrfs_get_alloc_profile(root, 1);
+	if (type & BTRFS_BLOCK_GROUP_RAID0)
+		min_stripes = 2;
+	else if (type & BTRFS_BLOCK_GROUP_RAID1)
+		min_stripes = 2;
+	else if (type & BTRFS_BLOCK_GROUP_RAID10)
+		min_stripes = 4;
+
+	if (type & BTRFS_BLOCK_GROUP_DUP)
+		min_stripe_size = 2 * BTRFS_STRIPE_LEN;
+	else
+		min_stripe_size = BTRFS_STRIPE_LEN;
+
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		if (!device->in_fs_metadata)
+			continue;
+
+		avail_space = device->total_bytes - device->bytes_used;
+
+		/* align with stripe_len */
+		do_div(avail_space, BTRFS_STRIPE_LEN);
+		avail_space *= BTRFS_STRIPE_LEN;
+
+		/*
+		 * In order to avoid overwritting the superblock on the drive,
+		 * btrfs starts at an offset of at least 1MB when doing chunk
+		 * allocation.
+		 */
+		skip_space = 1024 * 1024;
+
+		/* user can set the offset in fs_info->alloc_start. */
+		if (fs_info->alloc_start + BTRFS_STRIPE_LEN <=
+		    device->total_bytes)
+			skip_space = max(fs_info->alloc_start, skip_space);
+
+		/*
+		 * btrfs can not use the free space in [0, skip_space - 1],
+		 * we must subtract it from the total. In order to implement
+		 * it, we account the used space in this range first.
+		 */
+		ret = btrfs_account_dev_extents_size(device, 0, skip_space - 1,
+						     &used_space);
+		if (ret) {
+			kfree(devices_info);
+			return ret;
+		}
+
+		/* calc the free space in [0, skip_space - 1] */
+		skip_space -= used_space;
+
+		/*
+		 * we can use the free space in [0, skip_space - 1], subtract
+		 * it from the total.
+		 */
+		if (avail_space && avail_space >= skip_space)
+			avail_space -= skip_space;
+		else
+			avail_space = 0;
+
+		if (avail_space < min_stripe_size)
+			continue;
+
+		devices_info[i].dev = device;
+		devices_info[i].max_avail = avail_space;
+
+		i++;
+	}
+
+	nr_devices = i;
+
+	btrfs_descending_sort_devices(devices_info, nr_devices);
+
+	i = nr_devices - 1;
+	avail_space = 0;
+	while (nr_devices >= min_stripes) {
+		if (devices_info[i].max_avail >= min_stripe_size) {
+			int j;
+			u64 alloc_size;
+
+			avail_space += devices_info[i].max_avail * min_stripes;
+			alloc_size = devices_info[i].max_avail;
+			for (j = i + 1 - min_stripes; j <= i; j++)
+				devices_info[j].max_avail -= alloc_size;
+		}
+		i--;
+		nr_devices--;
+	}
+
+	kfree(devices_info);
+	*free_bytes = avail_space;
+	return 0;
+}
+
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct btrfs_root *root = btrfs_sb(dentry->d_sb);
@@ -762,16 +883,21 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct list_head *head = &root->fs_info->space_info;
 	struct btrfs_space_info *found;
 	u64 total_used = 0;
-	u64 total_used_data = 0;
+	u64 total_free_data = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)root->fs_info->fsid;
+	int ret;
 
+	/* holding chunk_muext to avoid allocating new chunks */
+	mutex_lock(&root->fs_info->chunk_mutex);
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA)
-			total_used_data += found->disk_used;
-		else
-			total_used_data += found->disk_total;
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+			total_free_data += found->disk_total - found->disk_used;
+			total_free_data -=
+				btrfs_account_ro_block_groups_free_space(found);
+		}
+
 		total_used += found->disk_used;
 	}
 	rcu_read_unlock();
@@ -779,9 +905,17 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_namelen = BTRFS_NAME_LEN;
 	buf->f_blocks = btrfs_super_total_bytes(disk_super) >> bits;
 	buf->f_bfree = buf->f_blocks - (total_used >> bits);
-	buf->f_bavail = buf->f_blocks - (total_used_data >> bits);
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	buf->f_type = BTRFS_SUPER_MAGIC;
+	buf->f_bavail = total_free_data;
+	ret = btrfs_calc_avail_data_space(root, &total_free_data);
+	if (ret) {
+		mutex_unlock(&root->fs_info->chunk_mutex);
+		return ret;
+	}
+	buf->f_bavail += total_free_data;
+	buf->f_bavail = buf->f_bavail >> bits;
+	mutex_unlock(&root->fs_info->chunk_mutex);
 
 	/* We treat it as constant endianness (it doesn't matter _which_)
 	   because we want the fsid to come out the same whether mounted
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c298367..9870fd2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -728,6 +728,90 @@ error:
 	return ret;
 }
 
+/* helper to account the used device space in the range */
+int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
+				   u64 end, u64 *length)
+{
+	struct btrfs_key key;
+	struct btrfs_root *root = device->dev_root;
+	struct btrfs_dev_extent *dev_extent;
+	struct btrfs_path *path;
+	u64 extent_end;
+	int ret;
+	int slot;
+	struct extent_buffer *l;
+
+	*length = 0;
+
+	if (start >= device->total_bytes)
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = 2;
+
+	key.objectid = device->devid;
+	key.offset = start;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = btrfs_previous_item(root, path, key.objectid, key.type);
+		if (ret < 0)
+			goto out;
+	}
+
+	while (1) {
+		l = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >= btrfs_header_nritems(l)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret == 0)
+				continue;
+			if (ret < 0)
+				goto out;
+
+			break;
+		}
+		btrfs_item_key_to_cpu(l, &key, slot);
+
+		if (key.objectid < device->devid)
+			goto next;
+
+		if (key.objectid > device->devid)
+			break;
+
+		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
+			goto next;
+
+		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
+		extent_end = key.offset + btrfs_dev_extent_length(l,
+								  dev_extent);
+		if (key.offset <= start && extent_end > end) {
+			*length = end - start + 1;
+			break;
+		} else if (key.offset <= start && extent_end > start)
+			*length += extent_end - start;
+		else if (key.offset > start && extent_end <= end)
+			*length += extent_end - key.offset;
+		else if (key.offset > start && key.offset <= end) {
+			*length += end - key.offset + 1;
+			break;
+		} else if (key.offset > end)
+			break;
+
+next:
+		path->slots[0]++;
+	}
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * find_free_dev_extent - find free space in the specified device
  * @trans:	transaction handler
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a5cfedf..7af6144 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -161,6 +161,9 @@ static inline void btrfs_descending_sort_devices(
 	     btrfs_cmp_device_free_bytes, NULL);
 }
 
+int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
+				   u64 end, u64 *length);
+
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
-- 
1.7.0.1
