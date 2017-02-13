Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41805 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752366AbdBMJe6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:58 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D17C8AC53
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 20/29] btrfs: remove unused parameter from init_first_rw_device
Date: Mon, 13 Feb 2017 10:34:22 +0100
Message-Id: <39fee9c2119a4075d840eecc930330b400ae4e0b.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'device' used to be added in that function, but now it's done by the
caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d234625e4e02..1fac98728814 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -134,8 +134,7 @@ const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES] = {
 };
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
-				struct btrfs_device *device);
+				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
 static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
@@ -2440,7 +2439,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 
 	if (seeding_dev) {
 		mutex_lock(&fs_info->chunk_mutex);
-		ret = init_first_rw_device(trans, fs_info, device);
+		ret = init_first_rw_device(trans, fs_info);
 		mutex_unlock(&fs_info->chunk_mutex);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -5012,8 +5011,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 }
 
 static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info,
-					 struct btrfs_device *device)
+					 struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	u64 chunk_offset;
-- 
2.10.1

