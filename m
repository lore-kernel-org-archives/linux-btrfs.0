Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbeHOJES (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 05:04:18 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 723E4AFAA
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 06:13:30 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Always check nocow for quota enabled case to make sure we won't reserve unnecessary data space
Date: Wed, 15 Aug 2018 14:13:23 +0800
Message-Id: <20180815061323.23936-1-wqu@suse.com>
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
 fs/btrfs/file.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 51e77d72068a..f2ce1d707d4c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1587,6 +1587,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
+	bool quota_enabled = test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1627,9 +1628,15 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				fs_info->sectorsize);
 
 		extent_changeset_release(data_reserved);
-		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
+		/*
+		 * If we have quota enabled, we must do the heavy lift nocow
+		 * check here to avoid reserving data space, or we can hit
+		 * limitation for NOCOW files.
+		 */
+		if (!quota_enabled)
+			ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
 						  write_bytes);
-		if (ret < 0) {
+		if (ret < 0 || quota_enabled) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
 			    check_can_nocow(BTRFS_I(inode), pos,
-- 
2.18.0
