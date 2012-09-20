Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58145 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2ITEOb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 00:14:31 -0400
Message-ID: <505A9825.1070402@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 12:14:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix memory leak in start_transaction()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes memory leak of the transaction handle which happened
when starting transaction failed on a freezed fs.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is based on btrfs-next tree
---
 fs/btrfs/transaction.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e766d37..9bf9f6f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -351,8 +351,10 @@ again:
 	 */
 	if (type != TRANS_JOIN_NOLOCK &&
 	    !__sb_start_write(root->fs_info->sb, SB_FREEZE_FS, false)) {
-		if (type == TRANS_JOIN_FREEZE)
+		if (type == TRANS_JOIN_FREEZE) {
+			kmem_cache_free(btrfs_trans_handle_cachep, h);
 			return ERR_PTR(-EPERM);
+		}
 		sb_start_intwrite(root->fs_info->sb);
 	}
 
-- 
1.7.6.5
