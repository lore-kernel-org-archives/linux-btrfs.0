Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3CIFXC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Mar 2013 00:23:02 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r295N2bC025875
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 9 Mar 2013 00:23:02 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r295N1OV023042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 9 Mar 2013 00:23:02 -0500
Message-ID: <513AC735.1090500@redhat.com>
Date: Fri, 08 Mar 2013 23:23:01 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] use rcu_barrier() to wait for bdev puts at unmount
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing this would reliably fail with -EBUSY for me:

# mount /dev/sdb2 /mnt/scratch; umount /mnt/scratch; mkfs.btrfs -f /dev/sdb2
...
unable to open /dev/sdb2: Device or resource busy

because mkfs.btrfs tries to open the device O_EXCL, and somebody still has it.

Using systemtap to track bdev gets & puts shows a kworker thread doing a
blkdev put after mkfs attempts a get; this is left over from the unmount.

Adding an rcu_barrier() to btrfs_close_devices() causes unmount to wait
until all blkdev_put()s are done, and the device is truly free once
unmount completes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. I debated putting it into close_ctree(); I don't know if there' anything
else to wait for.  Thoughts?

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cbb7f4..258316a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -680,6 +680,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		__btrfs_close_devices(fs_devices);
 		free_fs_devices(fs_devices);
 	}
+	rcu_barrier();
 	return ret;
 }
 

