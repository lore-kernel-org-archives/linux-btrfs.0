Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35514 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751584AbeDCSge (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:36:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51212ABC9
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:36:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/16] btrfs: make success path out of btrfs_init_dev_replace_tgtdev more clear
Date: Tue,  3 Apr 2018 20:34:06 +0200
Message-Id: <21dd8dd69ac4cfd2fb97474421cc50736ba7876c.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparatory cleanup that will make clear that the only
successful way out of btrfs_init_dev_replace_tgtdev will also set the
device_out to a valid pointer. With this guarantee, the callers can be
simplified.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 1 -
 fs/btrfs/volumes.c     | 8 +++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index c0397cd2a3ba..e3b8a79c1665 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -370,7 +370,6 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 	dev_replace->cont_reading_from_srcdev_mode = read_src;
 	WARN_ON(!src_device);
 	dev_replace->srcdev = src_device;
-	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
 	btrfs_info_in_rcu(fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 93f8f17cacca..8086c5687b72 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2592,6 +2592,12 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	return ret;
 }
 
+/*
+ * Initialize a new device for device replace target from a given source dev
+ * and path.
+ *
+ * Return 0 and new device in @device_out, otherwise return < 0
+ */
 int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				  const char *device_path,
 				  struct btrfs_device *srcdev,
@@ -2678,7 +2684,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 	*device_out = device;
-	return ret;
+	return 0;
 
 error:
 	blkdev_put(bdev, FMODE_EXCL);
-- 
2.16.2

