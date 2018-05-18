Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:49472 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751985AbeERDAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 23:00:40 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/6] Btrfs: use more straightforward extent_buffer_uptodate
Date: Fri, 18 May 2018 11:00:20 +0800
Message-Id: <1526612424-97061-3-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If parent_transid "0" is passed to btrfs_buffer_uptodate(),
btrfs_buffer_uptodate() is equivalent to extent_buffer_uptodate(), but
extent_buffer_uptodate() is preferred since we don't have to look into
verify_parent_transid().

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

