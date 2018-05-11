Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbeEKQAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 12:00:35 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D65CACF9
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:00:34 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use kvzalloc for EXTENT_SAME temporary data
Date: Fri, 11 May 2018 17:57:54 +0200
Message-Id: <20180511155754.27084-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dedupe range is 16 MiB, with 4KiB pages and 8 byte pointers, the
arrays can be 32KiB large. To avoid allocation failures due to
fragmented memory, use the allocation with fallback to vmalloc.

Signed-off-by: David Sterba <dsterba@suse.com>
---

This depends on the patches that remove the 16MiB restriction in the
dedupe ioctl, but contextually can be applied to the current code too.

https://patchwork.kernel.org/patch/10374941/

 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b572e38b4b64..a7f517009cd7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3178,8 +3178,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	 * locking. We use an array for the page pointers. Size of the array is
 	 * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
 	 */
-	cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
-	cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	cmp.src_pages = kvzalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	cmp.dst_pages = kvzalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!cmp.src_pages || !cmp.dst_pages) {
 		kfree(cmp.src_pages);
 		kfree(cmp.dst_pages);
-- 
2.16.2

