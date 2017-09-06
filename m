Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10687 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753525AbdIFBnG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 21:43:06 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 967D64725550
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Sep 2017 09:43:02 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Use clean_tree_block when btrfs_update_root fail
Date: Wed, 6 Sep 2017 09:42:58 +0800
Message-ID: <1504662179-21877-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_fsck_reinit_root, when btrfs_alloc_free_block fail, it will
update on original root.
Before update it, used btrfs_mark_buffer_dirty to set the flag to EXTENT_DIRTY.
So, we should call clean_tree_block to clear the flag if update fail.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index 006edbde..6bd55e90 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11652,6 +11652,7 @@ init:
 		ret = btrfs_update_root(trans, root->fs_info->tree_root,
 					&root->root_key, &root->root_item);
 		if (ret) {
+			clean_tree_block(trans, root, c);
 			free_extent_buffer(c);
 			return ret;
 		}
-- 
2.13.5



