Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19939 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaCFF4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:56:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265txX3010095
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:56:00 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs-progs: fsck: force to udate tree root for some cases
Date: Thu, 6 Mar 2014 13:53:59 +0800
Message-Id: <1394085240-23520-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit roots won't update root item in tree root if it finds
updated root's bytenr is same as before.

However, this is not right for fsck, we need update tree root in
the following case:

1.overwrite previous root node.

2.reinit reloc data tree, this is because we skip pin relo data
 tree before which means we can allocate same block as before.

Fix this by updating tree root ourselves for the above cases.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4b2a8f0..ae611d1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5906,6 +5906,7 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 	struct extent_buffer *c;
 	struct extent_buffer *old = root->node;
 	int level;
+	int ret;
 	struct btrfs_disk_key disk_key = {0,0,0};
 
 	level = 0;
@@ -5922,6 +5923,7 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 	if (IS_ERR(c)) {
 		c = old;
 		extent_buffer_get(c);
+		overwrite = 1;
 	}
 init:
 	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
@@ -5939,7 +5941,26 @@ init:
 			    BTRFS_UUID_SIZE);
 
 	btrfs_mark_buffer_dirty(c);
-
+	/*
+	 * this case can happen in the following case:
+	 *
+	 * 1.overwrite previous root.
+	 *
+	 * 2.reinit reloc data root, this is because we skip pin
+	 * down reloc data tree before which means we can allocate
+	 * same block bytenr here.
+	 */
+	if (old->start == c->start) {
+		btrfs_set_root_generation(&root->root_item,
+					  trans->transid);
+		root->root_item.level = btrfs_header_level(root->node);
+		ret = btrfs_update_root(trans, root->fs_info->tree_root,
+					&root->root_key, &root->root_item);
+		if (ret) {
+			free_extent_buffer(c);
+			return ret;
+		}
+	}
 	free_extent_buffer(old);
 	root->node = c;
 	add_root_to_dirty_list(root);
-- 
1.9.0

