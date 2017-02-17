Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35089 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934530AbdBQOoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:10 -0500
Received: by mail-wr0-f194.google.com with SMTP id q39so5487299wrb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:09 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 22/38] btrfs: Make lock_and_cleanup_extent_if_need take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:13 +0200
Message-Id: <1487342609-20652-23-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8e223c78c8fe..2d534d6c5514 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1415,13 +1415,13 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
  * the other < 0 number - Something wrong happens
  */
 static noinline int
-lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
+lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 				size_t num_pages, loff_t pos,
 				size_t write_bytes,
 				u64 *lockstart, u64 *lockend,
 				struct extent_state **cached_state)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	u64 start_pos;
 	u64 last_pos;
 	int i;
@@ -1432,30 +1432,29 @@ lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 		+ round_up(pos + write_bytes - start_pos,
 			   fs_info->sectorsize) - 1;
 
-	if (start_pos < inode->i_size) {
+	if (start_pos < inode->vfs_inode.i_size) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent_bits(&BTRFS_I(inode)->io_tree,
-				 start_pos, last_pos, cached_state);
-		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start_pos,
+		lock_extent_bits(&inode->io_tree, start_pos, last_pos, 
+				cached_state);
+		ordered = btrfs_lookup_ordered_range(inode, start_pos,
 						     last_pos - start_pos + 1);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > start_pos &&
 		    ordered->file_offset <= last_pos) {
-			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     start_pos, last_pos,
+			unlock_extent_cached(&inode->io_tree, start_pos, last_pos,
 					     cached_state, GFP_NOFS);
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				put_page(pages[i]);
 			}
-			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_start_ordered_extent(&inode->vfs_inode, ordered, 1);
 			btrfs_put_ordered_extent(ordered);
 			return -EAGAIN;
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
+		clear_extent_bit(&inode->io_tree, start_pos,
 				  last_pos, EXTENT_DIRTY | EXTENT_DELALLOC |
 				  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 				  0, 0, cached_state, GFP_NOFS);
@@ -1623,7 +1622,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (ret)
 			break;
 
-		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
+		ret = lock_and_cleanup_extent_if_need(BTRFS_I(inode), pages, num_pages,
 						pos, write_bytes, &lockstart,
 						&lockend, &cached_state);
 		if (ret < 0) {
-- 
2.7.4

