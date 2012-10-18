Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab2JRICZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 04:02:25 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9I82LBx004801
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 16:02:22 +0800
Message-ID: <507FB7A6.70805@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 16:02:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix unnecessary while loop when search the free space
 cache
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we find a bitmap free space entry, we may check the previous extent
entry covers the offset or not. But if we find this entry is also a bitmap
entry, we will continue to check the previous entry of the current one by
a while loop. It is unnecessary because it is impossible that the extent
entry which is in front of a bitmap entry can cover the offset of the entry
after that bitmap entry.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1027b85..ac7e728 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1250,18 +1250,13 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 			 * if previous extent entry covers the offset,
 			 * we should return it instead of the bitmap entry
 			 */
-			n = &entry->offset_index;
-			while (1) {
-				n = rb_prev(n);
-				if (!n)
-					break;
+			n = rb_prev(&entry->offset_index);
+			if (n) {
 				prev = rb_entry(n, struct btrfs_free_space,
 						offset_index);
-				if (!prev->bitmap) {
-					if (prev->offset + prev->bytes > offset)
-						entry = prev;
-					break;
-				}
+				if (!prev->bitmap &&
+				    prev->offset + prev->bytes > offset)
+					entry = prev;
 			}
 		}
 		return entry;
-- 
1.7.6.5
