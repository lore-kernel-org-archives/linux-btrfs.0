Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3CQCMW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 22:12:22 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2H2CLll029336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2013 02:12:22 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2H2CLbH011859
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2013 02:12:21 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2H2CLk5021749
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 21:12:21 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: share stop worker code
Date: Sun, 17 Mar 2013 10:10:31 +0800
Message-Id: <1363486231-21906-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Share the exactly same code of stopping workers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c |   55 +++++++++++++++++++++------------------------------
 1 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d84651..06fa2ce 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1929,6 +1929,27 @@ static noinline int next_root_backup(struct btrfs_fs_info *info,
 	return 0;
 }
 
+/* helper to cleanup workers */
+static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
+{
+	btrfs_stop_workers(&fs_info->generic_worker);
+	btrfs_stop_workers(&fs_info->fixup_workers);
+	btrfs_stop_workers(&fs_info->delalloc_workers);
+	btrfs_stop_workers(&fs_info->workers);
+	btrfs_stop_workers(&fs_info->endio_workers);
+	btrfs_stop_workers(&fs_info->endio_meta_workers);
+	btrfs_stop_workers(&fs_info->endio_raid56_workers);
+	btrfs_stop_workers(&fs_info->rmw_workers);
+	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
+	btrfs_stop_workers(&fs_info->endio_write_workers);
+	btrfs_stop_workers(&fs_info->endio_freespace_worker);
+	btrfs_stop_workers(&fs_info->submit_workers);
+	btrfs_stop_workers(&fs_info->delayed_workers);
+	btrfs_stop_workers(&fs_info->caching_workers);
+	btrfs_stop_workers(&fs_info->readahead_workers);
+	btrfs_stop_workers(&fs_info->flush_workers);
+}
+
 /* helper to cleanup tree roots */
 static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 {
@@ -2751,22 +2772,7 @@ fail_tree_roots:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_sb_buffer:
-	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->readahead_workers);
-	btrfs_stop_workers(&fs_info->fixup_workers);
-	btrfs_stop_workers(&fs_info->delalloc_workers);
-	btrfs_stop_workers(&fs_info->workers);
-	btrfs_stop_workers(&fs_info->endio_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_workers);
-	btrfs_stop_workers(&fs_info->endio_raid56_workers);
-	btrfs_stop_workers(&fs_info->rmw_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
-	btrfs_stop_workers(&fs_info->endio_write_workers);
-	btrfs_stop_workers(&fs_info->endio_freespace_worker);
-	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->delayed_workers);
-	btrfs_stop_workers(&fs_info->caching_workers);
-	btrfs_stop_workers(&fs_info->flush_workers);
+	btrfs_stop_all_workers(fs_info);
 fail_alloc:
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
@@ -3441,22 +3447,7 @@ int close_ctree(struct btrfs_root *root)
 
 	iput(fs_info->btree_inode);
 
-	btrfs_stop_workers(&fs_info->generic_worker);
-	btrfs_stop_workers(&fs_info->fixup_workers);
-	btrfs_stop_workers(&fs_info->delalloc_workers);
-	btrfs_stop_workers(&fs_info->workers);
-	btrfs_stop_workers(&fs_info->endio_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_workers);
-	btrfs_stop_workers(&fs_info->endio_raid56_workers);
-	btrfs_stop_workers(&fs_info->rmw_workers);
-	btrfs_stop_workers(&fs_info->endio_meta_write_workers);
-	btrfs_stop_workers(&fs_info->endio_write_workers);
-	btrfs_stop_workers(&fs_info->endio_freespace_worker);
-	btrfs_stop_workers(&fs_info->submit_workers);
-	btrfs_stop_workers(&fs_info->delayed_workers);
-	btrfs_stop_workers(&fs_info->caching_workers);
-	btrfs_stop_workers(&fs_info->readahead_workers);
-	btrfs_stop_workers(&fs_info->flush_workers);
+	btrfs_stop_all_workers(fs_info);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY))
-- 
1.7.7.6

