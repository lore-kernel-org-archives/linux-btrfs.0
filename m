Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36176 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754925AbeAHDFB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jan 2018 22:05:01 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH 2/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in btrfs.ko
Date: Mon,  8 Jan 2018 11:05:12 +0800
Message-Id: <20180108030512.22344-2-anand.jain@oracle.com>
In-Reply-To: <20180108030512.22344-1-anand.jain@oracle.com>
References: <20180108030512.22344-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Userland uses this flag and resets it only when changing the fsid is
complete. Its not a good idea to mount the device anything in between,
so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID is set.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
  cc: wqu@suse.com
---
 fs/btrfs/disk-io.c              | 7 ++++++-
 include/uapi/linux/btrfs_tree.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a69e5944dc08..8b76faa77235 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -61,7 +61,8 @@
 				 BTRFS_HEADER_FLAG_RELOC |\
 				 BTRFS_SUPER_FLAG_ERROR |\
 				 BTRFS_SUPER_FLAG_SEEDING |\
-				 BTRFS_SUPER_FLAG_METADUMP)
+				 BTRFS_SUPER_FLAG_METADUMP |\
+				 BTRFS_SUPER_FLAG_CHANGING_FSID)
 
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
@@ -3906,6 +3907,10 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		btrfs_err(fs_info, "no valid FS found");
 		ret = -EINVAL;
 	}
+	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_CHANGING_FSID) {
+		btrfs_err(fs_info, "SUPER_FLAG_CHANGING_FSID is set");
+		ret = -EINVAL;
+	}
 	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP)
 		btrfs_warn(fs_info, "unrecognized super flag: %llu",
 				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 38ab0e06259a..aff1356c2bb8 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -457,6 +457,7 @@ struct btrfs_free_space_header {
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 #define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
+#define BTRFS_SUPER_FLAG_CHANGING_FSID	(1ULL << 35)
 
 
 /*
-- 
2.15.0

