Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32493 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaAGJ2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 04:28:19 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, stable@vger.kernel.org
Subject: [PATCH v2 4/4] Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()
Date: Tue, 7 Jan 2014 17:26:58 +0800
Message-Id: <1389086818-19794-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1389086818-19794-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1389086818-19794-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We may return early in btrfs_drop_snapshot(), we shouldn't
call btrfs_std_err() for this case, fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog v1->v2: cc stable
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4fa1437..81650cf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8272,7 +8272,7 @@ out:
 	 */
 	if (!for_reloc && root_dropped == false)
 		btrfs_add_dead_root(root);
-	if (err)
+	if (err && err != -EAGAIN)
 		btrfs_std_error(root->fs_info, err);
 	return err;
 }
-- 
1.8.3.1

