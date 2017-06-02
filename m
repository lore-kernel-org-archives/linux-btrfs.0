Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.univention.de ([82.198.197.8]:20406 "EHLO
        mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFBKIp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 06:08:45 -0400
From: Philipp Hahn <hahn@univention.de>
To: linux-btrfs@vger.kernel.org
Cc: Philipp Hahn <hahn@univention.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: Check slot + nr >= nritems overflow
Date: Fri,  2 Jun 2017 12:08:13 +0200
Message-Id: <13fac9182fb83ed66c281b0867490aaa5928da20.1496397503.git.hahn@univention.de>
In-Reply-To: <cover.1496397503.git.hahn@univention.de>
References: <cover.1496397503.git.hahn@univention.de>
In-Reply-To: <cover.1496397503.git.hahn@univention.de>
References: <20170529181900.GV14523@twin.jikos.cz> <cover.1496397503.git.hahn@univention.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

711a0b48683b71d61caffbd67a90ec8db5412675 is incomplete and missed the
case in btrfs_del_ptr(), where multiple items are removed.

> Running "btrfsck --repair /dev/sdd2" crashed as it can happen in
> (corrupted) file systems, that slot > nritems.
> ...
> in that case the count of remaining items (nritems - slot - nr) gets
> negative. That is then casted to (unsigned long len), which leads to the
> observed crash.

Change the tests before the move to handle only the non-corrupted case,
were slot + nr < nritems.

This does not fix the corruption, but allows btrfsck to finish without
crashing.

Signed-off-by: Philipp Hahn <hahn@univention.de>
---
 ctree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ctree.c b/ctree.c
index 798bde9..201f671 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2656,7 +2656,7 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 }
 
 /*
- * delete the item at the leaf level in path.  If that empties
+ * delete 'nr' items at the leaf level in path.  If that empties
  * the leaf, remove it from the tree
  */
 int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -2679,7 +2679,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(leaf);
 
-	if (slot + nr != nritems) {
+	if (slot + nr < nritems) {
 		int data_end = leaf_data_end(root, leaf);
 
 		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
-- 
2.11.0

