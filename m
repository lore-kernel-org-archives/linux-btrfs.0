Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23622 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab2INJAC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 05:00:02 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8E900gv007155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 09:00:01 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8E900pq028616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 09:00:00 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8E900BG024781
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 04:00:00 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs: cleanup for duplicated code in find_free_extent
Date: Fri, 14 Sep 2012 16:58:05 +0800
Message-Id: <1347613087-3489-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is already an 'add free space' phrase in front of this one, we
needn't to redo it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ba58024..6575f89 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5806,10 +5806,6 @@ checks:
 
 		trace_btrfs_reserve_extent(orig_root, block_group,
 					   search_start, num_bytes);
-		if (offset < search_start)
-			btrfs_add_free_space(used_block_group, offset,
-					     search_start - offset);
-		BUG_ON(offset > search_start);
 		if (used_block_group != block_group)
 			btrfs_put_block_group(used_block_group);
 		btrfs_put_block_group(block_group);
-- 
1.7.7.6

