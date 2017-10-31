Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932447AbdJaRqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5AC06ABF4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:43 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/11] btrfs: switch to RCU for device traversal in btrfs_ioctl_fs_info
Date: Tue, 31 Oct 2017 18:44:54 +0100
Message-Id: <65eaabff6a9b481c39aceebd6eb4c79454e2152f.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to use the mutex as we do not modify the devices nor the
list itself and just read information about device counts.
Move copying fsid out of the protected section, not applicable to RCU
same as the rest of the retrieved information.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f0a3308a72c5..b15973cde0b6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2753,16 +2753,16 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	if (!fi_args)
 		return -ENOMEM;
 
-	mutex_lock(&fs_devices->device_list_mutex);
+	rcu_read_lock();
 	fi_args->num_devices = fs_devices->num_devices;
-	memcpy(&fi_args->fsid, fs_info->fsid, sizeof(fi_args->fsid));
 
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
 		if (device->devid > fi_args->max_id)
 			fi_args->max_id = device->devid;
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
+	rcu_read_unlock();
 
+	memcpy(&fi_args->fsid, fs_info->fsid, sizeof(fi_args->fsid));
 	fi_args->nodesize = fs_info->nodesize;
 	fi_args->sectorsize = fs_info->sectorsize;
 	fi_args->clone_alignment = fs_info->sectorsize;
-- 
2.14.0

