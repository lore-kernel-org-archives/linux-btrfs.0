Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2560 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758463AbaGXDfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZUf5017384
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/10] Btrfs: Fix the problem that the replace destroys the seed filesystem
Date: Thu, 24 Jul 2014 11:37:06 +0800
Message-ID: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The seed filesystem was destroyed by the device replace, the reproduce
method is:
 # mkfs.btrfs -f <dev0>
 # btrfstune -S 1 <dev0>
 # mount <dev0> <mnt>
 # btrfs device add <dev1> <mnt>
 # umount <mnt>
 # mount <dev1> <mnt>
 # btrfs replace start -f <dev0> <dev2> <mnt>
 # umount <mnt>
 # mount <dev0> <mnt>

It is because we erase the super block on the seed device. It is wrong,
we should not change anything on the seed device.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2776070f..19188df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1853,8 +1853,12 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 	if (srcdev->bdev) {
 		fs_info->fs_devices->open_devices--;
 
-		/* zero out the old super */
-		btrfs_scratch_superblock(srcdev);
+		/*
+		 * zero out the old super if it is not writable
+		 * (e.g. seed device)
+		 */
+		if (srcdev->writeable)
+			btrfs_scratch_superblock(srcdev);
 	}
 
 	call_rcu(&srcdev->rcu, free_device);
-- 
1.9.3

