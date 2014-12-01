Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52186 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752387AbaLADlE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 22:41:04 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <Anand.Jain@oracle.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: remove empty fs_devices to prevent memory runout
Date: Mon, 1 Dec 2014 11:39:14 +0800
Message-ID: <1417405154-6170-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <546F1BE6.6030708@oracle.com>
References: <546F1BE6.6030708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a global list @fs_uuids to keep @fs_devices object
for each created btrfs. But when a btrfs becomes "empty"
(all devices belong to it are gone), its @fs_devices remains
in @fs_uuids list until module exit.
If we keeps mkfs.btrfs on the same device again and again,
all empty @fs_devices produced are sure to eat up our memory.
So this case has better to be prevented.

I think that each time we setup btrfs on that device, we should
check whether we are stealing some device from another btrfs
seen before. To faciliate the search procedure, we could insert
all @btrfs_device in a rb_root, one @btrfs_device per each physical
device, with @bdev->bd_dev as key. Each time device stealing happens,
we should replace the corresponding @btrfs_device in the rb_root with
an up-to-date version.
If the stolen device is the last device in its @fs_devices,
then we have an empty btrfs to be deleted.

Actually there are 3 ways to steal devices and lead to empty btrfs
        1. mkfs, with -f option
        2. device add, with -f option
        3. device replace, with -f option
We should act under these cases.

Moreover, there are special cases to consider:
o If there are seed devices, then it is asured that
  the devices in cloned @fs_devices are not treated as valid devices.
o If a device disappears and reappears without any touch, its
  @bdev->bd_dev may change, so we have to re-insert it into the rb_root.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: add handle for device disappears and reappears event

	*Note*
	Actually this handles the case when a device disappears and
	reappears without any touch.
	We are going to recycle all "dead" btrfs_device in another patch.
	Two events leads to the "dead"s:
		1) device disappears and never returns again
		2) device disappears and returns with a new fs on it
	A shrinker shall kill the "dead"s.
---
 fs/btrfs/super.c   |   1 +
 fs/btrfs/volumes.c | 281 ++++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |   6 ++
 3 files changed, 230 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54bd91e..ee09a56 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2154,6 +2154,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_end_io_wq_exit();
 	unregister_filesystem(&btrfs_fs_type);
 	btrfs_exit_sysfs();
