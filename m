Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbeBMDxE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 22:53:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D3qVCC006264
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:53:03 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2g3q2sr60u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:53:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1D3r2bb002366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:53:02 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1D3r2jE017918
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:53:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: no need to check if tgt_device is null
Date: Tue, 13 Feb 2018 11:54:27 +0800
Message-Id: <20180213035427.18272-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't have to check if tgt_device is null and then delete
it, because there wouldn't be a case where tgt_device will
be null in a mounted context. If the replacement is already
canceled then we won't be here, since there is a switch above
to deviate.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3b0760f7ec8a..a4a05cbb7250 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -748,8 +748,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		   btrfs_dev_name(src_device), src_device->devid,
 		   btrfs_dev_name(tgt_device));
 
-	if (tgt_device)
-		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
+	btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 
 leave:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-- 
2.15.0

