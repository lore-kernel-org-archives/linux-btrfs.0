Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2LEKxY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 05:53:24 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qB5ArP03019306
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Dec 2012 18:53:25 +0800
Message-ID: <50BF27B9.7030501@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 18:53:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] Btrfs: fix off-by-one error of the same page check in
 btrfs_punch_hole()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(start + len) is the start of the adjacent extent, not the end of the current
extent, so we should not use it to check the hole is on the same page or not.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index bd5afcc..b477da2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1881,8 +1881,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	unsigned long nr;
 	int ret = 0;
 	int err = 0;
-	bool same_page = (offset >> PAGE_CACHE_SHIFT) ==
-		((offset + len) >> PAGE_CACHE_SHIFT);
+	bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
+			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
 
 	btrfs_wait_ordered_range(inode, offset, len);
 
-- 
1.7.11.7
