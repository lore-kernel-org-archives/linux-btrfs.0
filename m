From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 01/12 v5] Revert "Btrfs: do not flush csum items of unchanged file data during treelog"
Date: Sat, 6 Aug 2011 17:37:36 +0800
Message-ID: <1312623467-31487-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 8e531cdfeb75269c6c5aae33651cca39707848da.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index babee65..f320641 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2689,9 +2689,6 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			extent = btrfs_item_ptr(src, start_slot + i,
 						struct btrfs_file_extent_item);
 
-			if (btrfs_file_extent_generation(src, extent) < trans->transid)
-				continue;
-
 			found_type = btrfs_file_extent_type(src, extent);
 			if (found_type == BTRFS_FILE_EXTENT_REG ||
 			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
-- 
1.6.5.2

