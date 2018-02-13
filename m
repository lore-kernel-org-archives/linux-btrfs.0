Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42536 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933349AbeBMDBN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 22:01:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D31C46189944
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:01:13 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2g3q55r26v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:01:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1D2xKBb022100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 02:59:21 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1D2xK7K017028
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 02:59:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
Date: Tue, 13 Feb 2018 11:00:46 +0800
Message-Id: <20180213030046.14093-1-anand.jain@oracle.com>
In-Reply-To: <20180212153749.19705-1-anand.jain@oracle.com>
References: <20180212153749.19705-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fixes the endianness bug in the fs_info::super_copy by using its
btrfs_set_super...() function to set values in the SB, as these
functions manage the endianness compatibility nicely.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Update change log. Update $Subject.
        Old:
        [PATCH] btrfs: use set functions to update latest refs to the SB
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

