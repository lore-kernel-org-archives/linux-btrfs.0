Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26132 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaHMGRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 02:17:17 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D6HFi8007412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:16 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HF8Y018325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:15 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HFFw018314
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:15 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] btrfs: fix memory leak when there is no more seed device
Date: Wed, 13 Aug 2014 14:24:23 +0800
Message-Id: <1407911066-5363-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>

When we replace all the seed device in the system there is
no point in just keeping the btrfs_fs_devices with out
any device

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6716658..314bbbf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2013,6 +2013,8 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 			tmp_fs_devices = tmp_fs_devices->seed;
 		}
 		fs_devices->seed = NULL;
+		__btrfs_close_devices(fs_devices);
+		free_fs_devices(fs_devices);
 	}
 }
 
-- 
2.0.0.153.g79dcccc

