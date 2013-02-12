Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41164 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750Ab3BLTFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 14:05:43 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E352E9A04F8
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 12:05:42 -0700 (MST)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id sM6XKXnzCCRZvyNT (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 12:05:42 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: relax the block group size limit for bitmaps
Date: Tue, 12 Feb 2013 14:12:40 -0500
Message-ID: <1360696360-24088-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave pointed out that xfstests 273 will tell you that it failed to load the
space cache for a block group when it remounts.  This is because we run out
of space writing out the block group cache.  This is ok and is working as it
should, but let's try to be a bit nicer.  This happens because the block
group was 100mb, but bitmap entries cover 128mb, so we were only getting
extent entries for this block group, which ended up being too many to fit in
the free space cache.  So relax the bitmap size requirements to block groups
that are at least half the size a bitmap will cover or larger, that way we
can still keep the amount of space used in the free space cache low enough
to be able to write it out.  With this patch I no longer fail to write out
the free space cache.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/free-space-cache.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0be7a87..c8090f1 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1356,6 +1356,8 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	u64 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
 	int max_bitmaps = div64_u64(size + bytes_per_bg - 1, bytes_per_bg);
 
+	max_bitmaps = max(max_bitmaps, 1);
+
 	BUG_ON(ctl->total_bitmaps > max_bitmaps);
 
 	/*
@@ -1636,10 +1638,14 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 	}
 
 	/*
-	 * some block groups are so tiny they can't be enveloped by a bitmap, so
-	 * don't even bother to create a bitmap for this
+	 * The original block groups from mkfs can be really small, like 8
+	 * megabytes, so don't bother with a bitmap for those entries.  However
+	 * some block groups can be smaller than what a bitmap would cover but
+	 * are still large enough that they could overflow the 32k memory limit,
+	 * so allow those block groups to still be allowed to have a bitmap
+	 * entry.
 	 */
-	if (BITS_PER_BITMAP * ctl->unit > block_group->key.offset)
+	if (((BITS_PER_BITMAP * ctl->unit) >> 1) > block_group->key.offset)
 		return false;
 
 	return true;
-- 
1.7.7.6

