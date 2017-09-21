Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33380 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdIUAmi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 20:42:38 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: increase output size for LOGICAL_INO_V2 ioctl
Date: Wed, 20 Sep 2017 20:33:33 -0400
Message-Id: <20170921003333.12467-3-ce3g8jdj@umail.furryterror.org>
In-Reply-To: <20170921003333.12467-1-ce3g8jdj@umail.furryterror.org>
References: <20170921003333.12467-1-ce3g8jdj@umail.furryterror.org>
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
index def0ab85134a..e13fea25ecb8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4560,6 +4560,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 
 	if (version == 1) {
 		ignore_offset = false;
+		size = min_t(u32, loi->size, SZ_64K);
 	} else {
 		/* Only accept flags we have defined so far */
 		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET)) {
@@ -4567,6 +4568,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 			goto out_loi;
 		}
 		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
+		size = min_t(u32, loi->size, SZ_16M);
 	}
 
 	path = btrfs_alloc_path();
@@ -4575,7 +4577,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	size = min_t(u32, loi->size, SZ_64K);
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-- 
2.11.0

