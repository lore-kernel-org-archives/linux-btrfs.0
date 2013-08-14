Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14615 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab3HNBPZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 21:15:25 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r7E1FJS9025721
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 09:15:20 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] Btrfs: remove reduplicate check when disabling quota
Date: Wed, 14 Aug 2013 09:13:38 +0800
Message-Id: <1376442818-7587-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1376442818-7587-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1376442818-7587-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have checked 'quota_root' with qgroup_ioctl_lock held before,So
here the check is reduplicate, remove it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: Arne Jansen <sensille@gmx.net>
---
v1->v2: nothing(except adding Arne's reviewed-by)
---
 fs/btrfs/qgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 01eeffe..66c58e1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -943,11 +943,6 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 
 	btrfs_free_qgroup_config(fs_info);
 
-	if (!quota_root) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = btrfs_clean_quota_tree(trans, quota_root);
 	if (ret)
 		goto out;
-- 
1.8.0.1

