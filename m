Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39782 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab3IAP5H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 11:57:07 -0400
Received: by mail-ee0-f43.google.com with SMTP id e52so1842822eek.2
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 08:57:05 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH] Btrfs: do not add replace target to the alloc_list
Date: Sun,  1 Sep 2013 18:56:44 +0300
Message-Id: <1378051004-8369-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If replace was suspended by the umount, replace target device is added
to the fs_devices->alloc_list during a later mount.  This is obviously
wrong.  ->is_tgtdev_for_dev_replace is supposed to guard against that,
but ->is_tgtdev_for_dev_replace is (and can only ever be) initialized
*after* everything is opened and fs_devices lists are populated.  Fix
this by checking the devid instead: for replace targets it's always
equal to BTRFS_DEV_REPLACE_DEVID.

Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
At first I thought this was caused by my btrfs_device rollback patch,
but no, it just made it easier to spot -- previously one had to reboot
or rmmod/insmod before mounting a suspended replace.

 fs/btrfs/volumes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c9a0977..5b99f19 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -793,7 +793,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			fs_devices->rotating = 1;
 
 		fs_devices->open_devices++;
-		if (device->writeable && !device->is_tgtdev_for_dev_replace) {
+		if (device->writeable &&
+		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 			fs_devices->rw_devices++;
 			list_add(&device->dev_alloc_list,
 				 &fs_devices->alloc_list);
-- 
1.7.10.4

