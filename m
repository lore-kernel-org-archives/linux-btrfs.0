Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40251 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3LPH0T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 02:26:19 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBG7QIK1009669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:19 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QHsK008312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:18 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QHRR013195
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:17 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] Btrfs: don't build inode cache for orphan root
Date: Mon, 16 Dec 2013 15:25:34 +0800
Message-Id: <1387178735-30832-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
References: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We check if we have orphan roots when mounting btrfs, but orphan roots
are those who are already dead and about to be freed, so don't start building
inode cache for them, otherwise we'll get an ugly crash.

Acked-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode-map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index f23b0df..b7fb1a8 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -141,7 +141,9 @@ static void start_caching(struct btrfs_root *root)
 	int ret;
 	u64 objectid;
 
-	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
+	/* Don't even start if this is an orphan root. */
+	if (!btrfs_test_opt(root, INODE_MAP_CACHE) ||
+	    btrfs_root_refs(&root->root_item) == 0)
 		return;
 
 	spin_lock(&root->cache_lock);
-- 
1.8.2.1

