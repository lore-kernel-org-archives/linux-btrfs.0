From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix data space leak fix
Date: Thu, 1 Oct 2009 17:18:11 -0400
Message-ID: <20091001211811.GF4350@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is a problem where page_mkwrite can be called on a dirtied page that
already has a delalloc range associated with it.  The fix is to clear any
delalloc bits for the range we are dirtying so the space accounting gets handled
properly.  This is the same thing we do in the normal write case, so we are
consistent across the board.  With this patch we no longer leak reserved space.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/inode.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c22075d..1010979 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4666,10 +4666,21 @@ again:
 		goto again;
 	}
 
+	/*
+	 * XXX - page_mkwrite gets called every time the page is dirtied, even
+	 * if it was already dirty, so for space accounting reasons we need to
+	 * clear any delalloc bits for the range we are fixing to save.  There
+	 * is probably a better way to do this, but for now keep consistent with
+	 * prepare_pages in the normal write path.
+	 */
+	clear_extent_bits(&BTRFS_I(inode)->io_tree, page_start, page_end,
+			  EXTENT_DIRTY | EXTENT_DELALLOC, GFP_NOFS);
+
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
 	if (ret) {
 		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
 		ret = VM_FAULT_SIGBUS;
+		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
 		goto out_unlock;
 	}
 	ret = 0;
-- 
1.5.4.3

