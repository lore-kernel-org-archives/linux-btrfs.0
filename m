Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46671 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754295AbeFTRy0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:26 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs: lift uuid_mutex to callers of btrfs_open_devices
Date: Wed, 20 Jun 2018 19:51:35 +0200
Message-Id: <10602be89b1e8b940353fa64dfda47b6c27b14fa.1529516228.git.dsterba@suse.com>
In-Reply-To: <cover.1529516226.git.dsterba@suse.com>
References: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Prepartory work to fix race between mount and device scan.

The callers will have to manage the critical section, eg.  mount wants
to scan and then call btrfs_open_devices without the ioctl scan walking
in and modifying the fs devices in the meantime.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c   | 2 ++
 fs/btrfs/volumes.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 735402ed3154..ee82d02f5453 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1569,7 +1569,9 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_fs_info;
 	}
 
+	mutex_lock(&uuid_mutex);
 	error = btrfs_open_devices(fs_devices, mode, fs_type);
+	mutex_unlock(&uuid_mutex);
 	if (error)
 		goto error_fs_info;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 958bfe1a725c..5336d9832ba4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1145,7 +1145,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 {
 	int ret;
 
-	mutex_lock(&uuid_mutex);
+	lockdep_assert_held(&uuid_mutex);
+
 	mutex_lock(&fs_devices->device_list_mutex);
 	if (fs_devices->opened) {
 		fs_devices->opened++;
@@ -1155,7 +1156,6 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		ret = open_fs_devices(fs_devices, flags, holder);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
-	mutex_unlock(&uuid_mutex);
 
 	return ret;
 }
-- 
2.17.0

