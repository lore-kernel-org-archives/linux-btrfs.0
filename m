Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33464 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHARPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:54 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFrGG002119
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFrx8013960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFrmp002121
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/14] Btrfs: raid56: detect raid56 log on mount
Date: Tue,  1 Aug 2017 10:14:26 -0600
Message-Id: <20170801161439.13426-4-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've put the flag BTRFS_DEV_RAID56_LOG in device->type, so we can
recognize the journal device of raid56 while reading the chunk tree.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5c50df7..a17a488 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6696,6 +6696,18 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	fill_device_from_item(leaf, dev_item, device);
+
+	if (device->type & BTRFS_DEV_RAID56_LOG) {
+		ret = btrfs_set_r5log(fs_info, device);
+		if (ret) {
+			btrfs_err(fs_info, "error %d on loading r5log", ret);
+			return ret;
+		}
+
+		btrfs_info(fs_info, "devid %llu uuid %pU is raid56 log",
+			   device->devid, device->uuid);
+	}
+
 	device->in_fs_metadata = 1;
 	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
-- 
2.9.4

