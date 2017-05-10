Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751561AbdEJG6P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 02:58:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4A6n0QP009228
        for <linux-btrfs@vger.kernel.org>; Wed, 10 May 2017 02:58:15 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2abnqc0d7d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 May 2017 02:58:14 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <praveen@linux.vnet.ibm.com>;
        Wed, 10 May 2017 02:58:13 -0400
From: Praveen K Pandey <praveen@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Praveen K Pandey <praveen@linux.vnet.ibm.com>
Subject: [PATCH] btrfs-progs: record_orphan_data_extent: Fix memory leak
Date: Wed, 10 May 2017 12:28:02 +0530
Message-Id: <1494399482-15057-1-git-send-email-praveen@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The nodes of the list at btrfs_root->orphan_data_extents
are never freed causing memory to be leaked. This commit
fixes the bug by freeing the nodes on all the
btrfs_root->orphan_data_extents list.

Signed-off-by: Praveen K Pandey <praveen@linux.vnet.ibm.com>
---
 cmds-check.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 0014bc2..cac94a8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9286,6 +9286,9 @@ static int check_extent_refs(struct btrfs_root *root,
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_root *root_orphan_extent;
+	struct rb_node *rb_node;
 	int ret = 0;
 	int had_dups = 0;
 
@@ -9439,6 +9442,26 @@ static int check_extent_refs(struct btrfs_root *root,
 					   rec->start + rec->max_size - 1);
 		free(rec);
 	}
+	/*
+	 * Release memory of oprhan_data_extent
+	 * which allocated  while traversing in orphan_data_extents
+	 */
+
+	fs_info = root->fs_info;
+	rb_node = rb_first(&fs_info->fs_root_tree);
+	while (rb_node) {
+		root_orphan_extent = container_of(rb_node,
+						struct btrfs_root, rb_node);
+		free_orphan_data_extents(&root_orphan_extent->orphan_data_extents);
+		rb_node  = rb_next(rb_node);
+	}
+	free_orphan_data_extents(&fs_info->extent_root->orphan_data_extents);
+	free_orphan_data_extents(&fs_info->tree_root->orphan_data_extents);
+	free_orphan_data_extents(&fs_info->chunk_root->orphan_data_extents);
+	free_orphan_data_extents(&fs_info->dev_root->orphan_data_extents);
+	free_orphan_data_extents(&fs_info->csum_root->orphan_data_extents);
+	if (fs_info->quota_enabled)
+		free_orphan_data_extents(&fs_info->quota_root->orphan_data_extents);
 repair_abort:
 	if (repair) {
 		if (ret && ret != -EAGAIN) {
-- 
2.9.3

