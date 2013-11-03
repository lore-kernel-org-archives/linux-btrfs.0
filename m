Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59721 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3KCRHT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 12:07:19 -0500
Received: by mail-ea0-f174.google.com with SMTP id z15so2955860ead.19
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Nov 2013 09:07:18 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 2/3] Btrfs: disable online raid-repair on ro mounts
Date: Sun,  3 Nov 2013 19:06:39 +0200
Message-Id: <1383498400-21009-2-git-send-email-idryomov@gmail.com>
In-Reply-To: <1383498400-21009-1-git-send-email-idryomov@gmail.com>
References: <1383498400-21009-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This disables the "if needed, write the good copy back before the read
is completed" part of the read sequence for read-only mounts.

Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent_io.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c09a40d..a0b7403 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1979,6 +1979,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	int ret;
 
+	ASSERT(!(fs_info->sb->s_flags & MS_RDONLY));
 	BUG_ON(!mirror_num);
 
 	/* we can't repair anything in raid56 yet */
@@ -2035,6 +2036,9 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 	unsigned long i, num_pages = num_extent_pages(eb->start, eb->len);
 	int ret = 0;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
 		ret = repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
@@ -2056,12 +2060,12 @@ static int clean_io_failure(u64 start, struct page *page)
 	u64 private;
 	u64 private_failure;
 	struct io_failure_record *failrec;
-	struct btrfs_fs_info *fs_info;
+	struct inode *inode = page->mapping->host;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
 	int did_repair = 0;
 	int ret;
-	struct inode *inode = page->mapping->host;
 
 	private = 0;
 	ret = count_range_bits(&BTRFS_I(inode)->io_failure_tree, &private,
@@ -2084,6 +2088,8 @@ static int clean_io_failure(u64 start, struct page *page)
 		did_repair = 1;
 		goto out;
 	}
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		goto out;
 
 	spin_lock(&BTRFS_I(inode)->io_tree.lock);
 	state = find_first_extent_bit_state(&BTRFS_I(inode)->io_tree,
@@ -2093,7 +2099,6 @@ static int clean_io_failure(u64 start, struct page *page)
 
 	if (state && state->start <= failrec->start &&
 	    state->end >= failrec->start + failrec->len - 1) {
-		fs_info = BTRFS_I(inode)->root->fs_info;
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-- 
1.7.10.4

