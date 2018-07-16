Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbeGPPWq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:22:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GErkT9066371
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2k7a33vsh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEsu8Y017340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:56 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6GEsuSS025569
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:56 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/7] btrfs: fix race between free_stale_devices and close_fs_devices
Date: Mon, 16 Jul 2018 22:58:07 +0800
Message-Id: <20180716145812.20836-3-anand.jain@oracle.com>
In-Reply-To: <20180716145812.20836-1-anand.jain@oracle.com>
References: <20180716145812.20836-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

%fs_devices can be free-ed by btrfs_free_stale_devices() when the
close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
tries to access the %fs_devices again without the device_list_mutex.

Fix this by bringing the %fs_devices access with in the device_list_mutex.

Stack trace as below.

WARNING: CPU: 1 PID: 4499 at fs/btrfs/volumes.c:1071 close_fs_devices+0xbc7/0xfa0 fs/btrfs/volumes.c:1071
Kernel panic - not syncing: panic_on_warn set ...
::
RIP: 0010:close_fs_devices+0xbc7/0xfa0 fs/btrfs/volumes.c:1071
::
 btrfs_close_devices+0x29/0x150 fs/btrfs/volumes.c:1085
 open_ctree+0x589/0x7898 fs/btrfs/disk-io.c:3358
 btrfs_fill_super fs/btrfs/super.c:1202 [inline]
 btrfs_mount_root+0x16df/0x1e70 fs/btrfs/super.c:1593
 mount_fs+0xae/0x328 fs/super.c:1277
 vfs_kern_mount.part.34+0xd4/0x4d0 fs/namespace.c:1037
 vfs_kern_mount+0x40/0x60 fs/namespace.c:1027
 btrfs_mount+0x4a1/0x213e fs/btrfs/super.c:1661
 mount_fs+0xae/0x328 fs/super.c:1277

Reported-by: syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Commit log update. Satisfy checkpatch.pl. Remove HEAD..

 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 870c9f69a6a4..8450bcfed4cb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1062,13 +1062,13 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
 		btrfs_close_one_device(device);
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
-
 	WARN_ON(fs_devices->open_devices);
 	WARN_ON(fs_devices->rw_devices);
 	fs_devices->opened = 0;
 	fs_devices->seeding = 0;
 
+	mutex_unlock(&fs_devices->device_list_mutex);
+
 	return 0;
 }
 
-- 
2.7.0

