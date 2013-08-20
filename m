Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:43603 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3HTLUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 06/12] Btrfs: Make btrfs_device_fsid() return unsigned long
Date: Tue, 20 Aug 2013 13:20:12 +0200
Message-Id: <1376997618-13573-7-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers of btrfs_device_fsid() cast its return type to unsigned long.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ctree.h   |    4 ++--
 fs/btrfs/volumes.c |    8 +++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2771f88..641a29a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2135,9 +2135,9 @@ static inline unsigned long btrfs_device_uuid(struct btrfs_dev_item *d)
 	return (unsigned long)d + offsetof(struct btrfs_dev_item, uuid);
 }
 
-static inline char *btrfs_device_fsid(struct btrfs_dev_item *d)
+static inline unsigned long btrfs_device_fsid(struct btrfs_dev_item *d)
 {
-	return (char *)d + offsetof(struct btrfs_dev_item, fsid);
+	return (unsigned long)d + offsetof(struct btrfs_dev_item, fsid);
 }
 
 BTRFS_SETGET_FUNCS(chunk_length, struct btrfs_chunk, length, 64);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9abffc1..b05dbb6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1392,7 +1392,7 @@ static int btrfs_add_device(struct btrfs_trans_handle *trans,
 
 	ptr = btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
-	ptr = (unsigned long)btrfs_device_fsid(dev_item);
+	ptr = btrfs_device_fsid(dev_item);
 	write_extent_buffer(leaf, root->fs_info->fsid, ptr, BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -1890,8 +1890,7 @@ next_slot:
 		devid = btrfs_device_id(leaf, dev_item);
 		read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 				   BTRFS_UUID_SIZE);
-		read_extent_buffer(leaf, fs_uuid,
-				   (unsigned long)btrfs_device_fsid(dev_item),
+		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_UUID_SIZE);
 		device = btrfs_find_device(root->fs_info, devid, dev_uuid,
 					   fs_uuid);
@@ -5497,8 +5496,7 @@ static int read_one_dev(struct btrfs_root *root,
 	devid = btrfs_device_id(leaf, dev_item);
 	read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
-	read_extent_buffer(leaf, fs_uuid,
-			   (unsigned long)btrfs_device_fsid(dev_item),
+	read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 			   BTRFS_UUID_SIZE);
 
 	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
-- 
1.7.9.5

