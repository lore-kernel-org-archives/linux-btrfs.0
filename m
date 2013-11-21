Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20685 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab3KUNmT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 08:42:19 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rALDgCfT019713
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 21:42:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs: remove unnecessary lock in may_commit_transaction()
Date: Thu, 21 Nov 2013 21:43:17 +0800
Message-Id: <1385041398-8521-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
References: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The reason is:
- The per-cpu counter has its own lock to protect itself.
- Here we need get a exact value.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 45d98d0..12a5b6d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4142,13 +4142,9 @@ static int may_commit_transaction(struct btrfs_root *root,
 		goto commit;
 
 	/* See if there is enough pinned space to make this reservation */
-	spin_lock(&space_info->lock);
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes) >= 0) {
-		spin_unlock(&space_info->lock);
+				   bytes) >= 0)
 		goto commit;
-	}
-	spin_unlock(&space_info->lock);
 
 	/*
 	 * See if there is some space in the delayed insertion reservation for
@@ -4157,16 +4153,13 @@ static int may_commit_transaction(struct btrfs_root *root,
 	if (space_info != delayed_rsv->space_info)
 		return -ENOSPC;
 
-	spin_lock(&space_info->lock);
 	spin_lock(&delayed_rsv->lock);
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
 				   bytes - delayed_rsv->size) >= 0) {
 		spin_unlock(&delayed_rsv->lock);
-		spin_unlock(&space_info->lock);
 		return -ENOSPC;
 	}
 	spin_unlock(&delayed_rsv->lock);
-	spin_unlock(&space_info->lock);
 
 commit:
 	trans = btrfs_join_transaction(root);
-- 
1.8.3.1

