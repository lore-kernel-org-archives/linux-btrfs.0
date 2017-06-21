Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751143AbdFUQXs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 12:23:48 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: fix validation of XATTR_ITEM dir items
Date: Wed, 21 Jun 2017 17:46:24 +0200
Message-Id: <20170621154624.28365-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The XATTR_ITEM is a type of a directory item so we use the common
validator helper. We have to adjust the limits because of potential
data_len (ie. the xattr value), which is otherwise 0 for other directory
items.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dir-item.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 2b00dd746118..a48d496e63e4 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -498,6 +498,7 @@ bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_key key;
+	struct btrfs_dir_item *di;
 	u32 read_start;
 	u32 read_end;
 	u32 item_start;
@@ -515,8 +516,17 @@ bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
 	btrfs_item_key_to_cpu(leaf, &key, slot);
 
 	switch (key.type) {
-	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_XATTR_ITEM_KEY:
+		/*
+		 * XATTR_ITEM could contain data so the item_end would not
+		 * match read_end as for other item types. Artificially lower
+		 * the upper bound so we check just name_len. We have to trust
+		 * the data_len value here, but if it's too big the validation
+		 * fails so it's safer than increasing read_end.
+		 */
+		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
+		item_end -= btrfs_dir_data_len(leaf, di);
+	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_DIR_INDEX_KEY:
 		size = sizeof(struct btrfs_dir_item);
 		break;
-- 
2.13.0

