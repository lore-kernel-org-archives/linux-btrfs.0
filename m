From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 02/10] btrfs: fix memleak in btrfs_init_new_device
Date: Wed, 04 Nov 2009 14:03:48 -0500
Message-ID: <20091104190432.526063543@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 If find_next_devid fails, btrfs_init_new_device frees device but
 not device->name.

 This patch fixes it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1474,6 +1474,7 @@ int btrfs_init_new_device(struct btrfs_r
 
 	ret = find_next_devid(root, &device->devid);
 	if (ret) {
+		kfree(device->name);
 		kfree(device);
 		goto error;
 	}

