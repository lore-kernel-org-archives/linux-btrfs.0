Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754490AbeFTRyd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:33 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 7/7] btrfs: fix mount and ioctl device scan ioctl race
Date: Wed, 20 Jun 2018 19:51:42 +0200
Message-Id: <4c223e9ba6d3ab54f9b41678bade731e5554d0a6.1529516229.git.dsterba@suse.com>
In-Reply-To: <cover.1529516226.git.dsterba@suse.com>
References: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Technically this extends the critical section covered by uuid_mutex to:

- parse early mount options -- here we can call device scan on paths
  that can be passed as 'device=/dev/...'

- scan the device passed to mount

- open the devices related to the fs_devices -- this increases
  fs_devices::opened

The race can happen when mount calls one of the scans and there's
another one called eg. by mkfs or 'btrfs dev scan':

Mount                                  Scan
-----                                  ----
scan_one_device (dev1, fsid1)
                                       scan_one_device (dev2, fsid2)
				           add the device
					   free stale devices
					       fsid1 fs_devices::opened == 0
					           find fsid1:dev1
					           free fsid1:dev1
					           if it's the last one,
					            free fs_devices of fsid1
						    too

open_devices (dev1, fsid1)
   dev1 not found

When fixed, the uuid mutex will make sure that mount will increase
fs_devices::opened and this will not be touched by the racing scan
ioctl.

Reported-and-tested-by: syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1780eb41f203..b13b871bc584 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1557,19 +1557,19 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 
 	mutex_lock(&uuid_mutex);
 	error = btrfs_parse_early_options(data, mode, fs_type, &fs_devices);
-	mutex_unlock(&uuid_mutex);
-	if (error)
+	if (error) {
+		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
+	}
 
-	mutex_lock(&uuid_mutex);
 	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
-	mutex_unlock(&uuid_mutex);
-	if (error)
+	if (error) {
+		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
+	}
 
 	fs_info->fs_devices = fs_devices;
 
-	mutex_lock(&uuid_mutex);
 	error = btrfs_open_devices(fs_devices, mode, fs_type);
 	mutex_unlock(&uuid_mutex);
 	if (error)
-- 
2.17.0

