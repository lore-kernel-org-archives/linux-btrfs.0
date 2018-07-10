Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732518AbeGJSTf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 14:19:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6AIJEoS100066
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:26 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2k2p7du4xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:26 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIJQUj000766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:26 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6AIJQqm031710
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 18:19:26 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: warn for num_devices below 0
Date: Wed, 11 Jul 2018 02:22:39 +0800
Message-Id: <20180710182241.23754-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to de-duplicate a section of code where we deduce the
num_devices, use warn instead of bug.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index eb78bb8d1108..ce6faeb8bcf8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3813,7 +3813,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	num_devices = fs_info->fs_devices->num_devices;
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
-		BUG_ON(num_devices < 1);
+		WARN_ON(num_devices < 1);
 		num_devices--;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
-- 
2.7.0

