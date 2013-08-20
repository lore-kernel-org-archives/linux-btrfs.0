Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:38165 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3HTLUk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 05/12] Btrfs: Make btrfs_device_uuid() return unsigned long
Date: Tue, 20 Aug 2013 13:20:11 +0200
Message-Id: <1376997618-13573-6-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers of btrfs_device_uuid() cast its return type to unsigned long.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ctree.h   |    4 ++--
 fs/btrfs/volumes.c |   10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2ab606c..2771f88 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2130,9 +2130,9 @@ BTRFS_SETGET_STACK_FUNCS(stack_device_bandwidth, struct btrfs_dev_item,
 BTRFS_SETGET_STACK_FUNCS(stack_device_generation, struct btrfs_dev_item,
 			 generation, 64);
 
-static inline char *btrfs_device_uuid(struct btrfs_dev_item *d)
+static inline unsigned long btrfs_device_uuid(struct btrfs_dev_item *d)
 {
-	return (char *)d + offsetof(struct btrfs_dev_item, uuid);
+	return (unsigned long)d + offsetof(struct btrfs_dev_item, uuid);
 }
 
 static inline char *btrfs_device_fsid(struct btrfs_dev_item *d)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bdad547..9abffc1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1390,7 +1390,7 @@ static int btrfs_add_device(struct btrfs_trans_handle *trans,
 	btrfs_set_device_bandwidth(leaf, dev_item, 0);
 	btrfs_set_device_start_offset(leaf, dev_item, 0);
 
-	ptr = (unsigned long)btrfs_device_uuid(dev_item);
+	ptr = btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = (unsigned long)btrfs_device_fsid(dev_item);
 	write_extent_buffer(leaf, root->fs_info->fsid, ptr, BTRFS_UUID_SIZE);
@@ -1888,8 +1888,7 @@ next_slot:
 		dev_item = btrfs_item_ptr(leaf, path->slots[0],
 					  struct btrfs_dev_item);
 		devid = btrfs_device_id(leaf, dev_item);
-		read_extent_buffer(leaf, dev_uuid,
-				   (unsigned long)btrfs_device_uuid(dev_item),
+		read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid,
 				   (unsigned long)btrfs_device_fsid(dev_item),
@@ -5433,7 +5432,7 @@ static void fill_device_from_item(struct extent_buffer *leaf,
 	WARN_ON(device->devid == BTRFS_DEV_REPLACE_DEVID);
 	device->is_tgtdev_for_dev_replace = 0;
 
-	ptr = (unsigned long)btrfs_device_uuid(dev_item);
+	ptr = btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 }
 
@@ -5496,8 +5495,7 @@ static int read_one_dev(struct btrfs_root *root,
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 
 	devid = btrfs_device_id(leaf, dev_item);
-	read_extent_buffer(leaf, dev_uuid,
-			   (unsigned long)btrfs_device_uuid(dev_item),
+	read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
 	read_extent_buffer(leaf, fs_uuid,
 			   (unsigned long)btrfs_device_fsid(dev_item),
-- 
1.7.9.5

