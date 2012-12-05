Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18444 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab2LEKyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 05:54:32 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qB5AsVdm019344
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Dec 2012 18:54:31 +0800
Message-ID: <50BF27FC.4080108@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 18:54:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6] Btrfs: punch hole past the end of the file
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we can pre-allocate the space past EOF, we should be able to reclaim
that space if we need. This patch implements it by removing the EOF check.

Though the manual of fallocate command says we can use truncate command to
reclaim the pre-allocated space which past EOF, but because truncate command
changes the file size, we must run several commands to reclaim the space if we
don't want to change the file size, so it is not a good choice.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e91c99b..321edc8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1887,26 +1887,28 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	btrfs_wait_ordered_range(inode, offset, len);
 
 	mutex_lock(&inode->i_mutex);
-	if (offset >= inode->i_size) {
-		mutex_unlock(&inode->i_mutex);
-		return 0;
-	}
-
+	/*
+	 * We needn't truncate any page which is beyond the end of the file
+	 * because we are sure there is no data there.
+	 */
 	/*
 	 * Only do this if we are in the same page and we aren't doing the
 	 * entire page.
 	 */
 	if (same_page && len < PAGE_CACHE_SIZE) {
-		ret = btrfs_truncate_page(inode, offset, len, 0);
+		if (offset < round_up(inode->i_size, PAGE_CACHE_SIZE))
+			ret = btrfs_truncate_page(inode, offset, len, 0);
 		mutex_unlock(&inode->i_mutex);
 		return ret;
 	}
 
 	/* zero back part of the first page */
-	ret = btrfs_truncate_page(inode, offset, 0, 0);
-	if (ret) {
-		mutex_unlock(&inode->i_mutex);
-		return ret;
+	if (offset < round_up(inode->i_size, PAGE_CACHE_SIZE)) {
+		ret = btrfs_truncate_page(inode, offset, 0, 0);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
 	}
 
 	/* zero the front end of the last page */
-- 
1.7.11.7
