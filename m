Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45765 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3I2Cdh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 22:33:37 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r8T2Xami020543
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:33:37 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8T2XZJw012568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:33:36 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8T2XZ9R009976
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 02:33:35 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix memory leak of chunks' extent map
Date: Sun, 29 Sep 2013 10:33:16 +0800
Message-Id: <1380421996-4684-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we're hold a ref on looking up the extent map, we need to drop the ref
before returning to callers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: add the missing changelog.

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

