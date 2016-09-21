Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36126 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752139AbcIUHGW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 03:06:22 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, dsterba@suse.cz
Subject: [PATCH 2/2] btrfs: try to write enough delalloc bytes when reclaiming metadata space
Date: Wed, 21 Sep 2016 14:59:33 +0800
Message-Id: <1474441173-31049-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <1474441173-31049-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1474441173-31049-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Indeed as long as we have delalloc bytes and if we fail to reclaim
requested metadata space, we should write these delalloc bytes and
have one more try, this can fix some false enospc errors in some
extreme cases.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fdfc97f..46c2a37 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4794,6 +4794,15 @@ static int may_commit_transaction(struct btrfs_root *root,
 {
 	struct btrfs_block_rsv *delayed_rsv = &root->fs_info->delayed_block_rsv;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	/*
+	 * shrink_delalloc() may not write enough delalloc bytes, so here we
+	 * have a last try. Please don't remove these, because these can fix
+	 * some false enospc error in some extreme cases.
+	 */
+	btrfs_start_delalloc_roots(fs_info, 0, -1);
+	btrfs_wait_ordered_roots(fs_info, -1, 0, (u64)-1);
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	if (trans)
-- 
2.7.4



