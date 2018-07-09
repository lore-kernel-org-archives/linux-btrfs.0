Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbeGIIan (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 04:30:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w698SlRx017244
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Jul 2018 08:30:42 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2k2p75u30b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2018 08:30:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w698UfrN017333
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Jul 2018 08:30:41 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w698Ue88006258
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Jul 2018 08:30:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: code reorder in btrfs_prepare_sprout
Date: Mon,  9 Jul 2018 16:33:52 +0800
Message-Id: <20180709083353.14517-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional change, bring the clone of fs_devices and its
operations closer, so that it indicates its purpose.

Also add a comment to indicate why we clone the fs_devices.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b63aae267ebe..0e92969b1adc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2276,18 +2276,21 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	if (!fs_devices->seeding)
 		return -EINVAL;
 
-	seed_devices = alloc_fs_devices(NULL);
-	if (IS_ERR(seed_devices))
-		return PTR_ERR(seed_devices);
-
+	/*
+	 * This step ensures the scanned seed device remains scanned,
+	 * its not a must for the sprout operation though.
+	 */
 	old_devices = clone_fs_devices(fs_devices);
 	if (IS_ERR(old_devices)) {
 		kfree(seed_devices);
 		return PTR_ERR(old_devices);
 	}
-
 	list_add(&old_devices->fs_list, &fs_uuids);
 
+	seed_devices = alloc_fs_devices(NULL);
+	if (IS_ERR(seed_devices))
+		return PTR_ERR(seed_devices);
+
 	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
 	seed_devices->opened = 1;
 	INIT_LIST_HEAD(&seed_devices->devices);
-- 
2.7.0

