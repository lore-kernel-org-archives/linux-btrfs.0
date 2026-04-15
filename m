Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA583D5237
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263899; cv=none; b=qmy4t38xM7lHQvoerWfCYCo6h33f3Y5Ir5rGcV8zzeZecAwxHu8Iv1YuGJxSRVwgHuaZsQlMOPtG7E0bc3U9CHIPG66sduWLDlSNmtI7dabN55qT4M0F3Yz1U2dajqQl5n7GMF8jLb6U8a+RcxSYidbpUT/odS4q/Fy7z2POOoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263899; c=relaxed/simple;
	bh=i5gQ2UD0scc6OQ13lIfrvzVPzzq7o1oj0MnB5Q3mXoo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXYsQpiVd0mwmEuERPsc5BM/p6k+z4v1sw4OsYbphlI6Wntn4Dx7bYu6qZa4ldjihOaUO3gLZTJe1B6OBf0ch7KX+6KOhCUpAXItE2Vbwwc6iH/curTAo5OvpOkfAxusL8KlWWvI2htLsNossEUVnMesv96r3cbKye7cLtLUq88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JytW1n+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JytW1n+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C94BC2BCB3
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263899;
	bh=i5gQ2UD0scc6OQ13lIfrvzVPzzq7o1oj0MnB5Q3mXoo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JytW1n+zxA5FiFAernETcW70ss0orwkM3DiU9yh2s3GYQaDF+dXZMaSHlNGtgFnWa
	 JTWg6WObD3TQDAKGgrOWrSuSyVfd9KIL8bkuK4crbch+E0v/c30c1u2A+z+t4r/JdY
	 XJozcJo46PBkXZ7E7KwX1p4KEJg+C1QzmnULzw++shtnqAtwR4O4BhfrIuFcl/6YE6
	 ORDW0MXPFkBvlqMOjcb+kiLBYS4SaR4s5DOMWmjb4pxl13V9ZSJRhFUKmhcdUgbSOL
	 sQQH+V63rIV0Hs9znd62Z10npsskaT5eso+b3iUZx0yV7HheKHctSpNttQPEFZwSiV
	 ma2N0cuVRHrYA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs: remove start field from struct btrfs_free_space_ctl
Date: Wed, 15 Apr 2026 15:38:07 +0100
Message-ID: <6c5cf7879292ce6c8ed2deec0de5b9e1ccd7d8ac.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need for the start field, we can take it from the block group.
This reduces the structure size from 152 bytes down to 144 bytes, so on
a 4K page system we can now fit 28 structures instead of 26.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 9 ++++-----
 fs/btrfs/free-space-cache.h | 1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab22e4f9ffdd..4f53e0908f18 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1572,10 +1572,10 @@ static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
 	u64 bytes_per_bitmap;
 
 	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
-	bitmap_start = offset - ctl->start;
+	bitmap_start = offset - ctl->block_group->start;
 	bitmap_start = div64_u64(bitmap_start, bytes_per_bitmap);
 	bitmap_start *= bytes_per_bitmap;
-	bitmap_start += ctl->start;
+	bitmap_start += ctl->block_group->start;
 
 	return bitmap_start;
 }
@@ -2054,9 +2054,9 @@ find_free_space(struct btrfs_free_space_ctl *ctl, u64 *offset, u64 *bytes,
 		 * to match our requested alignment
 		 */
 		if (*bytes >= align) {
-			tmp = entry->offset - ctl->start + align - 1;
+			tmp = entry->offset - ctl->block_group->start + align - 1;
 			tmp = div64_u64(tmp, align);
-			tmp = tmp * align + ctl->start;
+			tmp = tmp * align + ctl->block_group->start;
 			align_off = tmp - entry->offset;
 		} else {
 			align_off = 0;
@@ -2951,7 +2951,6 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 
 	spin_lock_init(&ctl->tree_lock);
 	ctl->unit = fs_info->sectorsize;
-	ctl->start = block_group->start;
 	ctl->block_group = block_group;
 	ctl->op = &free_space_op;
 	ctl->free_space_bytes = RB_ROOT_CACHED;
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 33fc3b245648..e75482fb2d69 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -82,7 +82,6 @@ struct btrfs_free_space_ctl {
 	int free_extents;
 	int total_bitmaps;
 	int unit;
-	u64 start;
 	s32 discardable_extents[BTRFS_STAT_NR_ENTRIES];
 	s64 discardable_bytes[BTRFS_STAT_NR_ENTRIES];
 	const struct btrfs_free_space_op *op;
-- 
2.47.2

