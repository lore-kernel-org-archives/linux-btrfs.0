Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753591AbdLDIUn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 03:20:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB44geBH158027
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:42:41 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ekpeu9yk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 04:42:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB44gexn021523
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:42:40 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB44ge6W020918
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:42:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix inconsistency during missing device rejoin
Date: Mon,  4 Dec 2017 12:43:06 +0800
Message-Id: <20171204044306.8083-1-anand.jain@oracle.com>
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
index aa0c1d9ce1f5..2f76a125d181 100644
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

