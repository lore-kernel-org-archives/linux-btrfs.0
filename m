Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60558 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbcEHNIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 09:08:39 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Sun,  8 May 2016 15:08:00 +0200
Message-Id: <1462712880-29392-1-git-send-email-kilobyte@angband.pl>
Subject: [PATCH] btrfs: fix int32 overflow in shrink_delalloc().
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

UBSAN: Undefined behaviour in fs/btrfs/extent-tree.c:4623:21
signed integer overflow:
10808 * 262144 cannot be represented in type 'int [8]'

If 8192<=items<16384, we request a writeback of an insane number of pages
which is benign (everything will be written).  But if items>=16384, the
space reservation won't be enough.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 84e060e..391f576 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4620,7 +4620,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 
 	/* Calc the number of the pages we need flush for space reservation */
 	items = calc_reclaim_items_nr(root, to_reclaim);
-	to_reclaim = items * EXTENT_SIZE_PER_ITEM;
+	to_reclaim = (u64)items * EXTENT_SIZE_PER_ITEM;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
-- 
2.8.1

