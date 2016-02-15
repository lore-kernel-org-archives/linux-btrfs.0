Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbcBORee (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:34 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, anand.jain@oracle.com
Subject: [PATCH 10/15] btrfs: rename __check_raid_min_devices
Date: Mon, 15 Feb 2016 18:34:29 +0100
Message-Id: <f618945b86f4bba6037bd4917a4b461503183f0e.1455556900.git.dsterba@suse.com>
In-Reply-To: <cover.1455556900.git.dsterba@suse.com>
References: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Underscores are for special functions, use the full prefix for better
stacktrace recognition.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 20af20b0eaee..4fa4a836a072 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1705,7 +1705,7 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
 	return ret;
 }
 
-static int __check_raid_min_devices(struct btrfs_fs_info *fs_info)
+static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info)
 {
 	u64 all_avail;
 	u64 num_devices;
@@ -1760,7 +1760,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 
 	mutex_lock(&uuid_mutex);
 
-	ret = __check_raid_min_devices(root->fs_info);
+	ret = btrfs_check_raid_min_devices(root->fs_info);
 	if (ret)
 		goto out;
 
-- 
2.7.1

