Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36520 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbeIMXGi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 19:06:38 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: remove level==0 check in balance_level
Date: Fri, 14 Sep 2018 01:55:59 +0800
Message-Id: <1536861359-55509-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
References: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_search_slot()
   if (level != 0)
      setup_nodes_for_search()
          balance_level()

It is just impossible to have level=0 in balance_level.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2: add assertion for level just in case someone breaks the rule in the
future.

 fs/btrfs/ctree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8b31caa60b0a..ada44c786f2e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1778,8 +1778,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	int orig_slot = path->slots[level];
 	u64 orig_ptr;
 
-	if (level == 0)
-		return 0;
+	ASSERT(level > 0);
 
 	mid = path->nodes[level];
 
-- 
1.8.3.1
