Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56721 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3JaE1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 00:27:44 -0400
Received: by mail-ie0-f182.google.com with SMTP id as1so4039696iec.27
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 21:27:44 -0700 (PDT)
Received: from dshgna ([124.43.179.229])
        by mx.google.com with ESMTPSA id p7sm1477058iga.3.2013.10.30.21.27.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 30 Oct 2013 21:27:43 -0700 (PDT)
Date: Thu, 31 Oct 2013 09:57:33 +0530
From: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: Pack struct btrfs_device
Message-ID: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pack the structure btrfs_device in volumes.h to eliminate holes detected
by pahole, thus reducing binary memory footprint.

Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Reviewed-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/volumes.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b72f540..8d939ea 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -43,9 +43,8 @@ struct btrfs_device {
 	/* WRITE_SYNC bios */
 	struct btrfs_pending_bios pending_sync_bios;
 
-	int running_pending;
 	u64 generation;
-
+	int running_pending;
 	int writeable;
 	int in_fs_metadata;
 	int missing;
@@ -53,11 +52,11 @@ struct btrfs_device {
 	int is_tgtdev_for_dev_replace;
 
 	spinlock_t io_lock;
+	/* the mode sent to blkdev_get */
+	fmode_t mode;
 
 	struct block_device *bdev;
 
-	/* the mode sent to blkdev_get */
-	fmode_t mode;
 
 	struct rcu_string *name;
 
@@ -78,16 +77,21 @@ struct btrfs_device {
 
 	/* optimal io width for this device */
 	u32 io_width;
+	/* type and info about this device */
+	u64 type;
 
 	/* minimal io size for this device */
 	u32 sector_size;
 
-	/* type and info about this device */
-	u64 type;
 
 	/* physical drive uuid (or lvm uuid) */
 	u8 uuid[BTRFS_UUID_SIZE];
 
+	/* for sending down flush barriers */
+	int nobarriers;
+	struct bio *flush_bio;
+	struct completion flush_wait;
+
 	/* per-device scrub information */
 	struct scrub_ctx *scrub_device;
 
@@ -103,10 +107,6 @@ struct btrfs_device {
 	struct radix_tree_root reada_zones;
 	struct radix_tree_root reada_extents;
 
-	/* for sending down flush barriers */
-	struct bio *flush_bio;
-	struct completion flush_wait;
-	int nobarriers;
 
 	/* disk I/O failure stats. For detailed description refer to
 	 * enum btrfs_dev_stat_values in ioctl.h */
-- 
1.8.1.2

