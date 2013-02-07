Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3BGGAx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 01:00:53 -0500
Message-ID: <5113433F.80500@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 14:01:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Ito <t-itoh@jp.fujitsu.com>, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] Btrfs: fix the race between bio and btrfs_stop_workers
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

open_ctree() need read the metadata to initialize the global information
of btrfs. But it may fail after it submit some bio, and then it will jump
to the error path. Unfortunately, it doesn't check if there are some bios
in flight, and just stop all the worker threads. As a result, when the
submitted bios end, they can not find any worker thread which can deal with
subsequent work, then oops happen.

kernel BUG at fs/btrfs/async-thread.c:605!

Fix this problem by invoking invalidate_inode_pages2() before we stop the
worker threads. This function will wait until the bio end because it need
lock the pages which are going to be invalidated, and if a page is under
disk read IO, it must be locked. invalidate_inode_pages2() need wait until
end bio handler to unlocked it.

Reported-and-Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0c31d07..d8fd711 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2728,13 +2728,13 @@ fail_cleaner:
 	 * kthreads
 	 */
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_block_groups:
 	btrfs_free_block_groups(fs_info);
 
 fail_tree_roots:
 	free_root_pointers(fs_info, 1);
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->generic_worker);
@@ -2755,7 +2755,6 @@ fail_alloc:
 fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	iput(fs_info->btree_inode);
 fail_bdi:
 	bdi_destroy(&fs_info->bdi);
-- 
1.7.11.7
