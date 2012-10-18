Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49013 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2JRIRj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 04:17:39 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9I8HaQ1005670
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2012 16:17:36 +0800
Message-ID: <507FBB39.5090603@cn.fujitsu.com>
Date: Thu, 18 Oct 2012 16:18:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2] Btrfs: fix unnecessary while loop when search the free
 space, cache
References: <507FB7A6.70805@cn.fujitsu.com>
In-Reply-To: <507FB7A6.70805@cn.fujitsu.com>
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
Changelog v1 -> v2:
- fix the same problem in the other place
---
 fs/btrfs/free-space-cache.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1027b85..557502c 100644
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
@@ -1287,18 +1282,13 @@ tree_search_offset(struct btrfs_free_space_ctl *ctl,
 	}
 
 	if (entry->bitmap) {
-		n = &entry->offset_index;
-		while (1) {
-			n = rb_prev(n);
-			if (!n)
-				break;
+		n = rb_prev(&entry->offset_index);
+		if (n) {
 			prev = rb_entry(n, struct btrfs_free_space,
 					offset_index);
-			if (!prev->bitmap) {
-				if (prev->offset + prev->bytes > offset)
-					return prev;
-				break;
-			}
+			if (!prev->bitmap &&
+			    prev->offset + prev->bytes > offset)
+				return prev;
 		}
 		if (entry->offset + BITS_PER_BITMAP * ctl->unit > offset)
 			return entry;
-- 
1.7.6.5

