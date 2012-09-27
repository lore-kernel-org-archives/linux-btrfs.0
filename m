Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22943 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab2I0JJI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 05:09:08 -0400
Message-ID: <506417BB.5050408@cn.fujitsu.com>
Date: Thu, 27 Sep 2012 17:09:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] Btrfs: fix wrong calculation of the available space when
 reserving the space
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to the comment, we can overcommit the space up to 1/2 of the total
disk space, or we just can overcommit up to 1/8. But the code was written
reversedly. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This is based on btrfs-next tree.
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a010234..8a01087 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3962,9 +3962,9 @@ again:
 		 * 1/2 of the space.
 		 */
 		if (flush)
-			avail >>= 3;
-		else
 			avail >>= 1;
+		else
+			avail >>= 3;
 		 spin_unlock(&root->fs_info->free_chunk_lock);
 
 		if (used + num_bytes < space_info->total_bytes + avail) {
-- 
1.6.5.2
