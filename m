Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29730 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758835AbaGRBzo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 21:55:44 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6I1tedD014499
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 09:55:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Return right extent when fiemap gives unaligned offset and len.
Date: Fri, 18 Jul 2014 09:55:43 +0800
Message-ID: <1405648543-8966-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When page aligned start and len passed to extent_fiemap(), the result is
good, but when start and len is not aligned, e.g. start = 1 and len =
4095 is passed to extent_fiemap(), it returns no extent.

The problem is that start and len is all rounded down which causes the
problem. This patch will round down start and round up (start + len) to
return right extent.

Reported-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a389820..1c70cff 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4213,8 +4213,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
-	start = ALIGN(start, BTRFS_I(inode)->root->sectorsize);
-	len = ALIGN(len, BTRFS_I(inode)->root->sectorsize);
+	start = round_down(start, BTRFS_I(inode)->root->sectorsize);
+	len = round_up(max, BTRFS_I(inode)->root->sectorsize) - start;
 
 	/*
 	 * lookup the last file extent.  We're not using i_size here
-- 
2.0.1

