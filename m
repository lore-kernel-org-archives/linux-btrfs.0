Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:42694 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2HBOU4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 10:20:56 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id 3SdOzKV9oXTHODCX (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 02 Aug 2012 08:20:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not use missing devices when showing devname
Date: Thu, 2 Aug 2012 10:25:58 -0400
Message-ID: <1343917558-1883-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you do the following

mkfs.btrfs /dev/sdb /dev/sdc
rmmod btrfs
dd if=/dev/zero of=/dev/sdb bs=1M count=1
mount -o degraded /dev/sdc /mnt/btrfs-test

the box will panic trying to deref the name for the missing dev since it is
the lower numbered devid.  So fix show_devname to not use missing devices.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fa61ef5..ffcfe49 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1505,6 +1505,8 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 	while (cur_devices) {
 		head = &cur_devices->devices;
 		list_for_each_entry(dev, head, dev_list) {
+			if (dev->missing)
+				continue;
 			if (!first_dev || dev->devid < first_dev->devid)
 				first_dev = dev;
 		}
-- 
1.7.7.6

