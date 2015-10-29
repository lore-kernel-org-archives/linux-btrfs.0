Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43658 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193AbbJ2J3D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:29:03 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9SIp2005260
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:28:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Fix a data space underflow warning
Date: Thu, 29 Oct 2015 17:28:46 +0800
Message-Id: <1446110926-3187-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even with quota disabled, generic/127 will trigger a kernel warning by
underflow data space info.

The bug is caused by buffered write, which in case of short copy, the
start parameter for btrfs_delalloc_release_space() is wrong, and
round_up/down() in btrfs_delalloc_release() extents the range to page
aligned, decreasing one more page than expected.

This patch will fix it by passing correct start.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index dce93dc..933a723 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1607,12 +1607,17 @@ again:
 				BTRFS_I(inode)->outstanding_extents++;
 				spin_unlock(&BTRFS_I(inode)->lock);
 			}
-			if (only_release_metadata)
+			if (only_release_metadata) {
 				btrfs_delalloc_release_metadata(inode,
 								release_bytes);
-			else
-				btrfs_delalloc_release_space(inode, pos,
+			} else {
+				u64 __pos;
+
+				__pos = round_down(pos, root->sectorsize) +
+					(dirty_pages << PAGE_CACHE_SHIFT);
+				btrfs_delalloc_release_space(inode, __pos,
 							     release_bytes);
+			}
 		}
 
 		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
-- 
2.6.2

