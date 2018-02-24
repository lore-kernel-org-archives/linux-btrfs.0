Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbeBXLmd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 06:42:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1OBgX2K171038
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 11:42:33 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2gb710g1js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 11:42:33 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1OBgVO9032726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 11:42:31 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1OBgVVt002454
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 11:42:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix null pointer deref when target device is missing
Date: Sat, 24 Feb 2018 19:43:56 +0800
Message-Id: <20180224114356.18029-1-anand.jain@oracle.com>
In-Reply-To: <20180223225545.GP1469@twin.jikos.cz>
References: <20180223225545.GP1469@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The replace target device can be missing when mounted with -o degraded,
but we wont allocate a missing btrfs_device to it. So check the device
before access.

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
v1->v2: Fix change log. Fix $subject.
  Old $subject
    btrfs: fix NPD when target device is missing

 fs/btrfs/dev-replace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index c97969b2abbd..e279f04b3388 100644
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

