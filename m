Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2L0JEG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:04:06 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR945fh013266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:04:06 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR944HD001737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:04:05 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR9442b026420
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:04:04 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] Btrfs: let allocation start from the right raid type
Date: Thu, 27 Dec 2012 17:01:24 +0800
Message-Id: <1356598884-22952-8-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This'd avoid us empty looping.

Say we have only one disk and the metadata raid type will be defaultly DUP,
and we do not need to start from index=0(RAID10) and get over two empty
loops to index=2(DUP).

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 60d5081..f4e2002 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5563,7 +5563,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	int empty_cluster = 2 * 1024 * 1024;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
-	int index = 0;
+	int index = __get_raid_index(data);
 	int alloc_type = (data & BTRFS_BLOCK_GROUP_DATA) ?
 		RESERVE_ALLOC_NO_ACCOUNT : RESERVE_ALLOC;
 	bool found_uncached_bg = false;
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-in
