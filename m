Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54321 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3H2UxQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 16:53:16 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4239E7C0697
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 14:53:16 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id K7NmWjHHxaMoKMof (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 14:53:13 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't use an async starter for most of our workers
Date: Thu, 29 Aug 2013 16:53:11 -0400
Message-ID: <1377809591-25700-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We only need an async starter if we can't make a GFP_NOFS allocation in our
current path.  This is the case for the endio stuff since it happens in IRQ
context, but things like the caching thread workers and the delalloc flushers we
can easily make this allocation and start threads right away.  Also change the
worker count for the caching thread pool.  Traditionally we limited this to 2
since we took read locks while caching, but nowadays we do this lockless so
there's no reason to limit the number of caching threads.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 69e9afb..fa8b2c6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2482,20 +2482,17 @@ int open_ctree(struct super_block *sb,
 			   &fs_info->generic_worker);
 
 	btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+			   fs_info->thread_pool_size, NULL);
 
 	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
-			   fs_info->thread_pool_size,
-			   &fs_info->generic_worker);
+			   fs_info->thread_pool_size, NULL);
 
 	btrfs_init_workers(&fs_info->submit_workers, "submit",
 			   min_t(u64, fs_devices->num_devices,
-			   fs_info->thread_pool_size),
-			   &fs_info->generic_worker);
+			   fs_info->thread_pool_size), NULL);
 
 	btrfs_init_workers(&fs_info->caching_workers, "cache",
-			   2, &fs_info->generic_worker);
+			   fs_info->thread_pool_size, NULL);
 
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
-- 
1.7.7.6

