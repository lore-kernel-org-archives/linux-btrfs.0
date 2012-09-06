Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42730 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2IFGlI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 02:41:08 -0400
Message-ID: <5048457E.6050002@gmail.com>
Date: Thu, 06 Sep 2012 14:41:02 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] btrfs: remove unnecessary -ENOMEM BUG_ON check in extent-tree.c/btrfs_alloc_logged_file_extent
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The memory allocation failure is BUG_ON in add_excluded_extent
(following the code path). No need to BUG_ON -ENOMEM inside
btrfs_alloc_logged_file_extent.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent-tree.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 95492cc..9b9a6fa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6207,8 +6207,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 		mutex_lock(&caching_ctl->mutex);
 
 		if (start >= caching_ctl->progress) {
-			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret); /* -ENOMEM */
+			add_excluded_extent(root, start, num_bytes);
 		} else if (start + num_bytes <= caching_ctl->progress) {
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
@@ -6222,8 +6221,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 			start = caching_ctl->progress;
 			num_bytes = ins->objectid + ins->offset -
 				    caching_ctl->progress;
-			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret); /* -ENOMEM */
+			add_excluded_extent(root, start, num_bytes);
 		}
 
 		mutex_unlock(&caching_ctl->mutex);
-- 
1.7.1

