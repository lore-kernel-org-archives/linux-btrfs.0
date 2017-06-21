Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20491 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751148AbdFUJ3E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 05:29:04 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <kilobyte@angband.pl>
Subject: [PATCH] btrfs: DEBUG fiemap: Show more info about extent_fiemap
Date: Wed, 21 Jun 2017 17:28:50 +0800
Message-ID: <20170621092850.18394-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Adam,

Would you please try this patch based on v4.12-rc5 and try to reproduce
the kernel warning?

It would be better to eliminate the noisy by ensure there is no other fiemap
caller on btrfs.

Thanks,
Qu

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d3619e0..ebebfb0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4406,6 +4406,8 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 {
 	int ret = 0;
 
+	pr_info("%s: entered: offset=%llu phys=%llu len=%llu flags=0x%x\n",
+		__func__, offset, phys, len, flags);
 	if (!cache->cached)
 		goto assign;
 
@@ -4417,7 +4419,7 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 	 * NOTE: Physical address can overlap, due to compression
 	 */
 	if (cache->offset + cache->len > offset) {
-		WARN_ON(1);
+		pr_info("%s: Sanity check failed\n", __func__);
 		return -EINVAL;
 	}
 
@@ -4438,16 +4440,23 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 			(flags & ~FIEMAP_EXTENT_LAST)) {
 		cache->len += len;
 		cache->flags |= flags;
+		pr_info("%s: merged, new offset=%llu len=%llu flags=0x%x\n", __func__,
+			cache->offset, cache->len, cache->flags);
 		goto try_submit_last;
 	}
 
+	pr_info("%s: submit cached fiemap: offset=%llu len=%llu flags=0x%x\n",
+		__func__, cache->offset, cache->len, cache->flags);
 	/* Not mergeable, need to submit cached one */
 	ret = fiemap_fill_next_extent(fieinfo, cache->offset, cache->phys,
 				      cache->len, cache->flags);
 	cache->cached = false;
-	if (ret)
+	if (ret) {
+		pr_info("%s: cached submit exit ret=%d\n", __func__, ret);
 		return ret;
+	}
 assign:
+	pr_info("%s: assigning new fiemap\n", __func__);
 	cache->cached = true;
 	cache->offset = offset;
 	cache->phys = phys;
@@ -4455,10 +4464,13 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
 	cache->flags = flags;
 try_submit_last:
 	if (cache->flags & FIEMAP_EXTENT_LAST) {
+		pr_info("%s: submit last fiemap: offset=%llu len=%llu flags=0x%x\n",
+			__func__, cache->offset, cache->len, cache->flags);
 		ret = fiemap_fill_next_extent(fieinfo, cache->offset,
 				cache->phys, cache->len, cache->flags);
 		cache->cached = false;
 	}
+	pr_info("%s: last exit ret=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -4525,6 +4537,9 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	pr_info("%s: enter: root=%llu inode=%llu start=%llu len=%llu\n",
+		__func__, root->objectid, btrfs_ino(BTRFS_I(inode)),
+		start, len);
 	start = round_down(start, btrfs_inode_sectorsize(inode));
 	len = round_up(max, btrfs_inode_sectorsize(inode)) - start;
 
@@ -4696,6 +4711,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (ret) {
 			if (ret == 1)
 				ret = 0;
+			pr_info("%s: out_free after emit_fiemap_extent\n", __func__);
 			goto out_free;
 		}
 	}
@@ -4707,6 +4723,9 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	btrfs_free_path(path);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len - 1,
 			     &cached_state, GFP_NOFS);
+	pr_info("%s: exit: ret=%d root=%llu inode=%llu start=%llu len=%llu\n",
+		__func__, ret, root->objectid, btrfs_ino(BTRFS_I(inode)),
+		start, len);
 	return ret;
 }
 
-- 
2.9.3



