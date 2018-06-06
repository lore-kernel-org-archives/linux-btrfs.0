Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59564 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752714AbeFFP6c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 11:58:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w56FuQaE130689
        for <linux-btrfs@vger.kernel.org>; Wed, 6 Jun 2018 15:58:31 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jbvyp5b31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jun 2018 15:58:31 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w56FwUCB031018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 6 Jun 2018 15:58:31 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w56FwU8X017916
        for <linux-btrfs@vger.kernel.org>; Wed, 6 Jun 2018 15:58:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix race between free_stale_devices and close_fs_devices
Date: Thu,  7 Jun 2018 00:01:09 +0800
Message-Id: <20180606160109.10177-1-anand.jain@oracle.com>
In-Reply-To: <000000000000b9e25a056de4dd10@google.com>
References: <000000000000b9e25a056de4dd10@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%fs_devices can be free-ed by btrfs_free_stale_devices() when the
close_fs_devices() drops fs_devices::opened to zero, but close_fs_devices
tries to access the %fs_devices again without the device_list_mutex.

Fix this by bringing the %fs_devices access with in the device_list_mutex.

Stack trace as below.

HEAD commit:    716a685fdb89 Merge branch 'x86-hyperv-for-linus' of git://..
::
CPU: 1 PID: 4499 Comm: syz-executor921 Not tainted 4.17.0+ #84
::
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
 fs/btrfs/volumes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c2b7d66192e8..32fba4e24027 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1153,6 +1153,12 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 		btrfs_prepare_close_one_device(device);
 		list_add(&device->dev_list, &pending_put);
 	}
+
+	WARN_ON(fs_devices->open_devices);
+	WARN_ON(fs_devices->rw_devices);
+	fs_devices->opened = 0;
+	clear_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);
+
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	/*
@@ -1169,11 +1175,6 @@ static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 		call_rcu(&device->rcu, free_device_rcu);
 	}
 
-	WARN_ON(fs_devices->open_devices);
-	WARN_ON(fs_devices->rw_devices);
-	fs_devices->opened = 0;
-	clear_bit(BTRFS_VOLUME_STATE_SEEDING, &fs_devices->volume_state);
-
 	return 0;
 }
 
-- 
2.15.0

