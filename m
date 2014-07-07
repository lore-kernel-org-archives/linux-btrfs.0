Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGGRes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jul 2014 13:34:48 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s67HYm0d012755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 13:34:48 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s67HYld5010458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 13:34:48 -0400
Message-ID: <53BADA39.3020504@redhat.com>
Date: Mon, 07 Jul 2014 12:34:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: test for valid bdev before kobj removal in btrfs_rm_device
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 99994cd btrfs: dev delete should remove sysfs entry
added a btrfs_kobj_rm_device, which dereferences device->bdev...
right after we check whether device->bdev might be NULL.

I don't honestly know if it's possible to have a NULL device->bdev
here, but assuming that it is (given the test), we need to move
the kobject removal to be under that test.

(Coverity spotted this)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

If it's not possible for bdev to be null, then the test should just
be removed, but that's above my current btrfs pay grade. ;)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6104676..6cb82f6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1680,11 +1680,11 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
 
-	if (device->bdev)
+	if (device->bdev) {
 		device->fs_devices->open_devices--;
-
-	/* remove sysfs entry */
-	btrfs_kobj_rm_device(root->fs_info, device);
+		/* remove sysfs entry */
+		btrfs_kobj_rm_device(root->fs_info, device);
+	}
 
 	call_rcu(&device->rcu, free_device);
 

