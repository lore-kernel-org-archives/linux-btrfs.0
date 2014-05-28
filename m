Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21000 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752710AbaE1LY0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 07:24:26 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4SBOOeA029425
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 19:24:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] Btrfs-progs: fsck: deal with corrupted csum root
Date: Wed, 28 May 2014 19:20:40 +0800
Message-ID: <1401276041-18349-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If checksum root is corrupted, fsck will get segmentation. This
is because if we fail to load checksum root, root's node is NULL which
cause NULL pointer deferences later.

To fix this problem, we just did something like extent tree rebuilding.
Allocate a new one and clear uptodate flag. We will do sanity check
before fsck going on.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 5 +++++
 disk-io.c    | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 0e4e042..55e7753 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6963,6 +6963,11 @@ int cmd_check(int argc, char **argv)
 		ret = -EIO;
 		goto close_out;
 	}
+	if (!extent_buffer_uptodate(info->csum_root->node)) {
+		fprintf(stderr, "Checksum root corrupted, run to rerun with --init-csum-tree option\n");
+		ret = -EIO;
+		goto close_out;
+	}
 
 	fprintf(stderr, "checking extents\n");
 	ret = check_chunks_and_extents(root);
diff --git a/disk-io.c b/disk-io.c
index 63e153d..bbfd8e7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -914,6 +914,13 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		printk("Couldn't setup csum tree\n");
 		if (!(flags & OPEN_CTREE_PARTIAL))
 			return -EIO;
+		/* do the same thing as extent tree rebuilding */
+		fs_info->csum_root->node =
+			btrfs_find_create_tree_block(fs_info->extent_root, 0,
+						     leafsize);
+		if (!fs_info->csum_root->node)
+			return -ENOMEM;
+		clear_extent_buffer_uptodate(NULL, fs_info->csum_root->node);
 	}
 	fs_info->csum_root->track_dirty = 1;
 
-- 
1.9.0

