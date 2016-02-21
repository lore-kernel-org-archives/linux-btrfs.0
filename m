Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34792 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbcBUBbY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 20:31:24 -0500
From: Simon Quigley <tsimonq2@ubuntu.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Quigley <tsimonq2@ubuntu.com>
Subject: [PATCH 2/3] btrfs: backref: Fixed string formatting error
Date: Sat, 20 Feb 2016 19:31:13 -0600
Message-Id: <1456018274-7847-2-git-send-email-tsimonq2@ubuntu.com>
In-Reply-To: <1456018274-7847-1-git-send-email-tsimonq2@ubuntu.com>
References: <1456018274-7847-1-git-send-email-tsimonq2@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Checkpatch reported an error that there was a multi-line string.

This puts the string on one line and the variables on another.

Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
---
 fs/btrfs/backref.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a2c0595..632845a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1696,9 +1696,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 			break;
 		ULIST_ITER_INIT(&root_uiter);
 		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
-			pr_debug("root %llu references leaf %llu, data list "
-				 "%#llx\n", root_node->val, ref_node->val,
-				 ref_node->aux);
+			pr_debug("root %llu references leaf %llu, data list %#llx\n",
+				root_node->val, ref_node->val, ref_node->aux);
 			ret = iterate_leaf_refs((struct extent_inode_elem *)
 						(uintptr_t)ref_node->aux,
 						root_node->val,
-- 
2.7.0

