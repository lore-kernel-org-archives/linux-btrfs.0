Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20990 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRJbO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 05:31:14 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: make use of inode_need_compress()
Date: Tue, 18 Jul 2017 17:37:47 +0800
Message-Id: <20170718093747.19046-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Its better to have the policy enforcement going through a function,
so that we have better control and visibility of the decision logic.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 06dea7c89bbd..d0cc3de120b7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1189,11 +1189,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
-		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
-			cur_end = end;
-		else
+		if (inode_need_compress(inode))
 			cur_end = min(end, start + SZ_512K - 1);
+		else
+			cur_end = end;
 
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
-- 
2.13.1

