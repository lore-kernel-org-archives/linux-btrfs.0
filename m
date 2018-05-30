Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65215 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S937284AbeE3InC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 04:43:02 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 553274B40405
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 16:42:52 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: return error value if create_io_em() failed in cow_file_range()
Date: Wed, 30 May 2018 16:48:56 +0800
Message-ID: <20180530084856.17264-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In cow_file_range(), create_io_em() may fail, but its return value is
not recorded.
Then return value may be 0 even it failed which is a wrong behavior.

Let cow_file_range() return PTR_ERR(em) if create_io_em() failed.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9228cb866115..14ffb4858d09 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1018,8 +1018,10 @@ static noinline int cow_file_range(struct inode *inode,
 				  ram_size, /* ram_bytes */
 				  BTRFS_COMPRESS_NONE, /* compress_type */
 				  BTRFS_ORDERED_REGULAR /* type */);
-		if (IS_ERR(em))
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
 			goto out_reserve;
+		}
 		free_extent_map(em);
 
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-- 
2.17.0



