Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab3FTMFp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:05:45 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5KC5im0017163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:45 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5hiG024179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:44 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5hIM013983
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:43 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs-progs: delete fs_devices itself from fs_uuid list before freeing
Date: Thu, 20 Jun 2013 20:05:29 +0800
Message-Id: <1371729930-22497-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Otherwise we will access illegal addresses while searching on fs_uuid list.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 disk-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 21b410d..2892300 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1277,6 +1277,7 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 		kfree(device->label);
 		kfree(device);
 	}
+	list_del(&fs_info->fs_devices->list);
 	kfree(fs_info->fs_devices);
 	return 0;
 }
-- 
1.7.7

