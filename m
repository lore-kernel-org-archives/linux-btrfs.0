Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59499 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdK1HIj (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 28 Nov 2017 02:08:39 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, stable@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: Ensure btrfs_trim_fs can trim the whole fs
Date: Tue, 28 Nov 2017 15:08:30 +0800
Message-Id: <20171128070830.12756-2-wqu@suse.com>
In-Reply-To: <20171128070830.12756-1-wqu@suse.com>
References: <20171128070830.12756-1-wqu@suse.com>
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
changelog:
v2:
  Locate the root cause in btrfs_ioctl_fitrim(), remove the truncation
  so we can still allow user to trim custom range.
---
 fs/btrfs/ioctl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd172a93d11a..017fda31400d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -365,7 +365,6 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 	struct fstrim_range range;
 	u64 minlen = ULLONG_MAX;
 	u64 num_devices = 0;
-	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -389,11 +388,15 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
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
2.15.0

