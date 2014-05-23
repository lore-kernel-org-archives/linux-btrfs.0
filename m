Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaEWUHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 16:07:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 04CDFAC77
	for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 20:07:41 +0000 (UTC)
Message-ID: <537FAA8B.3060402@suse.com>
Date: Fri, 23 May 2014 16:07:39 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: handle add/remove of sysfs links when devices are
 added/removed
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


btrfs currently publishes device membership via sysfs based on the devices
present when the file system is mounted. That publishing is not updated
when devices are added or removed while mounted.

This patch handles those events.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1704,6 +1704,9 @@ int btrfs_rm_device(struct btrfs_root *r
 
 	ret = 0;
 
+	sysfs_remove_link(root->fs_info->device_dir_kobj,
+			  part_to_dev(bdev->bd_part)->kobj.name);
+
 	/* Notify udev that device has changed */
 	if (bdev)
 		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
@@ -2038,6 +2041,12 @@ int btrfs_init_new_device(struct btrfs_r
 		goto error;
 	}
 
+	ret = sysfs_create_link(root->fs_info->device_dir_kobj,
+				&part_to_dev(bdev->bd_part)->kobj,
+				part_to_dev(bdev->bd_part)->kobj.name);
+	if (ret)
+		goto error;
+
 	lock_chunks(root);
 
 	q = bdev_get_queue(bdev);
@@ -2152,6 +2161,8 @@ error_trans:
 	unlock_chunks(root);
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
+	sysfs_remove_link(root->fs_info->device_dir_kobj,
+			  part_to_dev(bdev->bd_part)->kobj.name);
 	kfree(device);
 error:
 	blkdev_put(bdev, FMODE_EXCL);

-- 
Jeff Mahoney
SUSE Labs
