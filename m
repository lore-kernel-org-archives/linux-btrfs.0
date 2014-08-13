Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26136 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaHMGRS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 02:17:18 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D6HHxY007429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:17 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HGWf016607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HGWe016593
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] btrfs: rw_devices shouldn't be incremented for seed fs in btrfs_rm_dev_replace_srcdev()
Date: Wed, 13 Aug 2014 14:24:24 +0800
Message-Id: <1407911066-5363-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>

seed fs devices don't participate as rw_device, so don't increment
rw_devices when the device being handled belongs to a seed fs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 314bbbf..bf99e82 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1977,7 +1977,8 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 	fs_devices->num_devices--;
 	if (srcdev->missing) {
 		fs_devices->missing_devices--;
-		fs_devices->rw_devices++;
+		if (!fs_devices->seeding)
+			fs_devices->rw_devices++;
 	}
 	if (srcdev->can_discard)
 		fs_devices->num_can_discard--;
-- 
2.0.0.153.g79dcccc

