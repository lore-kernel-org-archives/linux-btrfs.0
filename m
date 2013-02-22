Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60096 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3BVMC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 07:02:26 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so371812pbc.36
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 04:02:25 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH 1/2] Btrfs: create the qgroup that limits root subvolume automatically
Date: Fri, 22 Feb 2013 20:02:20 +0800
Message-Id: <1361534540-2381-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Creating the root subvolume qgroup when enabling quota,with
this patch,it will be ok to limit the whole filesystem size.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/qgroup.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a5c8562..c409096 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -777,6 +777,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	int ret = 0;
+	struct btrfs_qgroup *qgroup = NULL;
 
 	spin_lock(&fs_info->qgroup_lock);
 	if (fs_info->quota_root) {
@@ -823,7 +824,18 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 
 	btrfs_mark_buffer_dirty(leaf);
 
+	btrfs_release_path(path);
+	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
+	if (ret)
+		goto out;
+
 	spin_lock(&fs_info->qgroup_lock);
+	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
+	if (IS_ERR(qgroup)) {
+		spin_unlock(&fs_info->qgroup_lock);
+		ret = PTR_ERR(qgroup);
+		goto out;
+	}
 	fs_info->quota_root = quota_root;
 	fs_info->pending_quota_state = 1;
 	spin_unlock(&fs_info->qgroup_lock);
-- 
1.7.7.6

