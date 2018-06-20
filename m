Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754417AbeFTRyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:31 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs: reorder initialization before the mount locks uuid_mutex
Date: Wed, 20 Jun 2018 19:51:40 +0200
Message-Id: <c501e3ab67e55bbd71f07de9c0981eec19d49d3c.1529516228.git.dsterba@suse.com>
In-Reply-To: <cover.1529516226.git.dsterba@suse.com>
References: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to take a big lock, move resource initialization before
the critical section. It's not obvious from the diff, the desired order
is:

- initialize mount security options
- allocate temporary fs_info
- allocate superblock buffers

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e3324ddf2777..1780eb41f203 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1528,14 +1528,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
-	mutex_lock(&uuid_mutex);
-	error = btrfs_parse_early_options(data, mode, fs_type,
-					  &fs_devices);
-	mutex_unlock(&uuid_mutex);
-	if (error) {
-		return ERR_PTR(error);
-	}
-
 	security_init_mnt_opts(&new_sec_opts);
 	if (data) {
 		error = parse_security_options(data, &new_sec_opts);
@@ -1543,12 +1535,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 			return ERR_PTR(error);
 	}
 
-	mutex_lock(&uuid_mutex);
-	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
-	mutex_unlock(&uuid_mutex);
-	if (error)
-		goto error_sec_opts;
-
 	/*
 	 * Setup a dummy root and fs_info for test/set super.  This is because
 	 * we don't actually fill this stuff out until open_ctree, but we need
@@ -1561,8 +1547,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_sec_opts;
 	}
 
-	fs_info->fs_devices = fs_devices;
-
 	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
 	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
 	security_init_mnt_opts(&fs_info->security_opts);
@@ -1571,6 +1555,20 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_fs_info;
 	}
 
+	mutex_lock(&uuid_mutex);
+	error = btrfs_parse_early_options(data, mode, fs_type, &fs_devices);
+	mutex_unlock(&uuid_mutex);
+	if (error)
+		goto error_fs_info;
+
+	mutex_lock(&uuid_mutex);
+	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
+	mutex_unlock(&uuid_mutex);
+	if (error)
+		goto error_fs_info;
+
+	fs_info->fs_devices = fs_devices;
+
 	mutex_lock(&uuid_mutex);
 	error = btrfs_open_devices(fs_devices, mode, fs_type);
 	mutex_unlock(&uuid_mutex);
-- 
2.17.0

