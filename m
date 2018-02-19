Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752973AbeBSQ0d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 11:26:33 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3A2CAC12
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Feb 2018 16:26:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: add (the only possible) __exit annotation
Date: Mon, 19 Feb 2018 17:24:15 +0100
Message-Id: <b1d9cc2ade8253fb6ee6999006af6c403e91ff2c.1519057258.git.dsterba@suse.com>
In-Reply-To: <cover.1519057258.git.dsterba@suse.com>
References: <cover.1519057258.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recently, the __init annotations have been added. There's unfortunatelly
only one case where we can add __exit, because most of the cleanup
helpers are also called from the __init phase.

As the __exit annotated functions get discarded completely for a
built-in code, we'd miss them from the init phase.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 fs/btrfs/volumes.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2c0c08ec987a..797e7706e67b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -279,7 +279,7 @@ static void btrfs_kobject_uevent(struct block_device *bdev,
 			&disk_to_dev(bdev->bd_disk)->kobj);
 }
 
-void btrfs_cleanup_fs_uuids(void)
+void __exit btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index d110fb03ec0d..d28f5745fee2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -436,7 +436,7 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u8 *uuid);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		    const char *device_path, u64 devid);
-void btrfs_cleanup_fs_uuids(void);
+void __exit btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
-- 
2.16.1

