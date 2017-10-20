Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45912 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752816AbdJTKdf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 06:33:35 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9KAXZqn021275
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:33:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9KAXY5O002585
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:33:35 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9KAXY6a005313
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:33:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: maintain consistent fmode flags for device open
Date: Fri, 20 Oct 2017 18:33:25 +0800
Message-Id: <20171020103325.9595-2-anand.jain@oracle.com>
In-Reply-To: <20171020103325.9595-1-anand.jain@oracle.com>
References: <20171020103325.9595-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Devices opened through replace/add would have FMODE_WRITE | FMODE_EXCL,
as compared with devices opened through the mount which will have
FMODE_READ | FMODE_WRITE | FMODE_EXCL. So maintain consistency.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 765c2bd2d8d9..7008b5d104d4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2323,7 +2323,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	u64 tmp;
 	int seeding_dev = 0;
 	int ret = 0;
-	fmode_t flag = FMODE_WRITE | FMODE_EXCL;
+	fmode_t flag = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
 
 	if (sb_rdonly(sb) && !fs_info->fs_devices->seeding)
 		return -EROFS;
@@ -2526,7 +2526,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	struct rcu_string *name;
 	u64 devid = BTRFS_DEV_REPLACE_DEVID;
 	int ret = 0;
-	fmode_t flags = FMODE_WRITE | FMODE_EXCL;
+	fmode_t flags = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
 
 	*device_out = NULL;
 	if (fs_info->fs_devices->seeding) {
-- 
2.13.1

