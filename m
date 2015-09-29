Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3383 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933267AbbI2Ikr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 04:40:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8T8eMoi011519
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 16:40:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode size
Date: Tue, 29 Sep 2015 16:38:41 +0800
Message-ID: <1443515921-22569-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code will always truncate tailing page if its alloc_start is
smaller than inode size.

This behavior will cause a lot of unneeded COW page size extent.

This patch will avoid such problem.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..8c6f247 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2584,7 +2584,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 					alloc_start);
 		if (ret)
 			goto out;
-	} else {
+	} else if (offset + len > inode->i_size) {
 		/*
 		 * If we are fallocating from the end of the file onward we
 		 * need to zero out the end of the page if i_size lands in the
-- 
2.5.3

