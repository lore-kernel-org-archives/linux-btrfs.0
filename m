Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754417AbeFTRy2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:28 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
Date: Wed, 20 Jun 2018 19:51:38 +0200
Message-Id: <70e9faa71c1360e0f28db4031b0c2796d35f2cc9.1529516228.git.dsterba@suse.com>
In-Reply-To: <cover.1529516226.git.dsterba@suse.com>
References: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Prepartory work to fix race between mount and device scan.

btrfs_parse_early_options calls the device scan from mount and we'll
need to let mount completely manage the critical section.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ee82d02f5453..e3324ddf2777 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -892,6 +892,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	char *device_name, *opts, *orig, *p;
 	int error = 0;
 
+	lockdep_assert_held(&uuid_mutex);
+
 	if (!options)
 		return 0;
 
@@ -917,10 +919,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 				error = -ENOMEM;
 				goto out;
 			}
-			mutex_lock(&uuid_mutex);
 			error = btrfs_scan_one_device(device_name,
 					flags, holder, fs_devices);
-			mutex_unlock(&uuid_mutex);
 			kfree(device_name);
 			if (error)
 				goto out;
@@ -1528,8 +1528,10 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
+	mutex_lock(&uuid_mutex);
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &fs_devices);
+	mutex_unlock(&uuid_mutex);
 	if (error) {
 		return ERR_PTR(error);
 	}
-- 
2.17.0

