Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:63913 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755199AbcK1VGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 16:06:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Filipe Manana <fdmanana@suse.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Jeff Mahoney <jeffm@suse.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix uninitialized variable access after ASSERT
Date: Mon, 28 Nov 2016 22:05:40 +0100
Message-Id: <20161128210606.2321419-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs, ASSERT() has no effect if CONFIG_BTRFS_ASSERT is disabled,
and gcc notices that this can lead to using an uninitialized variable:

fs/btrfs/inode.c: In function 'run_delalloc_range':
fs/btrfs/inode.c:1190:18: error: 'cur_end' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I assume the condition that the ASSERT checks for is actually
correct and we won't get there in practice, but it's easy to
modify the function to make it simpler and avoid the condition
that the warning is for.

Fixes: e5249f75cfd0 ("btrfs: Introduce COMPRESS reserve type to fix false enospc for compression")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/inode.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6f35d923d67..b1d2b38d29aa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1175,18 +1175,14 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL, GFP_NOFS);
 	while (start < end) {
+		ASSERT(reserve_type == BTRFS_RESERVE_COMPRESS);
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow); /* -ENOMEM */
 		async_cow->inode = igrab(inode);
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
-
-		if (reserve_type == BTRFS_RESERVE_COMPRESS)
-			cur_end = min(end, start + SZ_512K - 1);
-		else
-			ASSERT(0);
-
+		cur_end = min(end, start + SZ_512K - 1);
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
 
-- 
2.9.0

