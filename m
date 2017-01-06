Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45655 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935111AbdAFMrW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Jan 2017 07:47:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 16993AAC8
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Jan 2017 12:45:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove unused logic of limiting async delalloc pages
Date: Fri,  6 Jan 2017 13:45:30 +0100
Message-Id: <20170106124530.13909-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A proposed patch in https://marc.info/?l=linux-btrfs&m=147859791003837
pointed out bad limit threshold in cow_file_range_async, but it turned
out that the whole logic is not necessary and is done by writeback. We
agreed to remove it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a713d9d324b0..3d9649fddb0f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1164,7 +1164,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	unsigned long nr_pages;
 	u64 cur_end;
-	int limit = 10 * SZ_1M;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL, GFP_NOFS);
@@ -1196,12 +1195,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 
 		btrfs_queue_work(fs_info->delalloc_workers, &async_cow->work);
 
-		if (atomic_read(&fs_info->async_delalloc_pages) > limit) {
-			wait_event(fs_info->async_submit_wait,
-				   (atomic_read(&fs_info->async_delalloc_pages) <
-				    limit));
-		}
-
 		while (atomic_read(&fs_info->async_submit_draining) &&
 		       atomic_read(&fs_info->async_delalloc_pages)) {
 			wait_event(fs_info->async_submit_wait,
-- 
2.10.1

