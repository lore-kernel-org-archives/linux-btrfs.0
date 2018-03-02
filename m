Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49021 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753316AbeCBFXG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Mar 2018 00:23:06 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/5] btrfs: Parse options after node/sector size initialized
Date: Fri,  2 Mar 2018 13:22:50 +0800
Message-Id: <20180302052254.7059-2-wqu@suse.com>
In-Reply-To: <20180302052254.7059-1-wqu@suse.com>
References: <20180302052254.7059-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This provides the basis for later max_inline enhancement, which needs to
access fs_info->nodesize.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8ecccfc36de..f7f985ed5af9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2644,12 +2644,6 @@ int open_ctree(struct super_block *sb,
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
-	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
-	if (ret) {
-		err = ret;
-		goto fail_alloc;
-	}
-
 	features = btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
@@ -2692,6 +2686,13 @@ int open_ctree(struct super_block *sb,
 	fs_info->sectorsize = sectorsize;
 	fs_info->stripesize = stripesize;
 
+	/* Only parse options after node/sector size initialized */
+	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
+	if (ret) {
+		err = ret;
+		goto fail_alloc;
+	}
+
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions
-- 
2.16.2

