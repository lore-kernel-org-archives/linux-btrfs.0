Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55163 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3KBSYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 14:24:46 -0400
Received: by mail-pb0-f44.google.com with SMTP id rp16so5590755pbb.31
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Nov 2013 11:24:45 -0700 (PDT)
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org,
        Zach Brown <zab@redhat.com>
Subject: [PATCH v4] btrfs: Add helper function for free_root_pointers()
Date: Sat,  2 Nov 2013 23:54:36 +0530
Message-Id: <1383416676-16591-1-git-send-email-rashika.kheria@gmail.com>
In-Reply-To: <20131030204834.GA20844@gmail.com>
References: <20131030204834.GA20844@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function free_root_pointers() in disk-io.h contains redundant code.
Therefore, this patch adds a helper function free_root_extent_buffers()
to free_root_pointers() to eliminate redundancy

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Zach Brown <zab@redhat.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---

This revision fixes the following issues of the previous revision-
Early return when root is NULL

 fs/btrfs/disk-io.c |   60 +++++++++++++++++-----------------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..f719394 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2013,50 +2013,28 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
 }
 
+static void free_root_extent_buffers(struct btrfs_root *root)
+{
+	if (!root)
+		return;
+	free_extent_buffer(root->node);
+	free_extent_buffer(root->commit_root);
+	root->node = NULL;
+	root->commit_root = NULL;
+}
+
 /* helper to cleanup tree roots */
 static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 {
-	free_extent_buffer(info->tree_root->node);
-	free_extent_buffer(info->tree_root->commit_root);
-	info->tree_root->node = NULL;
-	info->tree_root->commit_root = NULL;
-
-	if (info->dev_root) {
-		free_extent_buffer(info->dev_root->node);
-		free_extent_buffer(info->dev_root->commit_root);
-		info->dev_root->node = NULL;
-		info->dev_root->commit_root = NULL;
-	}
-	if (info->extent_root) {
-		free_extent_buffer(info->extent_root->node);
-		free_extent_buffer(info->extent_root->commit_root);
-		info->extent_root->node = NULL;
-		info->extent_root->commit_root = NULL;
-	}
-	if (info->csum_root) {
-		free_extent_buffer(info->csum_root->node);
-		free_extent_buffer(info->csum_root->commit_root);
-		info->csum_root->node = NULL;
-		info->csum_root->commit_root = NULL;
-	}
-	if (info->quota_root) {
-		free_extent_buffer(info->quota_root->node);
-		free_extent_buffer(info->quota_root->commit_root);
-		info->quota_root->node = NULL;
-		info->quota_root->commit_root = NULL;
-	}
-	if (info->uuid_root) {
-		free_extent_buffer(info->uuid_root->node);
-		free_extent_buffer(info->uuid_root->commit_root);
-		info->uuid_root->node = NULL;
-		info->uuid_root->commit_root = NULL;
-	}
-	if (chunk_root) {
-		free_extent_buffer(info->chunk_root->node);
-		free_extent_buffer(info->chunk_root->commit_root);
-		info->chunk_root->node = NULL;
-		info->chunk_root->commit_root = NULL;
-	}
+	free_root_extent_buffers(info->tree_root);
+
+	free_root_extent_buffers(info->dev_root);
+	free_root_extent_buffers(info->extent_root);
+	free_root_extent_buffers(info->csum_root);
+	free_root_extent_buffers(info->quota_root);
+	free_root_extent_buffers(info->uuid_root);
+	if (chunk_root)
+		free_root_extent_buffers(info->chunk_root);
 }
 
 static void del_fs_roots(struct btrfs_fs_info *fs_info)
-- 
1.7.9.5

