Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26799 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752604AbdIAXQT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 19:16:19 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v81NGFHT028350
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGFG9007983
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v81NGFBq028148
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: move finish_wait out of the loop
Date: Fri,  1 Sep 2017 16:14:28 -0600
Message-Id: <20170901221430.10131-3-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're still going to wait after schedule(), we don't have to do
finish_wait() to remove our %wait_queue_entry since prepare_to_wait()
won't add the same %wait_queue_entry twice.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78c..19e4dec 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -651,8 +651,8 @@ static void btrfs_wait_for_no_snapshoting_writes(struct btrfs_root *root)
 		if (writers)
 			schedule();
 
-		finish_wait(&root->subv_writers->wait, &wait);
 	} while (writers);
+	finish_wait(&root->subv_writers->wait, &wait);
 }
 
 static int create_snapshot(struct btrfs_root *root, struct inode *dir,
-- 
2.9.4

