Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64386 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdITGSy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 02:18:54 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, rich@shroop.net, rrauenza@gmail.com
Subject: [PATCH] btrfs: Remove WARN_ON for unaligned device created before v4.13 and adds more user friendly output
Date: Wed, 20 Sep 2017 15:18:43 +0900
Message-Id: <20170920061843.9016-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 7dfb8be11b5d ("btrfs: Round down values which are written for
total_bytes_size") is fixing the unaligned device size caused by
adding/shrinking device.

It added a new WARN_ON() when device size is unaligned.
This is fine for new device added to btrfs using v4.13 kernel, but not
existing device whose total_bytes is already unaligned.

And the WARN_ON() will get triggered every time a block group get
created/removed on the unaligned device.

This patch will remove the WARN_ON(), and warn user more gently what's
happening and how to fix it.

Reported-by: Rich Rauenzahn <rich@shroop.net>
Fixes: 7dfb8be11b5d ("btrfs: Round down values which are written for
total_bytes_size")
Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/ctree.h   |  1 -
 fs/btrfs/volumes.c | 16 ++++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5a8933da39a7..4de9269e435a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1562,7 +1562,6 @@ static inline void btrfs_set_device_total_bytes(struct extent_buffer *eb,
 {
 	BUILD_BUG_ON(sizeof(u64) !=
 		     sizeof(((struct btrfs_dev_item *)0))->total_bytes);
-	WARN_ON(!IS_ALIGNED(val, eb->fs_info->sectorsize));
 	btrfs_set_64(eb, s, offsetof(struct btrfs_dev_item, total_bytes), val);
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..afae25df6a8c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6472,15 +6472,23 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	return 0;
 }
 
-static void fill_device_from_item(struct extent_buffer *leaf,
-				 struct btrfs_dev_item *dev_item,
-				 struct btrfs_device *device)
+static void fill_device_from_item(struct btrfs_fs_info *fs_info,
+				  struct extent_buffer *leaf,
+				  struct btrfs_dev_item *dev_item,
+				  struct btrfs_device *device)
 {
 	unsigned long ptr;
 
 	device->devid = btrfs_device_id(leaf, dev_item);
 	device->disk_total_bytes = btrfs_device_total_bytes(leaf, dev_item);
 	device->total_bytes = device->disk_total_bytes;
+	if (!IS_ALIGNED(device->total_bytes, fs_info->sectorsize)) {
+		btrfs_warn(fs_info,
+			   "devid %llu has unaligned total bytes %llu",
+			   device->devid, device->disk_total_bytes);
+		btrfs_warn(fs_info,
+			   "please shrink the device a little and resize back to fix it");
+	}
 	device->commit_total_bytes = device->disk_total_bytes;
 	device->bytes_used = btrfs_device_bytes_used(leaf, dev_item);
 	device->commit_bytes_used = device->bytes_used;
@@ -6625,7 +6633,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			return -EINVAL;
 	}
 
-	fill_device_from_item(leaf, dev_item, device);
+	fill_device_from_item(fs_info, leaf, dev_item, device);
 	device->in_fs_metadata = 1;
 	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
-- 
2.14.1

