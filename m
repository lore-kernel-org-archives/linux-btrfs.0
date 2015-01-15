Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37453 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbAOGwV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 01:52:21 -0500
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 15 Jan 2015 12:22:19 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id C50241258056
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 12:23:04 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0F6qGSc56033374
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 12:22:16 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0F6qFBB019190
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 12:22:16 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: insert_new_root: Fix lock type of the extent buffer.
Date: Thu, 15 Jan 2015 12:22:03 +0530
Message-Id: <1421304723-16913-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_alloc_tree_block() returns an extent buffer on which a blocked lock has
been taken. Hence assign the appropriate value to path->locks[level].

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 14a72ed..1747aa6 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3383,7 +3383,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	add_root_to_dirty_list(root);
 	extent_buffer_get(c);
 	path->nodes[level] = c;
-	path->locks[level] = BTRFS_WRITE_LOCK;
+	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 	path->slots[level] = 0;
 	return 0;
 }
-- 
2.1.0

