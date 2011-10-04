From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 27/65] btrfs: fill_device_from_item should return void
Date: Mon, 03 Oct 2011 23:22:57 -0400
Message-ID: <20111004032303.016599608@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
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
@@ -3488,7 +3488,7 @@ static int read_one_chunk(struct btrfs_r
 	return 0;
 }
 
-static int fill_device_from_item(struct extent_buffer *leaf,
+static void fill_device_from_item(struct extent_buffer *leaf,
 				 struct btrfs_dev_item *dev_item,
 				 struct btrfs_device *device)
 {
@@ -3505,8 +3505,6 @@ static int fill_device_from_item(struct
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
-
-	return 0;
 }
 
 static int open_seed_devices(struct btrfs_root *root, u8 *fsid)


