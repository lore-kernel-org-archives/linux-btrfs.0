Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27542 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946505AbdEZB1Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:16 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1REIL010347
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1REX1031368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:14 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v4Q1RCjJ024815
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: remove BUG() in print_extent_item
Date: Thu, 25 May 2017 18:26:29 -0600
Message-Id: <20170526002631.8546-5-bo.li.liu@oracle.com>
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_print_leaf() is used in btrfs_get_extent_inline_ref_type, so
here we really want to print the invalid value of ref type instead of
causing a kernel panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/print-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fcae61e..4448be6 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -63,6 +63,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
+	int is_data;
 
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -98,6 +99,8 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
 	}
 
+	is_data = !!(flags & BTRFS_EXTENT_FLAG_DATA);
+
 	ptr = (unsigned long)iref;
 	end = (unsigned long)ei + item_size;
 	while (ptr < end) {
@@ -121,7 +124,10 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 			       offset, btrfs_shared_data_ref_count(eb, sref));
 			break;
 		default:
-			BUG();
+			btrfs_err(eb->fs_info,
+				  "extent %llu has invalid ref type %d\n",
+				  eb->start, type);
+			return;
 		}
 		ptr += btrfs_extent_inline_ref_size(type);
 	}
-- 
2.9.4

