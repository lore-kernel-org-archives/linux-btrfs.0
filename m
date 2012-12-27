Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49584 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2L0JDe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:03:34 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR93X0a008303
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:34 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR93XN3000994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:33 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR93WJd007024
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:03:32 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] Btrfs: remove deprecated comments
Date: Thu, 27 Dec 2012 17:01:17 +0800
Message-Id: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit d53ba47484ed6245e640ee4bfe9d21e9bfc15765
(Btrfs: use commit root when loading free space cache) has remove
the deadlock check, and the related comments can be removed as well.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 521e9d4..8540f94 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -527,12 +527,6 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	cache->cached = BTRFS_CACHE_FAST;
 	spin_unlock(&cache->lock);
 
-	/*
-	 * We can't do the read from on-disk cache during a commit since we need
-	 * to have the normal tree locking.  Also if we are currently trying to
-	 * allocate blocks for the tree root we can't do the fast caching since
-	 * we likely hold important locks.
-	 */
 	if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
 		ret = load_free_space_cache(fs_info, cache);
 
-- 
1.7.7.6

