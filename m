Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60060 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753071AbeEORwW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:52:22 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] Btrfs: use more straightforward extent_buffer_uptodate
Date: Wed, 16 May 2018 01:52:04 +0800
Message-Id: <1526406728-109055-3-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In read_block_for_search(), it's straightforward to use
extent_buffer_uptodate() instead since 0 is passed as parent transid to
btrfs_buffer_uptodate(), which means the check for parent transid is not
needed.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9fa3d77c98d4..a96d308c51b8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2445,7 +2445,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 		 * and give up so that our caller doesn't loop forever
 		 * on our EAGAINs.
 		 */
-		if (!btrfs_buffer_uptodate(tmp, 0, 0))
+		if (!extent_buffer_uptodate(tmp))
 			ret = -EIO;
 		free_extent_buffer(tmp);
 	} else {
-- 
1.8.3.1

