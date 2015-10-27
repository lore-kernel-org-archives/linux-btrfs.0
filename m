Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbJ0Cie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 22:38:34 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9R2cX30015027
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 02:38:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t9R2cXIB024688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 02:38:33 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t9R2cXcc013363
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 02:38:33 GMT
From: Ashish Samant <ashish.samant@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: ashish.samant@oracle.com
Subject: [PATCH] btrfs: Print Warning only if ENOSPC_DEBUG is enabled
Date: Mon, 26 Oct 2015 19:38:42 -0700
Message-Id: <1445913522-17494-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

