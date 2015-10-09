Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:24293 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754915AbbJIChY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:37:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992aWqt023982
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:36:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 22/23] btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode size
Date: Fri, 9 Oct 2015 10:34:54 +0800
Message-ID: <1444358095-3575-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v2:
  Newly introduced
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d638d34..ad30b37 100644
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

