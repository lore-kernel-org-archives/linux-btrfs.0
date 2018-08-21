Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbeHUI7C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 04:59:02 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09D9EAEA6
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 05:40:23 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: Always check nocow for quota enabled case to make sure we won't reserve unnecessary data space
Date: Tue, 21 Aug 2018 13:40:16 +0800
Message-Id: <20180821054016.28058-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
makes nocow check less frequent to improve performance.

However for quota enabled case, such optimization could lead to extra
unnecessary data reservation, which results failure for test case like
btrfs/153 in fstests.

Fix it by reverting to old behavior for quota enabled case.

Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog
v2:
  Fix regression for quota+cow case. (Previously it will skip data
  reservation if quota is enabled, causing regression for limit case.
  Pointed out by Misono)
---
 fs/btrfs/file.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2be00e873e92..183e5fb96f42 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1584,6 +1584,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
+	bool quota_enabled = test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1624,13 +1625,28 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 				fs_info->sectorsize);
 
 		extent_changeset_release(data_reserved);
+
+		/*
+		 * If we have quota enabled, we must do the heavy lift nocow
+		 * check here to avoid reserving data space, or we can hit
+		 * limitation for NOCOW files.
+		 */
+		if (quota_enabled) {
+			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+						      BTRFS_INODE_PREALLOC)) &&
+			    check_can_nocow(BTRFS_I(inode), pos,
+					    &write_bytes) > 0)
+				goto reserve_meta_only;
+		}
 		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
 						  write_bytes);
 		if (ret < 0) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
 			    check_can_nocow(BTRFS_I(inode), pos,
-					&write_bytes) > 0) {
+					&write_bytes) > 0 &&
+			    !quota_enabled) {
+reserve_meta_only:
 				/*
 				 * For nodata cow case, no need to reserve
 				 * data space.
-- 
2.18.0
