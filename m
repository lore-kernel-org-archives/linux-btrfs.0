Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbeH2JKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 05:10:47 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: Ensure btrfs_trim_fs can trim the whole fs
Date: Wed, 29 Aug 2018 13:15:32 +0800
Message-Id: <20180829051532.32005-3-wqu@suse.com>
In-Reply-To: <20180829051532.32005-1-wqu@suse.com>
References: <20180829051532.32005-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
fstrim on some btrfs only trims the unallocated space, not trimming any
space in existing block groups.

[CAUSE]
Before fstrim_range passed to btrfs_trim_fs(), it get truncated to
range [0, super->total_bytes).
So later btrfs_trim_fs() will only be able to trim block groups in range
[0, super->total_bytes).

While for btrfs, any bytenr aligned to sector size is valid, since btrfs use
its logical address space, there is nothing limiting the location where
we put block groups.

For btrfs with routine balance, it's quite easy to relocate all
block groups and bytenr of block groups will start beyond super->total_bytes.

In that case, btrfs will not trim existing block groups.

[FIX]
Just remove the truncation in btrfs_ioctl_fitrim(), so btrfs_trim_fs()
can get the unmodified range, which is normally set to [0, U64_MAX].

Reported-by: Chris Murphy <lists@colorremedies.com>
Fixes: f4c697e6406d ("btrfs: return EINVAL if start > total_bytes in fitrim ioctl")
Cc: <stable@vger.kernel.org> # v4.0+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 10 +---------
 fs/btrfs/ioctl.c       | 11 +++++++----
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7768f206196a..d1478d66c7a5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10851,21 +10851,13 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
-	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	u64 bg_failed = 0;
 	u64 dev_failed = 0;
 	int bg_ret = 0;
 	int dev_ret = 0;
 	int ret = 0;
 
-	/*
-	 * try to trim all FS space, our block group may start from non-zero.
-	 */
-	if (range->len == total_bytes)
-		cache = btrfs_lookup_first_block_group(fs_info, range->start);
-	else
-		cache = btrfs_lookup_block_group(fs_info, range->start);
-
+	cache = btrfs_lookup_first_block_group(fs_info, range->start);
 	for (; cache; cache = next_block_group(fs_info, cache)) {
 		if (cache->key.objectid >= (range->start + range->len)) {
 			btrfs_put_block_group(cache);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63600dc2ac4c..8165a4bfa579 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -491,7 +491,6 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 	struct fstrim_range range;
 	u64 minlen = ULLONG_MAX;
 	u64 num_devices = 0;
-	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -515,11 +514,15 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 		return -EOPNOTSUPP;
 	if (copy_from_user(&range, arg, sizeof(range)))
 		return -EFAULT;
-	if (range.start > total_bytes ||
-	    range.len < fs_info->sb->s_blocksize)
+
+	/*
+	 * NOTE: Don't truncate the range using super->total_bytes.
+	 * Bytenr of btrfs block group is in btrfs logical address space,
+	 * which can be any sector size aligned bytenr in [0, U64_MAX].
+	 */
+	if (range.len < fs_info->sb->s_blocksize)
 		return -EINVAL;
 
-	range.len = min(range.len, total_bytes - range.start);
 	range.minlen = max(range.minlen, minlen);
 	ret = btrfs_trim_fs(fs_info, &range);
 	if (ret < 0)
-- 
2.18.0
