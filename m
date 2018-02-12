Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34112 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbeBLPlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:41:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFbJoj038006
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:41:35 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2g3dd885rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:41:35 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFaYMf022788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:36:34 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFaY1v020241
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:36:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use set functions to update latest refs to the SB
Date: Mon, 12 Feb 2018 23:37:49 +0800
Message-Id: <20180212153749.19705-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have btrfs_set_super...() to set the various values, so just use it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/transaction.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04f07144b45c..9220f004001c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1722,19 +1722,23 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
 
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
2.15.0

