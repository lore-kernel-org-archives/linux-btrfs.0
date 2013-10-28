Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:57638 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3J1Q2m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 12:28:42 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so6913435wes.11
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 09:28:39 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix verification of dir_item
Date: Mon, 28 Oct 2013 16:28:30 +0000
Message-Id: <1382977710-1869-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were ignoring the name component of the dir_item. Both the
name and data must fit within BTRFS_MAX_XATTR_SIZE(root).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/dir-item.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 1c529db..c031ea3 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -474,8 +474,10 @@ int verify_dir_item(struct btrfs_root *root,
 	}
 
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
-	if (btrfs_dir_data_len(leaf, dir_item) > BTRFS_MAX_XATTR_SIZE(root)) {
-		printk(KERN_CRIT "btrfs: invalid dir item data len: %u\n",
+	if ((btrfs_dir_data_len(leaf, dir_item) +
+	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
+		printk(KERN_CRIT "btrfs: invalid dir item name + data len: %u + %u\n",
+		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
-- 
1.7.9.5

