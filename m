Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33369 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934506AbdBQOoF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:05 -0500
Received: by mail-wm0-f67.google.com with SMTP id v77so2936449wmv.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:04 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 17/38] btrfs: Make hole_mergeable take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:08 +0200
Message-Id: <1487342609-20652-18-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 37458605847a..53fedf3dcaef 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2193,7 +2193,7 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int hole_mergeable(struct inode *inode, struct extent_buffer *leaf,
+static int hole_mergeable(struct btrfs_inode *inode, struct extent_buffer *leaf,
 			  int slot, u64 start, u64 end)
 {
 	struct btrfs_file_extent_item *fi;
@@ -2203,7 +2203,7 @@ static int hole_mergeable(struct inode *inode, struct extent_buffer *leaf,
 		return 0;
 
 	btrfs_item_key_to_cpu(leaf, &key, slot);
-	if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
+	if (key.objectid != btrfs_ino(inode) ||
 	    key.type != BTRFS_EXTENT_DATA_KEY)
 		return 0;
 
@@ -2253,7 +2253,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 	}
 
 	leaf = path->nodes[0];
-	if (hole_mergeable(inode, leaf, path->slots[0]-1, offset, end)) {
+	if (hole_mergeable(BTRFS_I(inode), leaf, path->slots[0]-1, offset, end)) {
 		u64 num_bytes;
 
 		path->slots[0]--;
@@ -2268,7 +2268,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 		goto out;
 	}
 
-	if (hole_mergeable(inode, leaf, path->slots[0], offset, end)) {
+	if (hole_mergeable(BTRFS_I(inode), leaf, path->slots[0], offset, end)) {
 		u64 num_bytes;
 
 		key.offset = offset;
-- 
2.7.4

