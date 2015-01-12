Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24248 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbALQzY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 11:55:24 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com
Subject: [PATCH 1/1 v2] Btrfs: fix unused members in struct btrfs_root
Date: Tue, 13 Jan 2015 00:55:10 +0800
Message-Id: <1421081710-5005-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There isn't any real use of following members of struct btrfs_root
so delete them.

struct kobject root_kobj;
struct completion kobj_unregister;

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: accepts Filipe comment and commit update

 fs/btrfs/ctree.h   | 2 --
 fs/btrfs/disk-io.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7e60741..abf0c7b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1793,8 +1793,6 @@ struct btrfs_root {
 	struct btrfs_fs_info *fs_info;
 	struct extent_io_tree dirty_log_pages;
 
-	struct kobject root_kobj;
-	struct completion kobj_unregister;
 	struct mutex objectid_mutex;
 
 	spinlock_t accounting_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c63419..86ff8c2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1275,12 +1275,10 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
-	memset(&root->root_kobj, 0, sizeof(root->root_kobj));
 	if (fs_info)
 		root->defrag_trans_start = fs_info->generation;
 	else
 		root->defrag_trans_start = 0;
-	init_completion(&root->kobj_unregister);
 	root->root_key.objectid = objectid;
 	root->anon_dev = 0;
 
-- 
2.1.0

