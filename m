Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33340 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3I2Cay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 22:30:54 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r8T2UqKj022687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:30:53 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8T2UpOo025517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:30:52 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8T2UpND011276
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:30:51 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix memory leak of chunks' extent map
Date: Sun, 29 Sep 2013 10:30:43 +0800
Message-Id: <1380421843-4563-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0431147..ee1fdac 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4483,6 +4483,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got "
 			    "%Lu-%Lu\n", logical, logical+len, em->start,
 			    em->start + em->len);
+		free_extent_map(em);
 		return 1;
 	}
 
@@ -4663,6 +4664,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		btrfs_crit(fs_info, "found a bad mapping, wanted %Lu, "
 			   "found %Lu-%Lu\n", logical, em->start,
 			   em->start + em->len);
+		free_extent_map(em);
 		return -EINVAL;
 	}
 
-- 
1.8.1.4

