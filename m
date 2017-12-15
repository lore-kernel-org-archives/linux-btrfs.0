Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44282 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753448AbdLOIH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:07:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF87I4k117662
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 08:07:57 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2evajs00a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 08:07:56 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBF87txC018988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 08:07:55 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBF87tEP013937
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 08:07:55 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND] btrfs: fix inconsistency during missing device rejoin
Date: Fri, 15 Dec 2017 16:08:28 +0800
Message-Id: <20171215080828.29321-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When device is missing its not necessary that btrfs_device::name is null
or the path is different when it reappears. Its possible that device can
go missing after its been scanned where neither of
btrfs_device::name == NULL OR btrfs_device::name != reappear_dev_path,
is true. So just check for btrfs_device::dev_state.missing. Thanks.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ba06a4ccd5a6..93d65c72b731 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -767,7 +767,8 @@ static noinline int device_list_add(const char *path,
 		ret = 1;
 		device->fs_devices = fs_devices;
 		btrfs_free_stale_device(path, device);
-	} else if (!device->name || strcmp(device->name->str, path)) {
+	} else if (!device->name || strcmp(device->name->str, path) ||
+			test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
 		/*
 		 * When FS is already mounted.
 		 * 1. If you are here and if the device->name is NULL that
-- 
2.7.0

