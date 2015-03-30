Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbbC3TMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 15:12:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 09804ABB1
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 19:12:38 +0000 (UTC)
Message-ID: <5519A022.9090804@suse.com>
Date: Mon, 30 Mar 2015 15:12:34 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: add missing discards when unpinning extents with,
 -o discard
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The block group removal patch adds an alternate path to forget extents
other than btrfs_finish_extent_commit. As a result, any extents that would
be freed when the block group is removed aren't discarded. In my
test run, with a large copy of mixed sized files followed by removal, it
left nearly 2/3 of extents undiscarded.

As part of the extent removal review, I also added the discard call to
btrfs_destroy_pinned_extent.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c     | 7 +++++++
 fs/btrfs/extent-tree.c | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 639f266..f7dfcf8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4167,6 +4167,13 @@ again:
 		if (ret)
 			break;
 
+		if (btrfs_test_opt(root, DISCARD)) {
+			ret = btrfs_discard_extent(root, start,
+						   end + 1 - start, NULL);
+			if (ret)
+				break;
+		}
+
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
 		btrfs_error_unpin_extent_range(root, start, end);
 		cond_resched();
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0bf45b8..6a7ff46 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9630,6 +9630,15 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		 * a BUG_ON() at btrfs_unpin_extent_range().
 		 */
 		mutex_lock(&fs_info->unused_bg_unpin_mutex);
+		if (btrfs_test_opt(root, DISCARD)) {
+			ret = btrfs_discard_extent(root, start, end + 1 - start,
+						   NULL);
+			if (ret) {
+				mutex_unlock(&fs_info->unused_bg_unpin_mutex);
+				btrfs_set_block_group_rw(root, block_group);
+				goto end_trans;
+			}
+		}
 		ret = clear_extent_bits(&fs_info->freed_extents[0], start, end,
 				  EXTENT_DIRTY, GFP_NOFS);
 		if (ret) {
-- 
1.8.5.6


-- 
Jeff Mahoney
SUSE Labs
