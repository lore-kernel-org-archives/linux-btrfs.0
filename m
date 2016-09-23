Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34302 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964947AbcIWAYc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 20:24:32 -0400
Received: by mail-pa0-f46.google.com with SMTP id wk8so34098370pab.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 17:24:32 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH v2 2/6] Btrfs: fix mount -o clear_cache,space_cache=v2
Date: Thu, 22 Sep 2016 17:24:21 -0700
Message-Id: <016aef0e9b3421cc2d2cce0914a746a14eb7af45.1474580472.git.osandov@fb.com>
In-Reply-To: <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
References: <218563982dbe4387c60909eeb0add6914a20f813.1474580472.git.osandov@fb.com>
In-Reply-To: <cover.1474580472.git.osandov@fb.com>
References: <cover.1474580472.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We moved the code for creating the free space tree the first time that
it's enabled, but didn't move the clearing code along with it. This
breaks my (undocumented) intention that `mount -o
clear_cache,space_cache=v2` would clear the free space tree and then
recreate it.

Fixes: 511711af91f2 ("btrfs: don't run delayed references while we are creating the free space tree")
Cc: stable@vger.kernel.org # 4.5+
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/disk-io.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54bc8c7..c0bfc6c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3129,6 +3129,18 @@ retry_root_backup:
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
+	if (btrfs_test_opt(fs_info, CLEAR_CACHE) &&
+	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		btrfs_info(fs_info, "clearing free space tree");
+		ret = btrfs_clear_free_space_tree(fs_info);
+		if (ret) {
+			btrfs_warn(fs_info,
+				   "failed to clear free space tree: %d", ret);
+			close_ctree(tree_root);
+			return ret;
+		}
+	}
+
 	if (btrfs_test_opt(tree_root->fs_info, FREE_SPACE_TREE) &&
 	    !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
 		btrfs_info(fs_info, "creating free space tree");
@@ -3166,18 +3178,6 @@ retry_root_backup:
 
 	btrfs_qgroup_rescan_resume(fs_info);
 
-	if (btrfs_test_opt(tree_root->fs_info, CLEAR_CACHE) &&
-	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
-		btrfs_info(fs_info, "clearing free space tree");
-		ret = btrfs_clear_free_space_tree(fs_info);
-		if (ret) {
-			btrfs_warn(fs_info,
-				"failed to clear free space tree: %d", ret);
-			close_ctree(tree_root);
-			return ret;
-		}
-	}
-
 	if (!fs_info->uuid_root) {
 		btrfs_info(fs_info, "creating UUID tree");
 		ret = btrfs_create_uuid_tree(fs_info);
-- 
2.10.0

