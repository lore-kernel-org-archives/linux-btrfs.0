Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44225 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756206AbeAJObG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 09:31:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D046AADF9
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 14:31:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: tree-check: reduce stack consumption in check_dir_item
Date: Wed, 10 Jan 2018 15:28:51 +0100
Message-Id: <20180110142851.27624-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've noticed that the updated item checker stack consumption increased
dramatically in 542f5385e20cf97447 ("btrfs: tree-checker: Add checker
for dir item")

tree-checker.c:check_leaf                    +552 (176 -> 728)

The array is 255 bytes long, dynamic allocation would slow down the
sanity checks so it's more reasonable to keep it on-stack. Moving the
variable to the scope of use reduces the stack usage again

tree-checker.c:check_leaf                    -264 (728 -> 464)

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-checker.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 7c55e3ba5a6c..c3c8d48f6618 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -259,7 +259,6 @@ static int check_dir_item(struct btrfs_root *root,
 
 	di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 	while (cur < item_size) {
-		char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 		u32 name_len;
 		u32 data_len;
 		u32 max_name_len;
@@ -342,6 +341,8 @@ static int check_dir_item(struct btrfs_root *root,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
+			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
 			name_hash = btrfs_name_hash(namebuf, name_len);
-- 
2.15.1

