Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46596 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaJFUOw (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 6 Oct 2014 16:14:52 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/5] Btrfs: fix hang on compressed write error
Date: Mon,  6 Oct 2014 22:14:23 +0100
Message-Id: <1412630066-21746-3-git-send-email-fdmanana@suse.com>
In-Reply-To: <1412630066-21746-1-git-send-email-fdmanana@suse.com>
References: <1412630066-21746-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In inode.c:submit_compressed_extents(), before calling btrfs_submit_compressed_write()
we start writeback for all pages, clear their dirty flag, unlock them, etc, but if
btrfs_submit_compressed_write() fails (at the moment it can only fail with -ENOMEM),
we never end the writeback on the pages, so any filemap_fdatawait_range() call will
hang forever. We were also not calling the writepage end io hook, which means the
corresponding ordered extent will never complete and all its waiters will block
forever, such as a full fsync (via btrfs_wait_ordered_range()).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cefa618..e2c4650 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -814,6 +814,20 @@ retry:
 				    ins.objectid,
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages);
+		if (ret) {
+			struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+			struct page *p = async_extent->pages[0];
+			const u64 start = async_extent->start;
+			const u64 end = start + async_extent->ram_size - 1;
+
+			p->mapping = inode->i_mapping;
+			tree->ops->writepage_end_io_hook(p, start, end,
+							 NULL, 0);
+			p->mapping = NULL;
+			extent_clear_unlock_delalloc(inode, start, end, NULL, 0,
+						     PAGE_END_WRITEBACK |
+						     PAGE_SET_ERROR);
+		}
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
 		if (ret)
-- 
1.9.1

