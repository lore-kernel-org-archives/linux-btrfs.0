Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33438 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934382AbdBQOoM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:12 -0500
Received: by mail-wm0-f68.google.com with SMTP id v77so2937149wmv.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:11 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 24/38] btrfs: make btrfs_print_data_csum_error take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:15 +0200
Message-Id: <1487342609-20652-25-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/btrfs_inode.h | 8 ++++----
 fs/btrfs/compression.c | 2 +-
 fs/btrfs/inode.c       | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 36eca5464e1b..c10d21b2f0df 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -324,21 +324,21 @@ static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
 		  &BTRFS_I(inode)->runtime_flags);
 }
 
-static inline void btrfs_print_data_csum_error(struct inode *inode,
+static inline void btrfs_print_data_csum_error(struct btrfs_inode *inode,
 		u64 logical_start, u32 csum, u32 csum_expected, int mirror_num)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 
 	/* Output minus objectid, which is more meaningful */
 	if (root->objectid >= BTRFS_LAST_FREE_OBJECTID)
 		btrfs_warn_rl(root->fs_info,
 	"csum failed root %lld ino %lld off %llu csum 0x%08x expected csum 0x%08x mirror %d",
-			root->objectid, btrfs_ino(BTRFS_I(inode)),
+			root->objectid, btrfs_ino(inode),
 			logical_start, csum, csum_expected, mirror_num);
 	else
 		btrfs_warn_rl(root->fs_info,
 	"csum failed root %llu ino %llu off %llu csum 0x%08x expected csum 0x%08x mirror %d",
-			root->objectid, btrfs_ino(BTRFS_I(inode)),
+			root->objectid, btrfs_ino(inode),
 			logical_start, csum, csum_expected, mirror_num);
 }
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 903c32c9eb22..b8de71abfbd3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -124,7 +124,7 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
-			btrfs_print_data_csum_error(inode, disk_start, csum,
+			btrfs_print_data_csum_error(BTRFS_I(inode), disk_start, csum,
 						    *cb_sum, cb->mirror_num);
 			ret = -EIO;
 			goto fail;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8c22820b6b0a..f71296933aec 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3034,7 +3034,7 @@ static int __readpage_endio_check(struct inode *inode,
 	kunmap_atomic(kaddr);
 	return 0;
 zeroit:
-	btrfs_print_data_csum_error(inode, start, csum, csum_expected,
+	btrfs_print_data_csum_error(BTRFS_I(inode), start, csum, csum_expected,
 				    io_bio->mirror_num);
 	memset(kaddr + pgoff, 1, len);
 	flush_dcache_page(page);
-- 
2.7.4

