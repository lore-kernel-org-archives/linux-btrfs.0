Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38794 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751359AbeBTOqo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 09:46:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1KEg9E9146151
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:46:43 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2g8kh18rtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:46:43 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1KEkgak012349
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:46:42 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1KEkga3009794
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:46:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix NPD during canceling replace when the target is missing
Date: Tue, 20 Feb 2018 22:48:09 +0800
Message-Id: <20180220144809.9142-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace target can be missing after a reboot during the replace.
So check if device is null.

BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
IP: btrfs_destroy_dev_replace_tgtdev+0x43/0xf0 [btrfs]
Call Trace:
btrfs_dev_replace_cancel+0x22b/0x250 [btrfs]
btrfs_ioctl+0x2216/0x2590 [btrfs]
? do_vfs_ioctl+0x625/0x650
do_vfs_ioctl+0x625/0x650
? security_file_ioctl+0x30/0x50
SyS_ioctl+0x4e/0x80
do_syscall_64+0x5d/0x160
entry_SYSCALL64_slow_path+0x25/0x25

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 87f975143c05..476981c2cf55 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -749,7 +749,8 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		   btrfs_dev_name(src_device), src_device->devid,
 		   btrfs_dev_name(tgt_device));
 
-	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+	if (tgt_device)
+		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 
 leave:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-- 
2.15.0

