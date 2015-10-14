Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13334 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752429AbbJNH2W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 03:28:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: [PATCH 2/2] btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode size
Date: Wed, 14 Oct 2015 15:26:13 +0800
Message-ID: <1444807573-29853-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code will always truncate tailing page if its alloc_start is
smaller than inode size.

For example, the file extent layout is like:
0	4K	8K	16K	32K
|<-----Extent A---------------->|
|<--Inode size: 18K---------->|

But if calling fallocate even for range [0,4K), it will cause btrfs to
re-truncate the range [16,32K), causing COW and a new extent.

0	4K	8K	16K	32K
|///////|	<- Fallocate call range
|<-----Extent A-------->|<--B-->|

The cause is quite easy, just a careless btrfs_truncate_inode() in a
else branch without extra judgment.
Fix it by add judgment on whether the fallocate range is beyond isize.

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
2.6.1

