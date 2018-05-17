Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751930AbeEQPn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 11:43:56 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com, nefelim4ag@gmail.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: use kvzalloc for EXTENT_SAME temporary data
Date: Thu, 17 May 2018 17:41:10 +0200
Message-Id: <20180517154110.29362-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dedupe range is 16 MiB, with 4 KiB pages and 8 byte pointers, the
arrays can be 32KiB large. To avoid allocation failures due to
fragmented memory, use the allocation with fallback to vmalloc.

The arrays are allocated and freed only inside btrfs_extent_same and
reused for all the ranges.

Signed-off-by: David Sterba <dsterba@suse.com>
---

Based on git://github.com/kdave/btrfs-devel.git ext/timofey/dedupe-16mb-limit

v2:
- use kvmalloc_array
- use __GFP_ZERO, as there's no kvzalloc_array
- check that there are no other frees missed,
  see https://patchwork.kernel.org/patch/10374941/ for reference

 fs/btrfs/ioctl.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b572e38b4b64..20751829104d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3178,12 +3178,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	 * locking. We use an array for the page pointers. Size of the array is
 	 * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
 	 */
-	cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
-	cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	cmp.src_pages = kvmalloc_array(num_pages, sizeof(struct page *),
+				       GFP_KERNEL | __GFP_ZERO);
+	cmp.dst_pages = kvmalloc_array(num_pages, sizeof(struct page *),
+				       GFP_KERNEL | __GFP_ZERO);
 	if (!cmp.src_pages || !cmp.dst_pages) {
-		kfree(cmp.src_pages);
-		kfree(cmp.dst_pages);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free;
 	}
 
 	if (same_inode)
@@ -3211,8 +3212,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	else
 		btrfs_double_inode_unlock(src, dst);
 
-	kfree(cmp.src_pages);
-	kfree(cmp.dst_pages);
+out_free:
+	kvfree(cmp.src_pages);
+	kvfree(cmp.dst_pages);
 
 	return ret;
 }
-- 
2.16.2

