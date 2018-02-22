Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932636AbeBVN5S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 08:57:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1MDukbS065952
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 13:57:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2g9wsh0cfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 13:57:16 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1MDvGcT015561
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 13:57:16 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1MDvGJR027793
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 13:57:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix endianness in super_copy
Date: Thu, 22 Feb 2018 21:58:42 +0800
Message-Id: <20180222135842.32459-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Moving between opposite endianness will report bogus numbers in sysfs,
and mount may fail as the root will not be restored correctly. If the
filesystem is always used on a same endian host, this will not be a
problem.
Fix this by using the btrfs_set_super...() functions to set
fs_info::super_copy values, and for the sysfs, use the cached
fs_info::nodesize,sectorsize values.

Cc: stable@vger.kernel.org
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3:
 Added sysfs.c fixes.
 Update change log. Update $Subject.
 Old:
 [PATCH v2] btrfs: fix endianness compatibility during the SB RW
v1->v2:
 Update change log. Update $Subject.
 Old:
 [PATCH] btrfs: use set functions to update latest refs to the SB

 fs/btrfs/sysfs.c       |  8 +++-----
 fs/btrfs/transaction.c | 20 ++++++++++++--------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a8bafed931f4..d11c70bff5a9 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -423,7 +423,7 @@ static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->nodesize);
 }
 
 BTRFS_ATTR(, nodesize, btrfs_nodesize_show);
@@ -433,8 +433,7 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n",
-			fs_info->super_copy->sectorsize);
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->sectorsize);
 }
 
 BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
@@ -444,8 +443,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n",
-			fs_info->super_copy->sectorsize);
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->sectorsize);
 }
 
 BTRFS_ATTR(, clone_alignment, btrfs_clone_alignment_show);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f7c410f9aca2..d0fa733081ed 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1727,19 +1727,23 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
 
 	super = fs_info->super_copy;
 
+	/* update latest btrfs_super_block::chunk_root refs */
 	root_item = &fs_info->chunk_root->root_item;
-	super->chunk_root = root_item->bytenr;
-	super->chunk_root_generation = root_item->generation;
-	super->chunk_root_level = root_item->level;
+	btrfs_set_super_chunk_root(super, root_item->bytenr);
+	btrfs_set_super_chunk_root_generation(super, root_item->generation);
+	btrfs_set_super_chunk_root_level(super, root_item->level);
 
+	/* update latest btrfs_super_block::root refs */
 	root_item = &fs_info->tree_root->root_item;
-	super->root = root_item->bytenr;
-	super->generation = root_item->generation;
-	super->root_level = root_item->level;
+	btrfs_set_super_root(super, root_item->bytenr);
+	btrfs_set_super_generation(super, root_item->generation);
+	btrfs_set_super_root_level(super, root_item->level);
+
 	if (btrfs_test_opt(fs_info, SPACE_CACHE))
-		super->cache_generation = root_item->generation;
+		btrfs_set_super_cache_generation(super, root_item->generation);
 	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
-		super->uuid_tree_generation = root_item->generation;
+		btrfs_set_super_uuid_tree_generation(super,
+						     root_item->generation);
 }
 
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
-- 
2.7.0

