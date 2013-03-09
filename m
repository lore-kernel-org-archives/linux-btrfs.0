Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758605Ab3CIPSk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Mar 2013 10:18:40 -0500
Message-ID: <513B52CF.4090307@redhat.com>
Date: Sat, 09 Mar 2013 09:18:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: stable@vger.kernel.org
Subject: [PATCH V2] btrfs: use rcu_barrier() to wait for bdev puts at unmount
References: <513AC735.1090500@redhat.com>
In-Reply-To: <513AC735.1090500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing this would reliably fail with -EBUSY for me:

# mount /dev/sdb2 /mnt/scratch; umount /mnt/scratch; mkfs.btrfs -f /dev/sdb2
...
unable to open /dev/sdb2: Device or resource busy

because mkfs.btrfs tries to open the device O_EXCL, and somebody still has it.

Using systemtap to track bdev gets & puts shows a kworker thread doing a
blkdev put after mkfs attempts a get; this is left over from the unmount
path:

btrfs_close_devices
	__btrfs_close_devices
		call_rcu(&device->rcu, free_device);
			free_device
				INIT_WORK(&device->rcu_work, __free_device);
				schedule_work(&device->rcu_work);

so unmount might complete before __free_device fires & does its blkdev_put.

Adding an rcu_barrier() to btrfs_close_devices() causes unmount to wait
until all blkdev_put()s are done, and the device is truly free once
unmount completes.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: expand commit msg, add code comment, cc: stable

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cbb7f4..92a8bfc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -680,6 +680,12 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		__btrfs_close_devices(fs_devices);
 		free_fs_devices(fs_devices);
 	}
+	/*
+	 * Wait for rcu kworkers under __btrfs_close_devices
+	 * to finish all blkdev_puts so device is really
+	 * free when umount is done.
+	 */
+	rcu_barrier();
 	return ret;
 }
 


