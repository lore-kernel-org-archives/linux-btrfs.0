From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 48/99] btrfs: fill_device_from_item should return void
Date: Wed, 23 Nov 2011 19:36:21 -0500
Message-ID: <20111124004225.374327439@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 fill_device_from_item has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3513,7 +3513,7 @@ static int read_one_chunk(struct btrfs_r
 	return 0;
 }
 
-static int fill_device_from_item(struct extent_buffer *leaf,
+static void fill_device_from_item(struct extent_buffer *leaf,
 				 struct btrfs_dev_item *dev_item,
 				 struct btrfs_device *device)
 {
@@ -3530,8 +3530,6 @@ static int fill_device_from_item(struct
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
-
-	return 0;
 }
 
 static int open_seed_devices(struct btrfs_root *root, u8 *fsid)



