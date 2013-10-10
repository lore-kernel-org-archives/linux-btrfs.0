Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38041 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3JJRiA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 13:38:00 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so1329436eek.10
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 10:37:59 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH] Btrfs: nuke a bogus rw_devices decrement in __btrfs_close_devices
Date: Thu, 10 Oct 2013 20:37:29 +0300
Message-Id: <1381426649-31789-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mount failures, __btrfs_close_devices can be called well before
dev-replace state is read and ->is_tgtdev_for_dev_replace is set.  This
leads to a bogus decrement of ->rw_devices and sets off a WARN_ON in
__btrfs_close_devices if replace target device happens to be on the
lists and we fail early in the mount sequence.  Fix this by checking
the devid instead of ->is_tgtdev_for_dev_replace before the decrement:
for replace targets devid is always equal to BTRFS_DEV_REPLACE_DEVID.

Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 043b215..a306db9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -666,7 +666,8 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		if (device->bdev)
 			fs_devices->open_devices--;
 
-		if (device->writeable && !device->is_tgtdev_for_dev_replace) {
+		if (device->writeable &&
+		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 			list_del_init(&device->dev_alloc_list);
 			fs_devices->rw_devices--;
 		}
-- 
1.7.10.4

