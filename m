Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab3AVKt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 05:49:58 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0MAnuQj019352
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 18:49:56 +0800
Message-ID: <50FE6EFB.1030108@cn.fujitsu.com>
Date: Tue, 22 Jan 2013 18:50:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: traverse and flush the delalloc inodes once
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_start_delalloc_inodes() needn't traverse and flush the delalloc inodes
repeatedly. It is because we can regard the data that the users write after
we start delalloc inodes flush as the one which is after the delalloc inodes
flush is done, and we can flush it next time.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 86f1d25..d5f687b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7557,7 +7557,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 
 	INIT_LIST_HEAD(&works);
 	INIT_LIST_HEAD(&splice);
-again:
+
 	spin_lock(&root->fs_info->delalloc_lock);
 	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
 	while (!list_empty(&splice)) {
@@ -7593,13 +7593,6 @@ again:
 		btrfs_wait_and_free_delalloc_work(work);
 	}
 
-	spin_lock(&root->fs_info->delalloc_lock);
-	if (!list_empty(&root->fs_info->delalloc_inodes)) {
-		spin_unlock(&root->fs_info->delalloc_lock);
-		goto again;
-	}
-	spin_unlock(&root->fs_info->delalloc_lock);
-
 	/* the filemap_flush will queue IO into the worker threads, but
 	 * we have to make sure the IO is actually started and that
 	 * ordered extents get created before we return
-- 
1.6.5.2
