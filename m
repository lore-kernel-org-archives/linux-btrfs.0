Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56697 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728018AbeILDIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:18 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove level==0 check in balance_level
Date: Wed, 12 Sep 2018 06:06:23 +0800
Message-Id: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_search_slot()
   if (level != 0)
      setup_nodes_for_search()
          balance_level()

It is just impossible to have level=0 in balance_level.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8b31caa60b0a..858085490e23 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1778,9 +1778,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	int orig_slot = path->slots[level];
 	u64 orig_ptr;
 
-	if (level == 0)
-		return 0;
-
 	mid = path->nodes[level];
 
 	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
-- 
1.8.3.1
