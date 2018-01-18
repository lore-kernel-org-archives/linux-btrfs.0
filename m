Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39638 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbeARCeO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 21:34:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I2WMgj075177
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:34:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fjjung0gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:34:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0I2VB8u015203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:12 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0I2VBSw004449
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix alloc device order consistency
Date: Thu, 18 Jan 2018 10:32:12 +0800
Message-Id: <20180118023212.14256-3-anand.jain@oracle.com>
In-Reply-To: <20180118023212.14256-1-anand.jain@oracle.com>
References: <20180118023212.14256-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add opened device to the tail of dev_alloc_list so that it maintains
the same order as dev_list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 68be58a5b03f..543c166049e7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -713,7 +713,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	if (test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) &&
 	    device->devid != BTRFS_DEV_REPLACE_DEVID) {
 		fs_devices->rw_devices++;
-		list_add(&device->dev_alloc_list, &fs_devices->alloc_list);
+		list_add_tail(&device->dev_alloc_list, &fs_devices->alloc_list);
 	}
 	brelse(bh);
 
-- 
2.15.0

