Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48791 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdG0Kzz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 06:55:55 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: use appropriate define for the fsid
Date: Thu, 27 Jul 2017 19:02:36 +0800
Message-Id: <20170727110236.20232-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Though BTRFS_FSID_SIZE and BTRFS_UUID_SIZE or of same size,
for the purpose of doing it correctly use BTRFS_FSID_SIZE instead.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 086dcbadce09..ed840e0cabc5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -529,7 +529,7 @@ static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-	u8 fsid[BTRFS_UUID_SIZE];
+	u8 fsid[BTRFS_FSID_SIZE];
 	int ret = 1;
 
 	read_extent_buffer(eb, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
@@ -3731,7 +3731,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
-		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
+		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
@@ -4172,7 +4172,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		ret = -EINVAL;
 	}
 
-	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
+	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
 			   "dev_item UUID does not match fsid: %pU != %pU",
 			   fs_info->fsid, sb->dev_item.fsid);
-- 
2.13.1

