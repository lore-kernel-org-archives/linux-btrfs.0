Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbeAaFMt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 00:12:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0V5CnAx099469
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 05:12:49 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fu5bwr81m-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 05:12:48 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0V2SOVQ015411
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:24 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0V2SOv2030341
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: fix alloc device order consistency
Date: Wed, 31 Jan 2018 10:28:56 +0800
Message-Id: <20180131022856.16791-3-anand.jain@oracle.com>
In-Reply-To: <20180131022856.16791-1-anand.jain@oracle.com>
References: <20180131022856.16791-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add opened device to the tail of dev_alloc_list instead of head, so that
it maintains the same order as dev_list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0109f370ad5b..9c3b4ff7f505 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -708,7 +708,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 		fs_devices->rw_devices++;
-		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
+		list_add_tail(&device->dev_alloc_list, &fs_devices->alloc_list);
 	}
 	brelse(bh);
 
-- 
2.7.0

