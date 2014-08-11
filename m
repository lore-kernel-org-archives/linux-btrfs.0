Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51677 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaHKJkR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:40:17 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7B9eG72010154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:17 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7B9eFFI007812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:16 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7B9eDZ1017103
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: fix rw_devices miss match after seed replace
Date: Mon, 11 Aug 2014 17:42:55 +0800
Message-Id: <1407750176-15853-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reproducer:
    reproducer:
    mount /dev/sdb /btrfs
    btrfs dev add /dev/sdc /btrfs
    btrfs rep start -B /dev/sdb /dev/sdd /btrfs
    umount /btrfs

WARNING: CPU: 0 PID: 3882 at fs/btrfs/volumes.c:892 __btrfs_close_devices+0x1c8/0x200 [btrfs]()

which is

        WARN_ON(fs_devices->rw_devices);

   The problem here is that we did not add one to the rw_devices when
   we replace the seed device with a writable device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1..fb0a7fa 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -562,6 +562,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
 		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
+	if (src_device->fs_devices->seeding)
+		fs_info->fs_devices->rw_devices++;
 
 	/* replace the sysfs entry */
 	btrfs_kobj_rm_device(fs_info, src_device);
-- 
2.0.0.153.g79dcccc

