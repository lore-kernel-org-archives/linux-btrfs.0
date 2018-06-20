Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754144AbeFTRyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:22 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/7] btrfs: extend critical section when scanning a new device
Date: Wed, 20 Jun 2018 19:51:31 +0200
Message-Id: <92caa5382783c709d6ddab7d06747327bd7c120c.1529516228.git.dsterba@suse.com>
In-Reply-To: <cover.1529516226.git.dsterba@suse.com>
References: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The stale device list removal needs to be protected by device_list_mutex
too as this could delete from the list and could race with another list
modification and cause crash.

The device needs to be fully initialized before it's added to the list
so the fs_devices also need to be set under the mutex.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1da162928d1a..02246f9af0a3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -791,12 +791,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		rcu_assign_pointer(device->name, name);
 
 		mutex_lock(&fs_devices->device_list_mutex);
+		device->fs_devices = fs_devices;
 		list_add_rcu(&device->dev_list, &fs_devices->devices);
 		fs_devices->num_devices++;
-		mutex_unlock(&fs_devices->device_list_mutex);
-
-		device->fs_devices = fs_devices;
 		btrfs_free_stale_devices(path, device);
+		mutex_unlock(&fs_devices->device_list_mutex);
 
 		if (disk_super->label[0])
 			pr_info("BTRFS: device label %s devid %llu transid %llu %s\n",
-- 
2.17.0

