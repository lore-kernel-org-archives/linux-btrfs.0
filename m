From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: make btrfs_rm_device() fail gracefully
Date: Tue, 15 Feb 2011 20:14:25 +0200
Message-ID: <20110215181425.GB9110@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If shrinking done as part of the online device removal fails add that
device back to the allocation list and increment the rw_devices counter.
This fixes two bugs:

1) we could have a perfectly good device out of alloc list for no good
reason;

2) in the btrfs consisting of two devices, failure in btrfs_rm_device()
could lead to a situation where it was impossible to remove any of the
devices because of the "unable to remove the only writeable device"
error.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a228f63..172e0ad 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1338,11 +1338,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	ret = btrfs_shrink_device(device, 0);
 	if (ret)
-		goto error_brelse;
+		goto error_undo;
 
 	ret = btrfs_rm_dev_item(root->fs_info->chunk_root, device);
 	if (ret)
-		goto error_brelse;
+		goto error_undo;
 
 	device->in_fs_metadata = 0;
 
@@ -1416,6 +1416,13 @@ out:
 	mutex_unlock(&root->fs_info->volume_mutex);
 	mutex_unlock(&uuid_mutex);
 	return ret;
+error_undo:
+	if (device->writeable) {
+		list_add(&device->dev_alloc_list,
+			 &root->fs_info->fs_devices->alloc_list);
+		root->fs_info->fs_devices->rw_devices++;
+	}
+	goto error_brelse;
 }
 
 /*
-- 
1.7.2.3

