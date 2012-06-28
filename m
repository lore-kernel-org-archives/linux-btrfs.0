Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777Ab2F1KCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jun 2012 06:02:31 -0400
Date: Thu, 28 Jun 2012 12:02:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Cc: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix typo in cow_file_range_async and
 async_cow_submit
Message-ID: <alpine.LNX.2.00.1206281201280.17549@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

It should be 10 * 1024 * 1024.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3bb6b25..a0e2c1b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1008,7 +1008,7 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	atomic_sub(nr_pages, &root->fs_info->async_delalloc_pages);
 
 	if (atomic_read(&root->fs_info->async_delalloc_pages) <
-	    5 * 1042 * 1024 &&
+	    5 * 1024 * 1024 &&
 	    waitqueue_active(&root->fs_info->async_submit_wait))
 		wake_up(&root->fs_info->async_submit_wait);
 
@@ -1031,7 +1031,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	unsigned long nr_pages;
 	u64 cur_end;
-	int limit = 10 * 1024 * 1042;
+	int limit = 10 * 1024 * 1024;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL, GFP_NOFS);

-- 
Jiri Kosina
SUSE Labs
