Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58731 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753322AbeCBFXH (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Mar 2018 00:23:07 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/5] btrfs: Embed sector size check into BTRFS_MAX_INLINE_DATA_SIZE()
Date: Fri,  2 Mar 2018 13:22:52 +0800
Message-Id: <20180302052254.7059-4-wqu@suse.com>
In-Reply-To: <20180302052254.7059-1-wqu@suse.com>
References: <20180302052254.7059-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have extra sector size check in cow_file_range_inline(), but doesn't
implement it in BTRFS_MAX_INLINE_DATA_SIZE().

The biggest reason is that btrfs_symlink() also uses this macro to check
name length.

In fact such behavior makes max_inline calculation quite confusing, and
cause unexpected large extent for symbol link.

Here we embed sector size check into BTRFS_MAX_INLINE_DATA_SIZE() so
that it will never exceed sector size.

The downside is, for symbol link, we will reduce max symbol link length
from 16K- to 4095, but it won't affect current system using that long
name, but only prevent later creation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h | 5 +++--
 fs/btrfs/inode.c | 1 -
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 13c260b525a1..90948096c00f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1297,8 +1297,9 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
 		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
 {
-	return BTRFS_MAX_ITEM_SIZE(info) -
-	       BTRFS_FILE_EXTENT_INLINE_DATA_START;
+	return min_t(u32, info->sectorsize - 1,
+		     BTRFS_MAX_ITEM_SIZE(info) -
+		     BTRFS_FILE_EXTENT_INLINE_DATA_START);
 }
 
 static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 48472509239b..fe2991eeb337 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -299,7 +299,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 
 	if (start > 0 ||
 	    actual_end > fs_info->sectorsize ||
-	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
 	    (!compressed_size &&
 	    (actual_end & (fs_info->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
-- 
2.16.2

