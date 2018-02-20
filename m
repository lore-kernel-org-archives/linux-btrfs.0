Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36004 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbeBTOpK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 09:45:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1KEg70Y121903
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:45:09 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2g8ket0sqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:45:09 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1KEj9Db006066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:45:09 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1KEj7Au022585
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Feb 2018 14:45:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: fix NPD when target device is missing
Date: Tue, 20 Feb 2018 22:46:25 +0800
Message-Id: <20180220144625.8909-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The replace target device can be missing in which case we don't
allocate a missing btrfs_device when mounted with the -o degraded.
So check the device before access.

BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
IP: btrfs_destroy_dev_replace_tgtdev+0x43/0xf0 [btrfs]
Call Trace:
btrfs_dev_replace_cancel+0x15f/0x180 [btrfs]
btrfs_ioctl+0x2216/0x2590 [btrfs]
do_vfs_ioctl+0x625/0x650
SyS_ioctl+0x4e/0x80
do_syscall_64+0x5d/0x160
entry_SYSCALL64_slow_path+0x25/0x25

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dbaa6880a15e..87f975143c05 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -312,7 +312,7 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
 
 static char* btrfs_dev_name(struct btrfs_device *device)
 {
-	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
+	if (!device || test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		return "<missing disk>";
 	else
 		return rcu_str_deref(device->name);
-- 
2.15.0

