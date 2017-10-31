Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52825 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdJaRq0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69266AD95
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/11] btrfs: rename device free rcu helper to free_device_rcu
Date: Tue, 31 Oct 2017 18:44:36 +0100
Message-Id: <696fed65f091dd89673d09ddc2bff230c097bba3.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make it clear that it is an RCU helper, we want to use the name
free_device for a wrapper freeing all device members.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 08fb4b5609b7..ab03e712aa49 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -825,7 +825,7 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
 	mutex_unlock(&uuid_mutex);
 }
 
-static void free_device(struct rcu_head *head)
+static void free_device_rcu(struct rcu_head *head)
 {
 	struct btrfs_device *device;
 
@@ -907,7 +907,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 				struct btrfs_device, dev_list);
 		list_del(&device->dev_list);
 		btrfs_close_bdev(device);
-		call_rcu(&device->rcu, free_device);
+		call_rcu(&device->rcu, free_device_rcu);
 	}
 
 	WARN_ON(fs_devices->open_devices);
@@ -1938,7 +1938,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		btrfs_scratch_superblocks(device->bdev, device->name->str);
 
 	btrfs_close_bdev(device);
-	call_rcu(&device->rcu, free_device);
+	call_rcu(&device->rcu, free_device_rcu);
 
 	if (cur_devices->open_devices == 0) {
 		struct btrfs_fs_devices *fs_devices;
@@ -2009,7 +2009,7 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 	}
 
 	btrfs_close_bdev(srcdev);
-	call_rcu(&srcdev->rcu, free_device);
+	call_rcu(&srcdev->rcu, free_device_rcu);
 
 	/* if this is no devs we rather delete the fs_devices */
 	if (!fs_devices->num_devices) {
@@ -2068,7 +2068,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	btrfs_scratch_superblocks(tgtdev->bdev, tgtdev->name->str);
 
 	btrfs_close_bdev(tgtdev);
-	call_rcu(&tgtdev->rcu, free_device);
+	call_rcu(&tgtdev->rcu, free_device_rcu);
 }
 
 static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
-- 
2.14.0

