Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758288Ab3HNBPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 21:15:24 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r7E1FJoX025722
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 09:15:19 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] Btrfs: move btrfs_free_qgroup_config() out of spin_lock and fix comments
Date: Wed, 14 Aug 2013 09:13:37 +0800
Message-Id: <1376442818-7587-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1376442818-7587-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1376442818-7587-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_qgroup_config() is not only called by open/close_ctree(),but
also btrfs_disable_quota().And for btrfs_disable_quota(),we have set
'quota_root' to be null before calling btrfs_free_qgroup_config(),so it
is safe to cleanup in-memory structures without lock held.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
v1->v2: fix a type spotted by Arne
---
 fs/btrfs/qgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 57b9805..01eeffe 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -432,8 +432,10 @@ out:
 }
 
 /*
- * This is only called from close_ctree() or open_ctree(), both in single-
- * treaded paths. Clean up the in-memory structures. No locking needed.
+ * This is called from close_ctree() or open_ctree() or btrfs_quota_disable(),
+ * first two are in single-threaded paths.And for the third one, we have set
+ * quota_root to be null with qgroup_lock held before, so it is safe to clean
+ * up the in-memory structures without qgroup_lock held.
  */
 void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 {
@@ -937,9 +939,10 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	fs_info->pending_quota_state = 0;
 	quota_root = fs_info->quota_root;
 	fs_info->quota_root = NULL;
-	btrfs_free_qgroup_config(fs_info);
 	spin_unlock(&fs_info->qgroup_lock);
 
+	btrfs_free_qgroup_config(fs_info);
+
 	if (!quota_root) {
 		ret = -EINVAL;
 		goto out;
-- 
1.8.0.1

