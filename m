Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45778 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761947Ab3JPR4w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 13:56:52 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EF8379A06BD
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 11:56:51 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id JL9xNidZGsDguyCe (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 11:56:51 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: stop all workers after we free block groups
Date: Wed, 16 Oct 2013 13:56:50 -0400
Message-ID: <1381946210-12656-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan was hitting a panic in the async worker stuff because we had outstanding
read bios while we were stopping the worker threads.  You could reproduce this
easily if you mount -o nospace_cache and ran generic/273.  This is because the
caching thread stuff is still going and we were stopping all the worker threads.
We need to stop the workers after this work is done, and the free block groups
code will wait for all the caching threads to stop first so we don't run into
this problem.  With this patch we no longer panic.  Thanks,

Reported-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 419968e..b0ea9f4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3637,12 +3637,12 @@ int close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	btrfs_stop_all_workers(fs_info);
-
 	del_fs_roots(fs_info);
 
 	btrfs_free_block_groups(fs_info);
 
+	btrfs_stop_all_workers(fs_info);
+
 	free_root_pointers(fs_info, 1);
 
 	iput(fs_info->btree_inode);
-- 
1.8.3.1

