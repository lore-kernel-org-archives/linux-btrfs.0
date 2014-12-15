Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33983 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLOUCc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:02:32 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so10287488wiw.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:02:31 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/7] Add verbose option to btrfs_add_to_fsid()
Date: Mon, 15 Dec 2014 21:02:56 +0100
Message-Id: <1418673780-22000-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add verbose option to btrfs_add_to_fsid() in order to avoid to print
the information to console when not needed.
The same information is print in the summary of the mkfs.btrfs command.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c | 7 ++++---
 utils.h | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/utils.c b/utils.c
index 19049bb..dcb4f74 100644
--- a/utils.c
+++ b/utils.c
@@ -610,7 +610,7 @@ static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-		      u32 sectorsize)
+		      u32 sectorsize, int verbose)
 {
 	struct btrfs_super_block *disk_super;
 	struct btrfs_super_block *super = root->fs_info->super_copy;
@@ -659,8 +659,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 
 	memcpy(disk_super, super, sizeof(*disk_super));
 
-	printf("adding device %s id %llu\n", path,
-	       (unsigned long long)device->devid);
+	if (verbose)
+		printf("adding device %s id %llu\n", path,
+		       (unsigned long long)device->devid);
 
 	btrfs_set_super_bytenr(disk_super, BTRFS_SUPER_INFO_OFFSET);
 	btrfs_set_stack_device_id(dev_item, device->devid);
diff --git a/utils.h b/utils.h
index bb8a449..9218199 100644
--- a/utils.h
+++ b/utils.h
@@ -79,7 +79,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-		      u32 sectorsize);
+		      u32 sectorsize, int verbose);
 int btrfs_scan_for_fsid(int run_ioctls);
 int btrfs_register_one_device(const char *fname);
 int btrfs_register_all_devices(void);
-- 
2.1.3

