Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32854 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbdLDHTQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 02:19:16 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vB47JEO6005528
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 07:19:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB47JEr1023953
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 07:19:14 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB47JEe7005068
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 07:19:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix inconsistency during missing device rejoin
Date: Mon,  4 Dec 2017 15:19:39 +0800
Message-Id: <20171204071939.22878-1-anand.jain@oracle.com>
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
index 59a8785a2e9e..ac0c4eb5107f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -715,7 +715,8 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-	} else if (!device->name || strcmp(device->name->str, path)) {
+	} else if (!device->name || strcmp(device->name->str, path) ||
+			test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
 		/*
 		 * When FS is already mounted.
 		 * 1. If you are here and if the device->name is NULL that
-- 
2.15.0

