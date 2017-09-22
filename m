Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40146 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752316AbdIVR6x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 13:58:53 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: increase output size for LOGICAL_INO_V2 ioctl
Date: Fri, 22 Sep 2017 13:58:47 -0400
Message-Id: <20170922175847.6071-4-ce3g8jdj@umail.furryterror.org>
In-Reply-To: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Build-server workloads have hundreds of references per file after dedup.
Multiply by a few snapshots and we quickly exhaust the limit of 2730
references per extent that can fit into a 64K buffer.

Raise the limit to 16M to be consistent with other btrfs ioctls
(e.g. TREE_SEARCH_V2, FILE_EXTENT_SAME).

To minimize surprising userspace behavior, apply this change only to
the LOGICAL_INO_V2 ioctl.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f4281ffd1833..1940678fc440 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4554,6 +4554,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 
 	if (version == 1) {
 		ignore_offset = false;
+		size = min_t(u32, loi->size, SZ_64K);
 	} else {
 		/* All reserved bits must be 0 for now */
 		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved))) {
@@ -4566,6 +4567,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 			goto out_loi;
 		}
 		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
+		size = min_t(u32, loi->size, SZ_16M);
 	}
 
 	path = btrfs_alloc_path();
@@ -4574,7 +4576,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	size = min_t(u32, loi->size, SZ_64K);
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-- 
2.11.0

