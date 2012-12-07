Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LGKJX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Dec 2012 05:09:23 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] btrfs: get the device in write mode when deleting it
Date: Fri,  7 Dec 2012 11:09:19 +0100
Message-Id: <1354874959-1005-1-git-send-email-lczerner@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we're deleting the device we should get it in write mode since
we're going to re-write the super block magic on that device. And it
should fail if the device is read-only.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 95c6f7d..e3b9b36 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1384,7 +1384,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 			goto out;
 		}
 	} else {
-		bdev = blkdev_get_by_path(device_path, FMODE_READ | FMODE_EXCL,
+		bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
 					  root->fs_info->bdev_holder);
 		if (IS_ERR(bdev)) {
 			ret = PTR_ERR(bdev);
-- 
1.7.7.6

