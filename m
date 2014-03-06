Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19939 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaCFF4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:56:02 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265tv8Y010090
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:56:00 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs-progs: fsck: insert root dir into reloc data tree when reiniting it
Date: Thu, 6 Mar 2014 13:53:58 +0800
Message-Id: <1394085240-23520-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two bugs when resetting balance:

 1.we will skip reinitting reloc data tree if no reloc root found, however
  this is not right because we don't pin reloc data tree before.

 2.we should insert root dir into reloc data tree,otherwise we will fail
  to fsck.

Fix problems by forcely reiniting reloc data root and inserting root dir.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 8a3f2cd..4b2a8f0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6128,7 +6128,10 @@ static int reset_balance(struct btrfs_trans_handle *trans,
 	if (ret) {
 		if (ret > 0)
 			ret = 0;
-		goto out;
+		if (!ret)
+			goto reinit_data_reloc;
+		else
+			goto out;
 	}
 
 	ret = btrfs_del_item(trans, root, path);
@@ -6190,6 +6193,7 @@ static int reset_balance(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
+reinit_data_reloc:
 	key.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
@@ -6205,6 +6209,9 @@ static int reset_balance(struct btrfs_trans_handle *trans,
 		extent_buffer_get(root->node);
 	}
 	ret = btrfs_fsck_reinit_root(trans, root, 0);
+	if (ret)
+		goto out;
+	ret = btrfs_make_root_dir(trans, root, BTRFS_FIRST_FREE_OBJECTID);
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.9.0

