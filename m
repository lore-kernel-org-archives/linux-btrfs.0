Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38384 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbJRSgN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 14:36:13 -0400
Date: Sun, 18 Oct 2015 21:35:41 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: switch __btrfs_fs_incompat return type from int to
 bool
Message-ID: <20151018213541.GA19850@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Conform to __btrfs_fs_incompat() cast-to-bool (!!) by explicitly
returning boolean not int.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..f387e2d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4103,7 +4103,7 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 #define btrfs_fs_incompat(fs_info, opt) \
 	__btrfs_fs_incompat((fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
 
-static inline int __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
+static inline bool __btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
 {
 	struct btrfs_super_block *disk_super;
 	disk_super = fs_info->super_copy;
-- 
2.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
