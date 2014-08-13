Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaHMGRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 02:17:16 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D6HFVS025201
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:15 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HEgo018282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:15 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s7D6HDlU006150
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8 v2] btrfs: update sprout seed pointer when seed fs is relinquished
Date: Wed, 13 Aug 2014 14:24:22 +0800
Message-Id: <1407911066-5363-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>

We are not updating sprout fs seed pointer when all seed device
is replaced. This patch will check if all seed device has been
replaced and then update the sprout pointer accordingly.

Same reproducer as in the previous patch would apply here.
And notice that btrfs_close_device will check if seed fs is
present and spits out the error with out this patch.

int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
{
::
                seed_devices = fs_devices->seed;
::
        while (seed_devices) {
                fs_devices = seed_devices;
                seed_devices = fs_devices->seed;
                __btrfs_close_devices(fs_devices);
                free_fs_devices(fs_devices);
        }

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: fixes per Miao review. also keep the list pointer update to the last

 fs/btrfs/volumes.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f098ae7..6716658 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1993,6 +1993,27 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 	}
 
 	call_rcu(&srcdev->rcu, free_device);
+
+	/*
+	 * unless fs_devices is seed fs, num_devices shouldn't go
+	 * zero
+	 */
+	BUG_ON(!fs_devices->num_devices && !fs_devices->seeding);
+
+	/* if this is no devs we rather delete the fs_devices */
+	if (!fs_devices->num_devices) {
+		struct btrfs_fs_devices *tmp_fs_devices;
+
+		tmp_fs_devices = fs_info->fs_devices;
+		while (tmp_fs_devices) {
+			if (tmp_fs_devices->seed == fs_devices) {
+				tmp_fs_devices->seed = fs_devices->seed;
+				break;
+			}
+			tmp_fs_devices = tmp_fs_devices->seed;
+		}
+		fs_devices->seed = NULL;
+	}
 }
 
 void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-- 
2.0.0.153.g79dcccc

