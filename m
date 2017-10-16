Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46887 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756162AbdJPWyG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 18:54:06 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9GMs5Zd021108
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 22:54:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9GMs5cI011685
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 22:54:05 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9GMs51n018264
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 22:54:05 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: remove BUG_ON in btrfs_rm_dev_replace_free_srcdev()
Date: Tue, 17 Oct 2017 06:53:50 +0800
Message-Id: <20171016225350.15463-1-anand.jain@oracle.com>
In-Reply-To: <20171016144547.GR3521@twin.jikos.cz>
References: <20171016144547.GR3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use ASSERT instead of BUG_ON.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
V2: Accepts David suggestion to keep the check as ASSERT.
    Adds more comments to explain the context.

 fs/btrfs/volumes.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 93afc7d49d4d..94a9e69e844b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2015,19 +2015,20 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 	}
 
 	btrfs_close_bdev(srcdev);
-
 	call_rcu(&srcdev->rcu, free_device);
 
-	/*
-	 * unless fs_devices is seed fs, num_devices shouldn't go
-	 * zero
-	 */
-	BUG_ON(!fs_devices->num_devices && !fs_devices->seeding);
-
 	/* if this is no devs we rather delete the fs_devices */
 	if (!fs_devices->num_devices) {
 		struct btrfs_fs_devices *tmp_fs_devices;
 
+		/*
+		 * In a mounted FS, num_devices can't be zero unless
+		 * its a seed. Where in case of seed device being replaced,
+		 * the replace target added to the sprout FS, so there
+		 * will be no more device left under the seed FS.
+		 */
+		ASSERT(fs_devices->seeding);
+
 		tmp_fs_devices = fs_info->fs_devices;
 		while (tmp_fs_devices) {
 			if (tmp_fs_devices->seed == fs_devices) {
-- 
2.13.1

