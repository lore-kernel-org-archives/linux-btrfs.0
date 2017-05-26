Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26122 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948893AbdE0ApF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 20:45:05 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4R0j4qv030860
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 00:45:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4R0j3XQ021244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 00:45:04 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4R0j3XT019702
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 00:45:03 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io
Date: Fri, 26 May 2017 17:44:23 -0600
Message-Id: <20170526234423.25913-1-bo.li.liu@oracle.com>
In-Reply-To: <1494370935-19965-1-git-send-email-bo.li.liu@oracle.com>
References: <1494370935-19965-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this, we use 'filled' mode here, ie. if all range has been
filled with EXTENT_DEFRAG bits, get to clear it, but if the defrag
range joins the adjacent delalloc range, then we'll have EXTENT_DEFRAG
bits in extent_state until releasing this inode's pages, and that
prevents extent_date from being freed.

This clears the bit if any was found within the ordered extent.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Improve changelog.

 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 78ab511..1293810 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2875,7 +2875,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 	ret = test_range_bit(io_tree, ordered_extent->file_offset,
 			ordered_extent->file_offset + ordered_extent->len - 1,
-			EXTENT_DEFRAG, 1, cached_state);
+			EXTENT_DEFRAG, 0, cached_state);
 	if (ret) {
 		u64 last_snapshot = btrfs_root_last_snapshot(&root->root_item);
 		if (0 && last_snapshot >= BTRFS_I(inode)->generation)
-- 
2.5.5

