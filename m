Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab3DDUpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 16:45:10 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r34Kj9YE026560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 16:45:10 -0400
Message-ID: <515DE654.6000700@redhat.com>
Date: Thu, 04 Apr 2013 15:45:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Safranek <jsafrane@redhat.com>
Subject: [PATCH V3] btrfs: ignore device open failures in __btrfs_open_devices
References: <515D9DDE.5040306@redhat.com> <515DAB1F.2050308@redhat.com>
In-Reply-To: <515DAB1F.2050308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This:

   # mkfs.btrfs /dev/sdb{1,2} ; wipefs -a /dev/sdb1; mount /dev/sdb2 /mnt/test

would lead to a blkdev open/close mismatch when the mount fails, and
a permanently busy (opened O_EXCL) sdb2:

   # wipefs -a /dev/sdb2
   wipefs: error: /dev/sdb2: probing initialization failed: Device or resource busy

It's because btrfs_open_devices() may open some devices, fail on
the last one, and return that failure stored in "ret."   The mount
then fails, but the caller then does not clean up the open devices.

Chris assures me that:

"btrfs_open_devices just means: go off and open every bdev you can from
this uuid.  It should return success if we opened any of them at all."

So change the logic to ignore any open failures; just skip processing
of that device.  Later on it's decided whether we have enough devices
to continue.

Reported-by: Jan Safranek <jsafrane@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V3: just ignore failures from btrfs_get_bdev_and_sb

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5989a92..8edcd33 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -717,9 +717,9 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		if (!device->name)
 			continue;
 
-		ret = btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
-					    &bdev, &bh);
-		if (ret)
+		/* Just open everything we can; ignore failures here */
+		if (btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1,
+					    &bdev, &bh))
 			continue;
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;


