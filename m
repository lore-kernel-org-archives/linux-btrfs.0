Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab3HGFOE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 01:14:04 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com
Subject: [PATCH 3/3] Btrfs: remove reduplicate check when disabling quota
Date: Wed, 7 Aug 2013 13:12:31 +0800
Message-Id: <1375852351-11919-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have checked 'quota_root' with qgroup_ioctl_lock held before,So
here the check is reduplicate, remove it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b809616..df2841d 100644
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

