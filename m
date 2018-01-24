Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48992 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbeAXCin (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 23 Jan 2018 21:38:43 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: mkfs: Fix minimal device size calculation for new temporary chunk layout
Date: Wed, 24 Jan 2018 10:38:29 +0800
Message-Id: <20180124023830.26184-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 0b2161becf8e ("btrfs-progs: mkfs: Prevent temporary system chunk
to use space in reserved 1M range") changed the hard-coded temporary
chunk layout to avoid the first 1M.

However this also affects btrfs_min_dev_size() which still assume
temporary chunks starts at device offset 0.

This patch will fix it.

Fixes: 0b2161becf8e ("btrfs-progs: mkfs: Prevent temporary system chunk
to use space in reserved 1M range")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index 5c5e9c3b9e01..8e85942ef4eb 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -483,6 +483,8 @@ u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
 
 	/*
 	 * Minimal size calculation is complex due to several factors:
+	 * 0) Reserved 1M range.
+	 *
 	 * 1) Temporary chunk reuse
 	 *    If specified chunk profile is SINGLE, we can reuse
 	 *    temporary chunks, no need to allocate new chunks.
@@ -501,7 +503,8 @@ u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
 	 * The latter two are all 8M, accroding to @calc_size of
 	 * btrfs_alloc_chunk().
 	 */
-	reserved += BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
+	reserved += BTRFS_BLOCK_RESERVED_1M_FOR_SUPER +
+		    BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
 
 	/*
 	 * For real chunks, we need to select different sizes:
-- 
2.15.1

