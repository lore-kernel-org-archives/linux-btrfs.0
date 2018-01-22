Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46256 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbeAVWti (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 17:49:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MMl5GB001229
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2fnrh3g5y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0MMnbAp029281
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0MMnbmH019675
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
MIME-Version: 1.0
Message-ID: <20180122224937.3458-3-anand.jain@oracle.com>
Date: Mon, 22 Jan 2018 14:49:37 -0800 (PST)
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: fix alloc device order consistency
References: <20180122224937.3458-1-anand.jain@oracle.com>
In-Reply-To: <20180122224937.3458-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add opened device to the tail of dev_alloc_list instead of head, so that
it maintains the same order as dev_list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 98e41d286283..879fb07a952b 100644
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
2.7.0

