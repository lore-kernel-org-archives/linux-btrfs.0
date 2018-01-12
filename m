Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56239 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932538AbeALDDp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 22:03:45 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 4CDD948AE82D
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 11:03:42 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: correct wrong comment about magic number of index_cnt
Date: Fri, 12 Jan 2018 11:08:03 +0800
Message-ID: <20180112030803.28341-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180112030803.28341-1-suy.fnst@cn.fujitsu.com>
References: <20180112030803.28341-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no function named btrfs_get_inode_index_count.
Explanation for magic number index_cnt=2 in btrfs_new_inode() is
actually located in btrfs_set_inode_index_count().

So replace 'btrfs_get_inode_index_count' in the comment by
'btrfs_set_inode_index_count'.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 37bdb78b4766..f6454719192e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6315,7 +6315,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	}
 	/*
 	 * index_cnt is ignored for everything but a dir,
-	 * btrfs_get_inode_index_count has an explanation for the magic
+	 * btrfs_set_inode_index_count has an explanation for the magic
 	 * number
 	 */
 	BTRFS_I(inode)->index_cnt = 2;
-- 
2.15.1



