Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeEQHOf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 03:14:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4H7AvMU097111
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 07:14:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2hx29w7usw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 07:14:34 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4H7EXS5024547
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 07:14:34 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4H7EXwL010401
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 07:14:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix BUG trying to resume balance without resume flag
Date: Thu, 17 May 2018 15:16:51 +0800
Message-Id: <20180517071651.29404-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We set the BTRFS_BALANCE_RESUME flag in the btrfs_recover_balance()
only, which isn't called during the remount. So when resuming from
the paused balance we hit the BUG.

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

To fix this set the BTRFS_BALANCE_RESUME flag in btrfs_resume_balance_async().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: . Hold fs_info->balance_lock because in remount context there can
	be more the one thread accessing the balance_ctl.
	. Don't remove the BTRFS_BALANCE_RESUME set at recover_balance
	as in the original code.
	. Add comments.
v1->v2: btrfs_resume_balance_async() can be called only from remount or
        mount, we don't need to hold fs_info->balance_lock.

 fs/btrfs/volumes.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 40e4259bdd51..c68976856d87 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4112,6 +4112,15 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 		return 0;
 	}
 
+	/*
+	 * A remount ro->rw sequence should continue with the
+	 * paused balance irrespective of who pauses it, system or
+	 * the user as of now, so set the resume flag.
+	 */
+	spin_lock(&fs_info->balance_lock);
+	fs_info->balance_ctl->flags |= BTRFS_BALANCE_RESUME;
+	spin_unlock(&fs_info->balance_lock);
+
 	tsk = kthread_run(balance_kthread, fs_info, "btrfs-balance");
 	return PTR_ERR_OR_ZERO(tsk);
 }
-- 
2.7.0

