Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:58386 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KENKw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Nov 2012 08:10:52 -0500
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp2) (RZmta 30.22 OK)
	with ESMTP id g002a3oA5D6ZaZ for <linux-btrfs@vger.kernel.org>;
	Mon, 5 Nov 2012 14:10:49 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Don't trust the superblock label and simply printk("%s") it
Date: Mon,  5 Nov 2012 14:10:49 +0100
Message-Id: <1352121049-4140-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Someone who is root or capable(CAP_SYS_ADMIN) could corrupt the
superblock and make Btrfs printk("%s") crash while holding the
uuid_mutex since nobody forces a limit on the string. Since the
uuid_mutex is significant, the system would be unusable
afterwards.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index eeed97d..a429cc6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -764,10 +764,13 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
 	total_devices = btrfs_super_num_devices(disk_super);
-	if (disk_super->label[0])
+	if (disk_super->label[0]) {
+		if (disk_super->label[BTRFS_LABEL_SIZE - 1])
+			disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
 		printk(KERN_INFO "device label %s ", disk_super->label);
-	else
+	} else {
 		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
+	}
 	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
-- 
1.8.0

