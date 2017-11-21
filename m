Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36675 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdKUHWG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 21 Nov 2017 02:22:06 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lists@colorremedies.com
Subject: [PATCH 2/2] btrfs: extent-tree: Ensure btrfs_trim_fs can trim the whole fs
Date: Tue, 21 Nov 2017 15:21:45 +0800
Message-Id: <20171121072145.24413-2-wqu@suse.com>
In-Reply-To: <20171121072145.24413-1-wqu@suse.com>
References: <20171121072145.24413-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
fstrim on some btrfs only trims the unallocated space, not trimming any
space in existing block groups.

[CAUSE]
fstrim_range passed in by default fstrim will be:

range->start = 0
range->len = fs_size (which equals with super->total_bytes)
range->min_len = 512

However btrfs_trim_fs() following above parameter to search block groups
to trim.

While it's quite possible that all chunks start beyond
super->total_bytes if the fs is balanced several times.

In that case, btrfs will skip trimming block groups and only trim the
unallocated space of each device.

[FIX]
For common full fs trimming range passed in, extent its len to (u64)-1
so we will iterate all block groups.

And for custom fs trimming range, due to the fact that the range will
always be truncated by range [0, super->total_bytes), making custom fs
trimming range useless.

Just return -ENOTTY for custom fs trimming range.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3a252d7af158..22bbcc8c4f6c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11024,12 +11024,31 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	int ret = 0;
 
 	/*
-	 * try to trim all FS space, our block group may start from non-zero.
+	 * NOTE: Btrfs uses its own logical address space, where its first
+	 * chunk can start anywhere if it wants.
+	 * If we follow common start = 0 and len = fs_size from @range, we
+	 * can end up without trimming any block groups, since it's highly
+	 * possible all chunks start beyond that range.
+	 *
+	 * So if we want to trim the whole fs, extent the len to (u64)-1 to trim
+	 * all block groups.
+	 *
+	 * Also, since @range will always be truncated to fs size, manually
+	 * passing range to trim specified range doesn't make much sense.
+	 * (No mean to trim any block group whose bytenr starts beyond
+	 *  @total_bytes)
+	 * So in that case, return -ENOTTY directly to prevent any custom trim
+	 * request.
 	 */
-	if (range->len == total_bytes)
-		cache = btrfs_lookup_first_block_group(fs_info, range->start);
-	else
-		cache = btrfs_lookup_block_group(fs_info, range->start);
+	if (range->start == 0 && range->len == total_bytes) {
+		range->len = (u64)-1;
+	} else {
+		btrfs_info(fs_info,
+		"trimming custom range is not supported due to the limitation of fstrim_range");
+		return -ENOTTY;
+	}
+
+	cache = btrfs_lookup_first_block_group(fs_info, range->start);
 
 	for (; cache; cache = next_block_group(fs_info, cache)) {
 		if (cache->key.objectid >= (range->start + range->len)) {
-- 
2.15.0

