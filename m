Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:43808 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3EQSI0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 14:08:26 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 7AF879A068E
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 12:08:25 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id fkYH79mmtVKZKc8x (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 12:08:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure roots are assigned before freeing their nodes
Date: Fri, 17 May 2013 14:08:22 -0400
Message-ID: <1368814102-1414-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fail to load the chunk tree we'll call free_root_pointers, except we may
not have assigned the roots for the dev_root/extent_root/csum_root yet, so we
could NULL pointer deref at this point.  Just add checks to make sure these
roots are set to keep us from panicing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   39 +++++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1341247..84c4426 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1967,30 +1967,33 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 {
 	free_extent_buffer(info->tree_root->node);
 	free_extent_buffer(info->tree_root->commit_root);
-	free_extent_buffer(info->dev_root->node);
-	free_extent_buffer(info->dev_root->commit_root);
-	free_extent_buffer(info->extent_root->node);
-	free_extent_buffer(info->extent_root->commit_root);
-	free_extent_buffer(info->csum_root->node);
-	free_extent_buffer(info->csum_root->commit_root);
-	if (info->quota_root) {
-		free_extent_buffer(info->quota_root->node);
-		free_extent_buffer(info->quota_root->commit_root);
-	}
-
 	info->tree_root->node = NULL;
 	info->tree_root->commit_root = NULL;
-	info->dev_root->node = NULL;
-	info->dev_root->commit_root = NULL;
-	info->extent_root->node = NULL;
-	info->extent_root->commit_root = NULL;
-	info->csum_root->node = NULL;
-	info->csum_root->commit_root = NULL;
+
+	if (info->dev_root) {
+		free_extent_buffer(info->dev_root->node);
+		free_extent_buffer(info->dev_root->commit_root);
+		info->dev_root->node = NULL;
+		info->dev_root->commit_root = NULL;
+	}
+	if (info->extent_root) {
+		free_extent_buffer(info->extent_root->node);
+		free_extent_buffer(info->extent_root->commit_root);
+		info->extent_root->node = NULL;
+		info->extent_root->commit_root = NULL;
+	}
+	if (info->csum_root) {
+		free_extent_buffer(info->csum_root->node);
+		free_extent_buffer(info->csum_root->commit_root);
+		info->csum_root->node = NULL;
+		info->csum_root->commit_root = NULL;
+	}
 	if (info->quota_root) {
+		free_extent_buffer(info->quota_root->node);
+		free_extent_buffer(info->quota_root->commit_root);
 		info->quota_root->node = NULL;
 		info->quota_root->commit_root = NULL;
 	}
-
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
 		free_extent_buffer(info->chunk_root->commit_root);
-- 
1.7.7.6

