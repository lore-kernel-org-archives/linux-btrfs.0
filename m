Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaCFF4B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:56:01 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265tv8X010090
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:55:59 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs-progs: fsck: reset balance after reiniting extent root
Date: Thu, 6 Mar 2014 13:53:57 +0800
Message-Id: <1394085240-23520-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reset balance need cow block which will insert extent item into
extent tree. If we do this before reinitting extent root, we may
encounter EEIXST.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 3cf59b6..8a3f2cd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6253,12 +6253,6 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = reset_balance(trans, fs_info);
-	if (ret) {
-		fprintf(stderr, "error reseting the pending balance\n");
-		return ret;
-	}
-
 	/* Ok we can allocate now, reinit the extent root */
 	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root, 0);
 	if (ret) {
@@ -6293,7 +6287,11 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 		btrfs_extent_post_op(trans, fs_info->extent_root);
 	}
 
-	return 0;
+	ret = reset_balance(trans, fs_info);
+	if (ret)
+		fprintf(stderr, "error reseting the pending balance\n");
+
+	return ret;
 }
 
 static int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb)
-- 
1.9.0

