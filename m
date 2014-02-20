Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaBTKHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7YYM011826
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] Btrfs: remove unnecessary memory barrier in btrfs_sync_log()
Date: Thu, 20 Feb 2014 18:08:55 +0800
Message-Id: <1392890939-19044-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mutex unlock implies certain memory barriers to make sure all the memory
operation completes before the unlock, and the next mutex lock implies memory
barriers to make sure the all the memory happens after the lock. So it is
a full memory barrier(smp_mb), we needn't add memory barriers. Remove them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 51d1bd9..c9f2479 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2497,7 +2497,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	root->log_transid++;
 	log->log_transid = root->log_transid;
 	root->log_start_pid = 0;
-	smp_mb();
 	/*
 	 * IO has been started, blocks of the log tree have WRITTEN flag set
 	 * in their headers. new modifications of the log will be written to
@@ -2590,8 +2589,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 				btrfs_header_level(log_root_tree->node));
 
 	log_root_tree->log_transid++;
-	smp_mb();
-
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	/*
-- 
1.8.1.4

