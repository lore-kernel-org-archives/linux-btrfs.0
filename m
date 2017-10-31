Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52845 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932373AbdJaRqd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 16AF2ABF4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/11] btrfs: simplify exit paths in btrfs_init_new_device
Date: Tue, 31 Oct 2017 18:44:42 +0100
Message-Id: <01ee88e7c85d15d62a8bf1bf94300226238bcb79.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f206e83d4f52..75aed8ec64bd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2344,17 +2344,15 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	name = rcu_string_strdup(device_path, GFP_KERNEL);
 	if (!name) {
-		free_device(device);
 		ret = -ENOMEM;
-		goto error;
+		goto error_free_device;
 	}
 	rcu_assign_pointer(device->name, name);
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
-		free_device(device);
 		ret = PTR_ERR(trans);
-		goto error;
+		goto error_free_device;
 	}
 
 	q = bdev_get_queue(bdev);
@@ -2494,6 +2492,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		sb->s_flags |= MS_RDONLY;
 	if (trans)
 		btrfs_end_transaction(trans);
+error_free_device:
 	free_device(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.14.0

