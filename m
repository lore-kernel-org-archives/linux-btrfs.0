Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbcBKQ5U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:57:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 39784AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:57:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 8/9] btrfs: extent same: use GFP_KERNEL for page array allocations
Date: Thu, 11 Feb 2016 17:57:18 +0100
Message-Id: <fd95ef56b1acf96a24ff3d3f7bf19c2350ad0786.1455208920.git.dsterba@suse.com>
In-Reply-To: <cover.1455208920.git.dsterba@suse.com>
References: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can safely use GFP_KERNEL in the functions called from the ioctl
handlers. Here we can allocate up to 32k so less pressure to the
allocator could help.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 952172ca7e45..55440a742594 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2925,8 +2925,8 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
 	 * of the array is bounded by len, which is in turn bounded by
 	 * BTRFS_MAX_DEDUPE_LEN.
 	 */
-	src_pgarr = kzalloc(num_pages * sizeof(struct page *), GFP_NOFS);
-	dst_pgarr = kzalloc(num_pages * sizeof(struct page *), GFP_NOFS);
+	src_pgarr = kzalloc(num_pages * sizeof(struct page *), GFP_KERNEL);
+	dst_pgarr = kzalloc(num_pages * sizeof(struct page *), GFP_KERNEL);
 	if (!src_pgarr || !dst_pgarr) {
 		kfree(src_pgarr);
 		kfree(dst_pgarr);
-- 
2.7.1

