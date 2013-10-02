Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44304 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3JBRla (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 13:41:30 -0400
Received: by mail-lb0-f178.google.com with SMTP id z5so1048360lbh.37
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 10:41:29 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH] Btrfs: fix a use-after-free bug in btrfs_dev_replace_finishing
Date: Wed,  2 Oct 2013 20:41:01 +0300
Message-Id: <1380735661-12488-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

free_device rcu callback, scheduled from btrfs_rm_dev_replace_srcdev,
can be processed before btrfs_scratch_superblock is called, which would
result in a use-after-free on btrfs_device contents.  Fix this by
zeroing the superblock before the rcu callback is registered.

Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/dev-replace.c |    5 +----
 fs/btrfs/volumes.c     |    7 ++++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a644353..5aa0718 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -535,10 +535,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
-	if (src_device->bdev) {
-		/* zero out the old super */
-		btrfs_scratch_superblock(src_device);
-	}
+
 	/*
 	 * this is again a consistent state where no dev_replace procedure
 	 * is running, the target device is part of the filesystem, the
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0052ca8..a9ac68a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1715,6 +1715,7 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 				 struct btrfs_device *srcdev)
 {
 	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
+
 	list_del_rcu(&srcdev->dev_list);
 	list_del_rcu(&srcdev->dev_alloc_list);
 	fs_info->fs_devices->num_devices--;
@@ -1724,9 +1725,13 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 	}
 	if (srcdev->can_discard)
 		fs_info->fs_devices->num_can_discard--;
-	if (srcdev->bdev)
+	if (srcdev->bdev) {
 		fs_info->fs_devices->open_devices--;
 
+		/* zero out the old super */
+		btrfs_scratch_superblock(srcdev);
+	}
+
 	call_rcu(&srcdev->rcu, free_device);
 }
 
-- 
1.7.10.4

