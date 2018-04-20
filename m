Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754217AbeDTJac (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:30:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3K9Qew4043027
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 09:30:31 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2hdrxnksew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 09:30:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3K9UUJY009943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 09:30:30 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3K9UUVR013771
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 09:30:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix BUG trying to resume balance without resume flag
Date: Fri, 20 Apr 2018 17:32:31 +0800
Message-Id: <20180420093231.17440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We set the BTRFS_BALANCE_RESUME flag in the btrfs_recover_balance(),
which is not called during the remount. So when resuming from the
paused balance we hit BUG.

 kernel: kernel BUG at fs/btrfs/volumes.c:3890!
 ::
 kernel:  balance_kthread+0x51/0x60 [btrfs]
 kernel:  kthread+0x111/0x130
 ::
 kernel: RIP: btrfs_balance+0x12e1/0x1570 [btrfs] RSP: ffffba7d0090bde8

Reproducer:
  On a mounted BTRFS.

  btrfs balance start --full-balance /btrfs
  btrfs balance pause /btrfs
  mount -o remount,ro /dev/sdb /btrfs
  mount -o remount,rw /dev/sdb /btrfs

To fix this set the BTRFS_BALANCE_RESUME flag in btrfs_resume_balance_async()
instead of btrfs_recover_balance().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 66d2ed96aef1..9c29fdca9075 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3963,6 +3963,10 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 		return 0;
 	}
 
+	spin_lock(&fs_info->balance_lock);
+	fs_info->balance_ctl->flags |= BTRFS_BALANCE_RESUME;
+	spin_unlock(&fs_info->balance_lock);
+
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
 	return PTR_ERR_OR_ZERO(tsk);
 }
@@ -4004,7 +4008,6 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 
 	bctl->fs_info = fs_info;
 	bctl->flags = btrfs_balance_flags(leaf, item);
-	bctl->flags |= BTRFS_BALANCE_RESUME;
 
 	btrfs_balance_data(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
-- 
2.7.0

