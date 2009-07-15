From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] properly update space information after shrinking device.
Date: Wed, 15 Jul 2009 15:33:48 +0800
Message-ID: <4A5D865C.7090406@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

change 'goto done' to 'break' for the case of all device extents have
been freed, so that the code updates space information will be execute.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/volumes.c 2/fs/btrfs/volumes.c
--- 1/fs/btrfs/volumes.c	2009-06-12 21:32:39.847088561 +0800
+++ 2/fs/btrfs/volumes.c	2009-07-15 14:49:41.064455477 +0800
@@ -2007,7 +2007,7 @@ int btrfs_shrink_device(struct btrfs_dev
 			goto done;
 		if (ret) {
 			ret = 0;
-			goto done;
+			break;
 		}
 
 		l = path->nodes[0];
@@ -2015,7 +2015,7 @@ int btrfs_shrink_device(struct btrfs_dev
 		btrfs_item_key_to_cpu(l, &key, path->slots[0]);
 
 		if (key.objectid != device->devid)
-			goto done;
+			break;
 
 		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
 		length = btrfs_dev_extent_length(l, dev_extent);
