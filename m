Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56195 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbeHNFcB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 01:32:01 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not pass write_lock_level when processing leaf
Date: Tue, 14 Aug 2018 10:46:53 +0800
Message-Id: <1534214813-25712-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we're going to return, it doesn't make sense to get a new
write_lock_level from unlock_up.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 41eb47488e75..f032b48094b4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2950,7 +2950,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			}
 			if (!p->search_for_split)
 				unlock_up(p, level, lowest_unlock,
-					  min_write_lock_level, &write_lock_level);
+					  min_write_lock_level, NULL);
 			goto done;
 		}
 	}
-- 
1.8.3.1
