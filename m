Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64609 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932319AbbJMCUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 22:20:41 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9D2K1QJ012662
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 10:20:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 19/21] btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode size
Date: Tue, 13 Oct 2015 10:20:25 +0800
Message-Id: <1444702827-18169-20-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code will always truncate tailing page if its alloc_start is
smaller than inode size.

This behavior will cause a lot of unneeded COW page size extent.

This patch will avoid such problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced
v3:
  None
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 35bfabf..e59b123 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2640,7 +2640,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 					alloc_start);
 		if (ret)
 			goto out;
-	} else {
+	} else if (offset + len > inode->i_size) {
 		/*
 		 * If we are fallocating from the end of the file onward we
 		 * need to zero out the end of the page if i_size lands in the
-- 
2.6.1

