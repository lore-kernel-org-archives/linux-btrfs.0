Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeD3Jqj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 05:46:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3U9jsfw038017
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:46:38 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hmgdjbcrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:46:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3U9kbs4001809
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:46:37 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3U9kacK032353
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Apr 2018 09:46:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix BUG trying to resume balance without resume flag
Date: Mon, 30 Apr 2018 17:48:45 +0800
Message-Id: <20180430094845.26229-1-anand.jain@oracle.com>
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
v1->v2: btrfs_resume_balance_async() can be called only from remount or
mount, we don't need to hold fs_info->balance_lock.

Strictly speaking we should rather keep the balance at the paused state
unless it is resumed by the user again, that means neither mount nor
remount-rw should resume the balance automatically, former case needs
writing balance status to the disk. Which needs compatibility
verification.  So for now just avoid BUG. 

 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3e6983a169c4..64bcaf25908b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4115,6 +4115,8 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 		return 0;
 	}
 
+	fs_info->balance_ctl->b_flags |= BTRFS_BALANCE_RESUME;
+
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
 	return PTR_ERR_OR_ZERO(tsk);
 }
@@ -4156,7 +4158,6 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 
 	bctl->fs_info = fs_info;
 	bctl->flags = btrfs_balance_flags(leaf, item);
-	bctl->flags |= BTRFS_BALANCE_RESUME;
 
 	btrfs_balance_data(leaf, item, &disk_bargs);
 	btrfs_disk_balance_args_to_cpu(&bctl->data, &disk_bargs);
-- 
2.7.0

