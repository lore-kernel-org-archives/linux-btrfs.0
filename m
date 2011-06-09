From: Li Dongyang <lidongyang@novell.com>
Subject: [PATCH] Btrfs: add discard flag to btrfs_device and make btrfs_discard_extent aware of that
Date: Thu,  9 Jun 2011 15:28:09 +0800
Message-ID: <1307604489-7884-1-git-send-email-lidongyang@novell.com>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With discard flag in btrfs_device, we will only push trim request to the
devices support that.
Now we don't return EOPNOTSUPP to the caller, so we won't trigger BUG_ONs
in the walk_log_tree functions if we mount a drive without DISCARD
using -o discard, but it is still possible if we get errors from
blkdev_issue_discard.
This won't affect the return value of fstrim on the drives without DISCARD,
because we've already checked that in btrfs_ioctl_fitrim, Thanks

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/btrfs/extent-tree.c |   24 ++++++++++++------------
 fs/btrfs/volumes.c     |    4 ++++
 fs/btrfs/volumes.h     |    1 +
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5b9b6b6..507cf8d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1774,7 +1774,6 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 	u64 discarded_bytes = 0;
 	struct btrfs_multi_bio *multi = NULL;
 
-
 	/* Tell the block device(s) that the sectors can be discarded */
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, REQ_DISCARD,
 			      bytenr, &num_bytes, &multi, 0);
@@ -1782,25 +1781,26 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 		struct btrfs_bio_stripe *stripe = multi->stripes;
 		int i;
 
-
 		for (i = 0; i < multi->num_stripes; i++, stripe++) {
-			ret = btrfs_issue_discard(stripe->dev->bdev,
-						  stripe->physical,
-						  stripe->length);
-			if (!ret)
-				discarded_bytes += stripe->length;
-			else if (ret != -EOPNOTSUPP)
-				break;
+			if (stripe->dev->discard) {
+				ret = btrfs_issue_discard(stripe->dev->bdev,
+							  stripe->physical,
+							  stripe->length);
+				if (!ret)
+					discarded_bytes += stripe->length;
+				else if (ret == -EOPNOTSUPP) {
+					stripe->dev->discard = 0;
+					ret = 0;
+				} else
+					break;
+			}
 		}
 		kfree(multi);
 	}
-	if (discarded_bytes && ret == -EOPNOTSUPP)
-		ret = 0;
 
 	if (actual_bytes)
 		*actual_bytes = discarded_bytes;
 
-
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index da541df..bdf5604 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -341,6 +341,7 @@ static noinline int device_list_add(const char *path,
 		device->work.func = pending_bios_fn;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
+		device->discard = 1;
 		spin_lock_init(&device->io_lock);
 		device->name = kstrdup(path, GFP_NOFS);
 		if (!device->name) {
@@ -408,6 +409,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		device->devid = orig_dev->devid;
 		device->work.func = pending_bios_fn;
 		memcpy(device->uuid, orig_dev->uuid, sizeof(device->uuid));
+		device->discard = 1;
 		spin_lock_init(&device->io_lock);
 		INIT_LIST_HEAD(&device->dev_list);
 		INIT_LIST_HEAD(&device->dev_alloc_list);
@@ -1616,6 +1618,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	lock_chunks(root);
 
 	device->writeable = 1;
+	device->discard = 1;
 	device->work.func = pending_bios_fn;
 	generate_random_uuid(device->uuid);
 	spin_lock_init(&device->io_lock);
@@ -3346,6 +3349,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 		return NULL;
 	list_add(&device->dev_list,
 		 &fs_devices->devices);
+	device->discard = 1;
 	device->dev_root = root->fs_info->dev_root;
 	device->devid = devid;
 	device->work.func = pending_bios_fn;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7c12d61..9f7e56c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -45,6 +45,7 @@ struct btrfs_device {
 	int running_pending;
 	u64 generation;
 
+	int discard;
 	int writeable;
 	int in_fs_metadata;
 	int missing;
-- 
1.7.5.4

