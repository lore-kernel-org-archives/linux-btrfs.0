Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755276AbdBQTQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 14:16:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id C9FB320123
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 19:16:10 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B42C201FE
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 19:16:09 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unnecessary constraint when splitting a leaf
Date: Fri, 17 Feb 2017 19:16:04 +0000
Message-Id: <1487358964-9758-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we want to append an item to a leaf we were trying to move off from the
leaf into its neighbors an amount of space corresponding to the item's
size. That amount of space is too much and can be reduced to the item's
size minus the amount of free space in the leaf, like we do for all the
other cases (item inserted at the beginning or somewhere in the middle of
the leaf).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a426dc8..86be619 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4130,11 +4130,11 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 	int progress = 0;
 	int slot;
 	u32 nritems;
-	int space_needed = data_size;
+	int space_needed;
 
 	slot = path->slots[0];
-	if (slot < btrfs_header_nritems(path->nodes[0]))
-		space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
+	space_needed = data_size -
+		btrfs_leaf_free_space(fs_info, path->nodes[0]);
 
 	/*
 	 * try to push all the items after our slot into the
@@ -4205,11 +4205,9 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 
 	/* first try to make some room by pushing left and right */
 	if (data_size && path->nodes[1]) {
-		int space_needed = data_size;
-
-		if (slot < btrfs_header_nritems(l))
-			space_needed -= btrfs_leaf_free_space(fs_info, l);
+		int space_needed;
 
+		space_needed = data_size - btrfs_leaf_free_space(fs_info, l);
 		wret = push_leaf_right(trans, root, path, space_needed,
 				       space_needed, 0, 0);
 		if (wret < 0)
-- 
2.7.0.rc3