+	btrfs_cleanup_valid_dev_root();
 	btrfs_cleanup_fs_uuids();
 	btrfs_exit_compress();
 	btrfs_hash_exit();
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0192051..7093cce 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/rbtree.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -52,6 +53,126 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
+static struct rb_root valid_dev_root = RB_ROOT;
+
+static struct btrfs_device *insert_valid_device(struct btrfs_device *new_dev)
+{
+	struct rb_node **p;
+	struct rb_node *parent;
+	struct rb_node *new;
+	struct btrfs_device *old_dev;
+
+	WARN_ON(!mutex_is_locked(&uuid_mutex));
+
+	parent = NULL;
+	new = &new_dev->rb_node;
+
+	p = &valid_dev_root.rb_node;
+	while (*p) {
+		parent = *p;
+		old_dev = rb_entry(parent, struct btrfs_device, rb_node);
+
+		if (new_dev->devnum < old_dev->devnum)
+			p = &parent->rb_left;
+		else if (new_dev->devnum > old_dev->devnum)
+			p = &parent->rb_right;
+		else {
+			rb_replace_node(parent, new, &valid_dev_root);
+			RB_CLEAR_NODE(parent);
+
+			goto out;
+		}
+	}
+
+	old_dev = NULL;
+	rb_link_node(new, parent, p);
+	rb_insert_color(new, &valid_dev_root);
+
+out:
+	return old_dev;
+}
+
+static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
+{
+	struct btrfs_device *device;
+	WARN_ON(fs_devices->opened);
+	while (!list_empty(&fs_devices->devices)) {
+		device = list_entry(fs_devices->devices.next,
+				    struct btrfs_device, dev_list);
+		list_del(&device->dev_list);
+		rcu_string_free(device->name);
+		kfree(device);
+	}
+	kfree(fs_devices);
+}
+
+static void remove_empty_fs_if_need(struct btrfs_fs_devices *old_fs)
+{
+	struct btrfs_fs_devices *seed_fs;
+
+	if (!list_empty(&old_fs->devices))
+		return;
+
+	list_del(&old_fs->list);
+
+	/* free the seed clones */
+	seed_fs = old_fs->seed;
+	free_fs_devices(old_fs);
+	while (seed_fs) {
+		old_fs = seed_fs;
+		seed_fs = seed_fs->seed;
+		free_fs_devices(old_fs);
+	}
+
+}
+
+static void free_invalid_device(struct btrfs_device *invalid_dev)
+{
+	struct btrfs_fs_devices *old_fs;
+
+	old_fs = invalid_dev->fs_devices;
+	mutex_lock(&old_fs->device_list_mutex);
+	list_del(&invalid_dev->dev_list);
+	rcu_string_free(invalid_dev->name);
+	kfree(invalid_dev);
+	mutex_unlock(&old_fs->device_list_mutex);
+
+	remove_empty_fs_if_need(old_fs);
+}
+
+static void replace_invalid_device(struct btrfs_device *new_dev)
+{
+	struct btrfs_device *invalid_dev;
+
+	WARN_ON(!mutex_is_locked(&uuid_mutex));
+
+	invalid_dev = insert_valid_device(new_dev);
+	if (!invalid_dev)
+		return;
+
+	free_invalid_device(invalid_dev);
+}
+
+static void remove_valid_device(struct btrfs_device *old_dev)
+{
+	WARN_ON(!mutex_is_locked(&uuid_mutex));
+
+	if (!RB_EMPTY_NODE(&old_dev->rb_node)) {
+		rb_erase(&old_dev->rb_node, &valid_dev_root);
+		RB_CLEAR_NODE(&old_dev->rb_node);
+	}
+}
+
+void btrfs_cleanup_valid_dev_root(void)
+{
+	struct rb_node *rb_node;
+
+	rb_node = rb_first(&valid_dev_root);
+	while (rb_node) {
+		rb_erase(rb_node, &valid_dev_root);
+		rb_node = rb_first(&valid_dev_root);
+	}
+}
 
 static void lock_chunks(struct btrfs_root *root)
 {
@@ -106,20 +227,6 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	return fs_devs;
 }
 
-static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
-{
-	struct btrfs_device *device;
-	WARN_ON(fs_devices->opened);
-	while (!list_empty(&fs_devices->devices)) {
-		device = list_entry(fs_devices->devices.next,
-				    struct btrfs_device, dev_list);
-		list_del(&device->dev_list);
-		rcu_string_free(device->name);
-		kfree(device);
-	}
-	kfree(fs_devices);
-}
-
 static void btrfs_kobject_uevent(struct block_device *bdev,
 				 enum kobject_action action)
 {
@@ -165,6 +272,8 @@ static struct btrfs_device *__alloc_device(void)
 	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_WAIT);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_WAIT);
 
+	RB_CLEAR_NODE(&dev->rb_node);
+
 	return dev;
 }
 
