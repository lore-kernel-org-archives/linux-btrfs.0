Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50034 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaHKJkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:40:18 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7B9eHf6020619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:17 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7B9eG3p007925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:16 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s7B9eFvs007813
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: update sprout seed pointer when seed fs is relinquished
Date: Mon, 11 Aug 2014 17:42:56 +0800
Message-Id: <1407750176-15853-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 fs/btrfs/volumes.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f098ae7..bfdc11f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1992,6 +1992,25 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 			btrfs_scratch_superblock(srcdev);
 	}
 
+	/* unless fs_devices is seed fs, num_devices shouldn't go
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
 	call_rcu(&srcdev->rcu, free_device);
 }
 
-- 
2.0.0.153.g79dcccc

