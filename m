Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21682 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939494AbdEZBIy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:08:54 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q18rZ9027112
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:08:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q18qrc022795
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:08:53 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q18qhB006167
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:08:52 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: let btrfs_print_leaf print more about block group
Date: Thu, 25 May 2017 18:08:12 -0600
Message-Id: <20170526000812.31337-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds chunk_objectid and flags, with flags we can recognize whether
the block group is about data or metadata.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/print-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index cdafbf9..fcae61e 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -261,8 +261,11 @@ void btrfs_print_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *l)
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
 					    struct btrfs_block_group_item);
-			pr_info("\t\tblock group used %llu\n",
-			       btrfs_disk_block_group_used(l, bi));
+			pr_info(
+		   "\t\tblock group used %llu chunk_objectid %llu flags %llu\n",
+				btrfs_disk_block_group_used(l, bi),
+				btrfs_disk_block_group_chunk_objectid(l, bi),
+				btrfs_disk_block_group_flags(l, bi));
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
 			print_chunk(l, btrfs_item_ptr(l, i,
-- 
2.9.4

