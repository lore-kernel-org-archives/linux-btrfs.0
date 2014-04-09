Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933109AbaDIL0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 07:26:09 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s39BPsdn027375
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Apr 2014 19:25:54 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure there are not any read requests before stopping workers
Date: Wed, 9 Apr 2014 19:23:22 +0800
Message-ID: <1397042602-23205-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In close_ctree(), after we have stopped all workers,there maybe still
some read requests(for example readahead) to submit and this *maybe* trigger
an oops that user reported before:

kernel BUG at fs/btrfs/async-thread.c:619!

By hacking codes, i can reproduce this problem with one cpu available.
We fix this potential problem by invalidating all btree inode pages before
stopping all workers.

Thanks to Miao for pointing out this problem.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d9698fd..8a49823 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3619,6 +3619,11 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_free_block_groups(fs_info);
 
+	/*
+	 * we must make sure there is not any read request to
+	 * submit after we stopping all workers.
+	 */
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
 	free_root_pointers(fs_info, 1);
-- 
1.9.0

