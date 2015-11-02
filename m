Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16995 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbbKBVzW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Nov 2015 16:55:22 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA2LtLG9012108
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Nov 2015 21:55:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA2LtK8V020347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Nov 2015 21:55:21 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA2LtKo4008526
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Nov 2015 21:55:20 GMT
From: Ashish Samant <ashish.samant@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: ashish.samant@oracle.com
Subject: [PATCH V2] btrfs: Print Warning only if ENOSPC_DEBUG is enabled
Date: Mon,  2 Nov 2015 13:55:10 -0800
Message-Id: <1446501310-4408-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dont call WARN_ON for ENOSPC error unless ENOSPC_DEBUG is enabled.

Signed-off-by : Ashish Samant <ashish.samant@oracle.com>
---
 fs/btrfs/delayed-inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a2ae427..b86cfd9 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -652,9 +652,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 			goto out;
 
 		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-		if (!WARN_ON(ret))
+		if (!ret)
 			goto out;
 
+		if (btrfs_test_opt(root, ENOSPC_DEBUG))
+			WARN(1, KERN_DEBUG
+			     "btrfs: block rsv migrate returned %d\n", ret);
+
 		/*
 		 * Ok this is a problem, let's just steal from the global rsv
 		 * since this really shouldn't happen that often.
-- 
1.8.3.2

