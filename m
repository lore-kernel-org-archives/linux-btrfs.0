Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57702 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557AbcEFQeS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 12:34:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F15322026F
	for <linux-btrfs@vger.kernel.org>; Fri,  6 May 2016 16:34:16 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id E33A92008F
	for <linux-btrfs@vger.kernel.org>; Fri,  6 May 2016 16:34:15 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix number of transaction units for renames with whiteout
Date: Thu,  5 May 2016 16:02:24 +0100
Message-Id: <1462460544-29178-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When we do a rename with the whiteout flag, we need to create the whiteout
inode, which in the worst case requires 5 transaction units (1 inode item,
1 inode ref, 2 dir items and 1 xattr if selinux is enabled). So bump the
number of transaction units from 11 to 16 if the whiteout flag is set.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dab6c08f..c8d30ef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9668,6 +9668,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			   unsigned int flags)
 {
 	struct btrfs_trans_handle *trans;
+	unsigned int trans_num_items;
 	struct btrfs_root *root = BTRFS_I(old_dir)->root;
 	struct btrfs_root *dest = BTRFS_I(new_dir)->root;
 	struct inode *new_inode = d_inode(new_dentry);
@@ -9730,8 +9731,14 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * would require 5 item modifications, so we'll assume they are normal
 	 * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total items
 	 * should cover the worst case number of items we'll modify.
+	 * If our rename has the whiteout flag, we need more 5 units for the
+	 * new inode (1 inode item, 1 inode ref, 2 dir items and 1 xattr item
+	 * when selinux is enabled).
 	 */
-	trans = btrfs_start_transaction(root, 11);
+	trans_num_items = 11;
+	if (flags & RENAME_WHITEOUT)
+		trans_num_items += 5;
+	trans = btrfs_start_transaction(root, trans_num_items);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_notrans;
-- 
2.7.0.rc3

