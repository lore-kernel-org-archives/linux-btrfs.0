Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752513AbdBTN4b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 08:56:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id E086720103
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 13:56:29 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E074200E9
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 13:56:28 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: try harder to migrate items to left sibling before splitting a leaf
Date: Sun, 19 Feb 2017 20:56:39 +0000
Message-Id: <1487537799-17570-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Before attempting to split a leaf we try to migrate items from the leaf to
its right and left siblings. We start by trying to move items into the
rigth sibling and, if the new item is meant to be inserted at the end of
our leaf, we try to free from our leaf an amount of bytes equal to the
number of bytes used by the new item, by setting the variable space_needed
to the byte size of that new item. However if we fail to move enough items
to the right sibling due to lack of space in that sibling, we then try
to move items into the left sibling, and in that case we try to free
an amount equal to the size of the new item from our leaf, when we need
only to free an amount corresponding to the size of the new item minus
the current free space of our leaf. So make sure that before we try to
move items to the left sibling we do set the variable space_needed with
a value corresponding to the new item's size minus the leaf's current
free space.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a426dc8..1d66761 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4160,6 +4160,9 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 
 	/* try to push all the items before our slot into the next leaf */
 	slot = path->slots[0];
+	space_needed = data_size;
+	if (slot > 0)
+		space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
 	ret = push_leaf_left(trans, root, path, 1, space_needed, 0, slot);
 	if (ret < 0)
 		return ret;
@@ -4215,6 +4218,10 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 		if (wret < 0)
 			return wret;
 		if (wret) {
+			space_needed = data_size;
+			if (slot > 0)
+				space_needed -= btrfs_leaf_free_space(fs_info,
+								      l);
 			wret = push_leaf_left(trans, root, path, space_needed,
 					      space_needed, 0, (u32)-1);
 			if (wret < 0)
-- 
2.7.0.rc3

