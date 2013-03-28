Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47271 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755599Ab3C1ILL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 04:11:11 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r2S8BA8t022060
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 16:11:10 +0800
Message-ID: <5153FB5F.3060400@cn.fujitsu.com>
Date: Thu, 28 Mar 2013 16:12:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] Btrfs: fix wrong return value of btrfs_lookup_csum()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we don't find the expected csum item, but find a csum item which is
adjacent to the specified extent, we should return -EFBIG, or we should
return -ENOENT. But btrfs_lookup_csum() return -EFBIG even the csum item
is not adjacent to the specified extent. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file-item.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9a447bc..bc89e2f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -117,9 +117,11 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 		csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
 		csums_in_item /= csum_size;
 
-		if (csum_offset >= csums_in_item) {
+		if (csum_offset == csums_in_item) {
 			ret = -EFBIG;
 			goto fail;
+		} else if (csum_offset > csums_in_item) {
+			goto fail;
 		}
 	}
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
-- 
1.8.0.1
