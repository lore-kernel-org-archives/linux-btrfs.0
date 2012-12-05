Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab2LEKzs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 05:55:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qB5Atq63019387
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Dec 2012 18:55:52 +0800
Message-ID: <50BF284D.5090706@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 18:56:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] Btrfs: fix wrong return value of btrfs_truncate_page()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ret variant may be set to 0 if we read page successfully, but it might be
released before we lock it again. On this case, if we fail to allocate a
new page, we will return 0, it is wrong, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b08e4b1..bf17b4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3497,11 +3497,11 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 	if (ret)
 		goto out;
 
-	ret = -ENOMEM;
 again:
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
 		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -3550,7 +3550,6 @@ again:
 		goto out_unlock;
 	}
 
-	ret = 0;
 	if (offset != PAGE_CACHE_SIZE) {
 		if (!len)
 			len = PAGE_CACHE_SIZE - offset;
-- 
1.7.11.7
