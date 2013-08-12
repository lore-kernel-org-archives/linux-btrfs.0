Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:44886 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLLd2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 07:33:28 -0400
Received: by mail-la0-f49.google.com with SMTP id ev20so4588447lab.36
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 04:33:27 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 4/4] Btrfs: rollback btrfs_device fields on umount
Date: Mon, 12 Aug 2013 14:33:04 +0300
Message-Id: <1376307184-7175-5-git-send-email-idryomov@gmail.com>
In-Reply-To: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
References: <1376307184-7175-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It turns out we don't properly rollback in-core btrfs_device state on
umount.  We zero out ->bdev, ->in_fs_metadata and that's about it.  In
particular, we don't zero out ->generation, and this can lead to us
refusing a mount -- a non-NULL fs_devices->latest_bdev is essential, but
btrfs_close_extra_devices will happily assign NULL to ->latest_bdev if
the first device on the dev_list happens to be missing and consequently
has no bdev attached.  This happens because since commit a6b0d5c8
btrfs_close_extra_devices adjusts ->latest_bdev, and in doing that,
relies on the ->generation.  Fix this, and possibly other problems, by
zeroing out everything except for what device_list_add sets, so that a
mount right after insmod and 'btrfs dev scan' is no different from any
later mount in this respect.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index af17b17..2f6bc12 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -673,22 +673,19 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		if (device->can_discard)
 			fs_devices->num_can_discard--;
 
-		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
-		BUG_ON(!new_device); /* -ENOMEM */
-		memcpy(new_device, device, sizeof(*new_device));
+		new_device = btrfs_alloc_device(NULL, &device->devid,
+						device->uuid);
+		BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
 
 		/* Safe because we are under uuid_mutex */
 		if (device->name) {
 			name = rcu_string_strdup(device->name->str, GFP_NOFS);
-			BUG_ON(device->name && !name); /* -ENOMEM */
+			BUG_ON(!name); /* -ENOMEM */
 			rcu_assign_pointer(new_device->name, name);
 		}
-		new_device->bdev = NULL;
-		new_device->writeable = 0;
-		new_device->in_fs_metadata = 0;
-		new_device->can_discard = 0;
-		spin_lock_init(&new_device->io_lock);
+
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
+		new_device->fs_devices = device->fs_devices;
 
 		call_rcu(&device->rcu, free_device);
 	}
-- 
1.7.10.4

