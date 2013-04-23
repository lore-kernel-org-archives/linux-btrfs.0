Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:45338 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3DWQ64 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 12:58:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D183A7C0447
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 10:58:54 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id JhZctuyrQP2MfpSL (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2013 10:58:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: only exclude supers in the range of our block group
Date: Tue, 23 Apr 2013 12:58:52 -0400
Message-ID: <1366736332-1808-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fail to load block groups halfway through we can leave extent_state's on
the excluded tree.  This is because we just lookup the supers and add them to
the excluded tree regardless of which block group we are looking at currently.
This is a problem because we remove the excluded extents for the range of the
block group only, so if we don't ever load a block group for one of the excluded
extents we won't ever free it.  This fixes the problem by only adding excluded
extents if it falls in the block group range we care about.  With this patch
we're no longer leaking space when we fail to read all of the block groups.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b441be3..10a980c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -270,9 +270,26 @@ static int exclude_super_stripes(struct btrfs_root *root,
 			return ret;
 
 		while (nr--) {
-			cache->bytes_super += stripe_len;
-			ret = add_excluded_extent(root, logical[nr],
-						  stripe_len);
+			u64 start, len;
+
+			if (logical[nr] > cache->key.objectid)
+				continue;
+
+			if (logical[nr] + stripe_len <= cache->key.objectid)
+				continue;
+
+			start = logical[nr];
+			if (start < cache->key.objectid) {
+				start = cache->key.objectid;
+				len = (logical[nr] + stripe_len) - start;
+			} else {
+				len = min_t(u64, stripe_len,
+					    cache->key.objectid +
+					    cache->key.offset - start);
+			}
+
+			cache->bytes_super += len;
+			ret = add_excluded_extent(root, start, len);
 			if (ret) {
 				kfree(logical);
 				return ret;
-- 
1.7.7.6

