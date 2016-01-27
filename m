Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52755 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934408AbcA0T3s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 14:29:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 705A9201ED
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 19:29:47 +0000 (UTC)
Received: from debian3.lan (bl8-199-62.dsl.telepac.pt [85.241.199.62])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 16B1520251
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 19:29:45 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix page reading in extent_same ioctl leading to csum errors
Date: Wed, 27 Jan 2016 19:29:40 +0000
Message-Id: <1453922980-2253-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

In the extent_same ioctl, we were grabbing the pages (locked) and
attempting to read them without bothering about any concurrent IO
against them. That is, we were not checking for any ongoing ordered
extents nor waiting for them to complete, which leads to a race where
the extent_same() code gets a checksum verification error when it
reads the pages, producing a message like the following in dmesg
and making the operation fail to user space with -ENOMEM:

[18990.161265] BTRFS warning (device sdc): csum failed ino 259 off 495616 csum 685204116 expected csum 1515870868

Fix this by using btrfs_readpage() for reading the pages instead of
extent_read_full_page_nolock(), which waits for any concurrent ordered
extents to complete and locks the io range. Also do better error handling
and don't treat all failures as -ENOMEM, as that's clearly misleasing,
becoming identical to the checks and operation of prepare_uptodate_page().

The use of extent_read_full_page_nolock() was required before
commit f441460202cb ("btrfs: fix deadlock with extent-same and readpage"),
as we had the range locked in an inode's io tree before attempting to
read the pages.

Fixes: f441460202cb ("btrfs: fix deadlock with extent-same and readpage")
Cc: stable@vger.kernel.org   # 4.2+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dd39546..d3784e9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2790,21 +2790,27 @@ out:
 static struct page *extent_same_get_page(struct inode *inode, pgoff_t index)
 {
 	struct page *page;
-	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 
 	page = grab_cache_page(inode->i_mapping, index);
 	if (!page)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (!PageUptodate(page)) {
-		if (extent_read_full_page_nolock(tree, page, btrfs_get_extent,
-						 0))
-			return NULL;
+		int ret;
+
+		ret = btrfs_readpage(NULL, page);
+		if (ret)
+			return ERR_PTR(ret);
 		lock_page(page);
 		if (!PageUptodate(page)) {
 			unlock_page(page);
 			page_cache_release(page);
-			return NULL;
+			return ERR_PTR(-EIO);
+		}
+		if (page->mapping != inode->i_mapping) {
+			unlock_page(page);
+			page_cache_release(page);
+			return ERR_PTR(-EAGAIN);
 		}
 	}
 
@@ -2818,9 +2824,16 @@ static int gather_extent_pages(struct inode *inode, struct page **pages,
 	pgoff_t index = off >> PAGE_CACHE_SHIFT;
 
 	for (i = 0; i < num_pages; i++) {
+again:
 		pages[i] = extent_same_get_page(inode, index + i);
-		if (!pages[i])
-			return -ENOMEM;
+		if (IS_ERR(pages[i])) {
+			int err = PTR_ERR(pages[i]);
+
+			if (err == -EAGAIN)
+				goto again;
+			pages[i] = NULL;
+			return err;
+		}
 	}
 	return 0;
 }
-- 
2.7.0.rc3

