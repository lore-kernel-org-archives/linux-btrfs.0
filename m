Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29463 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77Mumv7006231
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77MumE3027591
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v77MumCd019523
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/7] Btrfs: remove BUG() in print_extent_item
Date: Mon,  7 Aug 2017 15:55:28 -0600
Message-Id: <20170807215531.12423-5-bo.li.liu@oracle.com>
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_print_leaf() is used in btrfs_get_extent_inline_ref_type, so
here we really want to print the invalid value of ref type instead of
causing a kernel panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/print-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index fcae61e..0e52e47 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -121,7 +121,10 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
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

