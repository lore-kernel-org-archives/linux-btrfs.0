Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54583 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932785AbaEMJIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 05:08:24 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4D98Mir025713
	for <linux-btrfs@vger.kernel.org>; Tue, 13 May 2014 17:08:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: set right total device count for seeding support
Date: Tue, 13 May 2014 17:05:06 +0800
Message-ID: <1399971906-1237-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Seeding device support allows us to create a new filesystem
based on existed filesystem.

However newly created filesystem's @total_devices should include seed
devices. This patch fix the following problem:

 # mkfs.btrfs -f /dev/sdb
 # btrfstune -S 1 /dev/sdb
 # mount /dev/sdb /mnt
 # btrfs device add -f /dev/sdc /mnt --->fs_devices->total_devices = 1
 # umount /mnt
 # mount /dev/sdc /mnt               --->fs_devices->total_devices = 2

This is because we record right @total_devices in superblock, but
@fs_devices->total_devices is reset to be 0 in btrfs_prepare_sprout().

Fix this problem by not resetting @fs_devices->total_devices.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fd7fe6..19b2d32 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1883,7 +1883,6 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
-	fs_devices->total_devices = 0;
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
-- 
1.8.2.1

