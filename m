Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753981AbdA3TzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 14:55:04 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 325A0202AE
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 19:55:03 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB864201B4
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 19:55:01 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: bulk delete checksum items in the same leaf
Date: Sat, 28 Jan 2017 06:06:32 +0000
Message-Id: <1485583592-25555-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Very often we have the checksums for an extent spread in multiple items
in the checksums tree, and currently the algorithm to delete them starts
by looking for them one by one and then deleting them one by one, which
is not optimal since each deletion involves shifting all the other items
in the leaf and when the leaf reaches some low threshold, to move items
off the leaf into its left and right neighbor leafs. Also, after each
item deletion we release our search path and start a new search for other
checksums items.

So optimize this by deleting in bulk all the items in the same leaf that
contain checksums for the extent being freed.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file-item.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index e97e322..d7d6d4a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -643,7 +643,33 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 
 		/* delete the entire item, it is inside our range */
 		if (key.offset >= bytenr && csum_end <= end_byte) {
-			ret = btrfs_del_item(trans, root, path);
+			int del_nr = 1;
+
+			/*
+			 * Check how many csum items preceding this one in this
+			 * leaf correspond to our range and then delete them all
+			 * at once.
+			 */
+			if (key.offset > bytenr && path->slots[0] > 0) {
+				int slot = path->slots[0] - 1;
+
+				while (slot >= 0) {
+					struct btrfs_key pk;
+
+					btrfs_item_key_to_cpu(leaf, &pk, slot);
+					if (pk.offset < bytenr ||
+					    pk.type != BTRFS_EXTENT_CSUM_KEY ||
+					    pk.objectid !=
+					    BTRFS_EXTENT_CSUM_OBJECTID)
+						break;
+					path->slots[0] = slot;
+					del_nr++;
+					key.offset = pk.offset;
+					slot--;
+				}
+			}
+			ret = btrfs_del_items(trans, root, path,
+					      path->slots[0], del_nr);
 			if (ret)
 				goto out;
 			if (key.offset == bytenr)
-- 
2.7.0.rc3

