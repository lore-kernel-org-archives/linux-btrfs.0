Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46055 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbaDWLg6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 07:36:58 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3NBaslO001622
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 19:36:54 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] Btrfs: fix possible memory leaks in open_ctree()
Date: Wed, 23 Apr 2014 19:33:35 +0800
Message-ID: <1398252816-30600-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix possible memory leaks in the following error handling paths:

read_tree_block()
btrfs_recover_log_trees
btrfs_commit_super()
btrfs_find_orphan_roots()
btrfs_cleanup_fs_roots()

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d1ac7d..0e4fb4a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2864,7 +2864,7 @@ retry_root_backup:
 			printk(KERN_ERR "BTRFS: failed to read log tree\n");
 			free_extent_buffer(log_tree_root->node);
 			kfree(log_tree_root);
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 		/* returns with log_tree_root freed on success */
 		ret = btrfs_recover_log_trees(log_tree_root);
@@ -2873,24 +2873,24 @@ retry_root_backup:
 				    "Failed to recover log tree");
 			free_extent_buffer(log_tree_root->node);
 			kfree(log_tree_root);
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 		}
 
 		if (sb->s_flags & MS_RDONLY) {
 			ret = btrfs_commit_super(tree_root);
 			if (ret)
-				goto fail_trans_kthread;
+				goto fail_qgroup;
 		}
 	}
 
 	ret = btrfs_find_orphan_roots(tree_root);
 	if (ret)
-		goto fail_trans_kthread;
+		goto fail_qgroup;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_cleanup_fs_roots(fs_info);
 		if (ret)
-			goto fail_trans_kthread;
+			goto fail_qgroup;
 
 		ret = btrfs_recover_relocation(tree_root);
 		if (ret < 0) {
-- 
1.9.0

