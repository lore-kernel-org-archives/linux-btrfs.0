Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbeGZIFc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 04:05:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6Q6mcLw128689
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:09 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2kbwfq1m9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:09 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6Q6o9ug015037
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:09 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6Q6o8AU017505
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: fix race between free_stale_devices and close_fs_devices
Date: Thu, 26 Jul 2018 14:53:32 +0800
Message-Id: <20180726065334.30594-3-anand.jain@oracle.com>
In-Reply-To: <20180726065334.30594-1-anand.jain@oracle.com>
References: <20180726065334.30594-1-anand.jain@oracle.com>
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
index 2166c5e7cc01..c62b5e46792e 100644
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

