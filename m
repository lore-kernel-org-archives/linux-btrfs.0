Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:41839 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbA3Lvs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 06:51:48 -0500
From: Forrest Liu <forrestl@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Forrest Liu <forrestl@synology.com>
Subject: [PATCH] Btrfs: add missing blk_finish_plug in btrfs_sync_log()
Date: Fri, 30 Jan 2015 19:42:12 +0800
Message-Id: <1422618132-30272-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add missing blk_finish_plug in btrfs_sync_log()

Signed-off-by: Forrest Liu <forrestl@synology.com>
---
 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a266587..06f0283 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2623,6 +2623,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	}
 
 	if (log_root_tree->log_transid_committed >= root_log_ctx.log_transid) {
+		blk_finish_plug(&plug);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = root_log_ctx.log_ret;
 		goto out;
-- 
1.9.1

