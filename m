Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:45340 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614Ab3B0LVB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 06:21:01 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so253005dan.9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 03:21:01 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH 2/3] Btrfs: return ENOMEM rather than use BUG_ON when btrfs_alloc_path fails
Date: Wed, 27 Feb 2013 19:20:56 +0800
Message-Id: <1361964056-2455-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Return ENOMEM rather trigger BUG_ON, fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f011d9b..69fa487 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -620,7 +620,9 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	key.offset = qgroupid;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
@@ -661,7 +663,9 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	key.offset = qgroup->qgroupid;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
@@ -702,7 +706,9 @@ static int update_qgroup_status_item(struct btrfs_trans_handle *trans,
 	key.offset = 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
-- 
1.7.7.6

