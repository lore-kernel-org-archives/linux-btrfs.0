Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbcBKQ5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:57:24 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7C877AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:57:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 9/9] btrfs: switch to kcalloc in btrfs_cmp_data_prepare
Date: Thu, 11 Feb 2016 17:57:22 +0100
Message-Id: <66722f7c059089ad7f11eaa3e27af2321ab1b0e6.1455208920.git.dsterba@suse.com>
In-Reply-To: <cover.1455208920.git.dsterba@suse.com>
References: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kcalloc is functionally equivalent and does overflow checks.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 55440a742594..11dae2a30eb5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2925,8 +2925,8 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
 	 * of the array is bounded by len, which is in turn bounded by
 	 * BTRFS_MAX_DEDUPE_LEN.
 	 */
-	src_pgarr = kzalloc(num_pages * sizeof(struct page *), GFP_KERNEL);
-	dst_pgarr = kzalloc(num_pages * sizeof(struct page *), GFP_KERNEL);
+	src_pgarr = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	dst_pgarr = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!src_pgarr || !dst_pgarr) {
 		kfree(src_pgarr);
 		kfree(dst_pgarr);
-- 
2.7.1