@@ -461,7 +570,7 @@ static void pending_bios_fn(struct btrfs_work *work)
  * < 0 - error
  */
 static noinline int device_list_add(const char *path,
-			   struct btrfs_super_block *disk_super,
+			   struct btrfs_super_block *disk_super, dev_t devnum,
 			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
 {
 	struct btrfs_device *device;
@@ -509,53 +618,65 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-	} else if (!device->name || strcmp(device->name->str, path)) {
-		/*
-		 * When FS is already mounted.
-		 * 1. If you are here and if the device->name is NULL that
-		 *    means this device was missing at time of FS mount.
-		 * 2. If you are here and if the device->name is different
-		 *    from 'path' that means either
-		 *      a. The same device disappeared and reappeared with
-		 *         different name. or
-		 *      b. The missing-disk-which-was-replaced, has
-		 *         reappeared now.
-		 *
-		 * We must allow 1 and 2a above. But 2b would be a spurious
-		 * and unintentional.
-		 *
-		 * Further in case of 1 and 2a above, the disk at 'path'
-		 * would have missed some transaction when it was away and
-		 * in case of 2a the stale bdev has to be updated as well.
-		 * 2b must not be allowed at all time.
-		 */
+		device->devnum = devnum;
+		replace_invalid_device(device);
+	} else {
+		if (!device->name || strcmp(device->name->str, path)) {
+			/*
+			 * When FS is already mounted.
+			 * 1. If you are here and if the device->name is NULL that
+			 *    means this device was missing at time of FS mount.
+			 * 2. If you are here and if the device->name is different
+			 *    from 'path' that means either
+			 *      a. The same device disappeared and reappeared with
+			 *         different name. or
+			 *      b. The missing-disk-which-was-replaced, has
+			 *         reappeared now.
+			 *
+			 * We must allow 1 and 2a above. But 2b would be a spurious
+			 * and unintentional.
+			 *
+			 * Further in case of 1 and 2a above, the disk at 'path'
+			 * would have missed some transaction when it was away and
+			 * in case of 2a the stale bdev has to be updated as well.
+			 * 2b must not be allowed at all time.
+			 */
 
-		/*
-		 * For now, we do allow update to btrfs_fs_device through the
-		 * btrfs dev scan cli after FS has been mounted.  We're still
-		 * tracking a problem where systems fail mount by subvolume id
-		 * when we reject replacement on a mounted FS.
-		 */
-		if (!fs_devices->opened && found_transid < device->generation) {
 			/*
-			 * That is if the FS is _not_ mounted and if you
-			 * are here, that means there is more than one
-			 * disk with same uuid and devid.We keep the one
-			 * with larger generation number or the last-in if
-			 * generation are equal.
+			 * For now, we do allow update to btrfs_fs_device through the
+			 * btrfs dev scan cli after FS has been mounted.  We're still
+			 * tracking a problem where systems fail mount by subvolume id
+			 * when we reject replacement on a mounted FS.
 			 */
-			return -EEXIST;
-		}
+			if (!fs_devices->opened && found_transid < device->generation) {
+				/*
+				 * That is if the FS is _not_ mounted and if you
+				 * are here, that means there is more than one
+				 * disk with same uuid and devid.We keep the one
+				 * with larger generation number or the last-in if
+				 * generation are equal.
+				 */
+				return -EEXIST;
+			}
 
-		name = rcu_string_strdup(path, GFP_NOFS);
-		if (!name)
-			return -ENOMEM;
-		rcu_string_free(device->name);
-		rcu_assign_pointer(device->name, name);
-		if (device->missing) {
-			fs_devices->missing_devices--;
-			device->missing = 0;
+			name = rcu_string_strdup(path, GFP_NOFS);
+			if (!name)
+				return -ENOMEM;
+			rcu_string_free(device->name);
+			rcu_assign_pointer(device->name, name);
+			if (device->missing) {
+				fs_devices->missing_devices--;
+				device->missing = 0;
+			}
 		}
+
+		/*
+		 * device may reappear with new devnum,
+		 * re-insert to keep it up-to-date
+		 */
+		rb_erase(&device->rb_node, &valid_dev_root);
+		device->devnum = devnum;
+		insert_valid_device(device);
 	}
 
 	/*
@@ -609,6 +730,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
+		device->devnum = orig_dev->devnum;
 		fs_devices->num_devices++;
 	}
 	mutex_unlock(&orig->device_list_mutex);
@@ -619,6 +741,15 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
+/*
+ * If @fs_devices is not in global list @fs_uuids,
+ * then it is a cloned btrfs_fs_devices for seeding
+ */
+static int is_cloned_fs_devices(struct btrfs_fs_devices *fs_devices)
+{
+	return list_empty(&fs_devices->list);
+}
+
 void btrfs_close_extra_devices(struct btrfs_fs_info *fs_info,
 			       struct btrfs_fs_devices *fs_devices, int step)
 {
@@ -665,6 +796,10 @@ again:
 				fs_devices->rw_devices--;
 		}
 		list_del_init(&device->dev_list);
+
+		/* skip cloned fs_devices which act as seed devices*/
+		if (!is_cloned_fs_devices(fs_devices))
+			remove_valid_device(device);
 		fs_devices->num_devices--;
 		rcu_string_free(device->name);
 		kfree(device);
@@ -740,6 +875,11 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 		new_device->fs_devices = device->fs_devices;
+		new_device->devnum = device->devnum;
+
+		/* skip cloned fs_devices which act as seed devices*/
+		if (!is_cloned_fs_devices(device->fs_devices))
+			insert_valid_device(new_device);
 
 		call_rcu(&device->rcu, free_device);
 	}
@@ -952,7 +1092,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
 
-	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
+	ret = device_list_add(path, disk_super, bdev->bd_dev,
+				devid, fs_devices_ret);
 	if (ret > 0) {
 		if (disk_super->label[0]) {
 			if (disk_super->label[BTRFS_LABEL_SIZE - 1])
@@ -1682,6 +1823,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 */
 
 	cur_devices = device->fs_devices;
+	remove_valid_device(device);
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_del_rcu(&device->dev_list);
 
@@ -1829,6 +1971,8 @@ void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
 
 	if (srcdev->bdev)
 		fs_devices->open_devices--;
+
+	remove_valid_device(srcdev);
 }
 
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
@@ -1883,6 +2027,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev)
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
 	list_del_rcu(&tgtdev->dev_list);
+	remove_valid_device(tgtdev);
 
 	call_rcu(&tgtdev->rcu, free_device);
 
@@ -1975,12 +2120,22 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 		return PTR_ERR(old_devices);
 	}
 
