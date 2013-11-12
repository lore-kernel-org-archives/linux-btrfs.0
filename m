Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab3KLMAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 07:00:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rACBZil5009666
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 19:36:27 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: remove dead codes from ctree.h
Date: Tue, 12 Nov 2013 19:32:04 +0800
Message-Id: <1384255924-15851-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1384255924-15851-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1384255924-15851-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two functions are only stated but undefined.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7038acc..254209e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3614,9 +3614,6 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_ordered_sum *sums);
 int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		       struct bio *bio, u64 file_start, int contig);
-int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct btrfs_path *path,
-			u64 isize);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
 /* inode.c */
@@ -3745,9 +3742,6 @@ void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
 void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			     int skip_pinned);
-int btrfs_replace_extent_cache(struct inode *inode, struct extent_map *replace,
-			       u64 start, u64 end, int skip_pinned,
-			       int modified);
 extern const struct file_operations btrfs_file_operations;
 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, struct inode *inode,
-- 
1.8.3.1

