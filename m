Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18786 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbaDBJlX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 05:41:23 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s329fLCx017296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 09:41:22 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s329fLu1018016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 09:41:21 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s329fLCl018011
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 09:41:21 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: avoid warning bomb of btrfs_delayed_inode_reserve_metadata
Date: Wed,  2 Apr 2014 17:41:10 +0800
Message-Id: <1396431670-9353-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we nearly run out of global_block_rsv's reserved space, this WARNING will
be hit for thousands of times, which is not good because the kernel log has
nothing else.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 451b00c..32862f0 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 			goto out;
 
 		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-		if (!WARN_ON(ret))
+		if (!WARN_ON_ONCE(ret))
 			goto out;
 
 		/*
-- 
1.8.2.1