+	/*
+	 * Here @old_devices represent the fs_devices that will be linked
+	 * in the fs_uuids, and devices in it should be valid.
+	 * All devices in @fs_devices which will be moved into @seed_devices
+	 * and they just act as clones. So replace those clones which sit
+	 * in @dev_map_root for now with valid devices in @old_devices.
+	 */
+	list_for_each_entry(device, &old_devices->devices, dev_list)
+		insert_valid_device(device);
 	list_add(&old_devices->list, &fs_uuids);
 
 	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
 	seed_devices->opened = 1;
 	INIT_LIST_HEAD(&seed_devices->devices);
 	INIT_LIST_HEAD(&seed_devices->alloc_list);
+	INIT_LIST_HEAD(&seed_devices->list);
 	mutex_init(&seed_devices->device_list_mutex);
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
@@ -2178,6 +2333,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 
 	device->fs_devices = root->fs_info->fs_devices;
+	device->devnum = bdev->bd_dev;
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	lock_chunks(root);
@@ -2277,6 +2433,10 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_commit_transaction(trans, root);
 	}
 
+	mutex_lock(&uuid_mutex);
+	replace_invalid_device(device);
+	mutex_unlock(&uuid_mutex);
+
 	/* Update ctime/mtime for libblkid */
 	update_dev_time(device_path);
 	return ret;
@@ -2378,11 +2538,16 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 	device->dev_stats_valid = 1;
 	set_blocksize(device->bdev, 4096);
 	device->fs_devices = fs_info->fs_devices;
+	device->devnum = bdev->bd_dev;
 	list_add(&device->dev_list, &fs_info->fs_devices->devices);
 	fs_info->fs_devices->num_devices++;
 	fs_info->fs_devices->open_devices++;
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
+	mutex_lock(&uuid_mutex);
+	replace_invalid_device(device);
+	mutex_unlock(&uuid_mutex);
+
 	*device_out = device;
 	return ret;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4cc00e6..7b57cc6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -80,6 +80,11 @@ struct btrfs_device {
 	seqcount_t data_seqcount;
 #endif
 
+	struct rb_node rb_node;
+
+	/* node key in valid_dev_root */
+	dev_t devnum;
+
 	/* the internal btrfs device id */
 	u64 devid;
 
@@ -418,6 +423,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
 int btrfs_rm_device(struct btrfs_root *root, char *device_path);
+void btrfs_cleanup_valid_dev_root(void);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
-- 
1.8.1.4

