Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90AEC10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 19:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9591213A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 19:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfBYTIB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 14:08:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:39216 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbfBYTIA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 14:08:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AECC4AF7A
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 19:07:59 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 3/3] btrfs: Perform locking/unlocking in btrfs_remap_file_range()
Date:   Mon, 25 Feb 2019 13:07:44 -0600
Message-Id: <20190225190744.21664-3-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190225190744.21664-1-rgoldwyn@suse.de>
References: <20190225190744.21664-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Moves code to make it more readable, so as locking and unlocking is
done in the same function.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ioctl.c | 53 +++++++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9c8e1734429c..f0ae1af91ff3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3975,22 +3975,6 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	u64 wb_len;
 	int ret;
 
-	if (!(remap_flags & REMAP_FILE_DEDUP)) {
-		struct btrfs_root *root_out = BTRFS_I(inode_out)->root;
-
-		if (btrfs_root_readonly(root_out))
-			return -EROFS;
-
-		if (file_in->f_path.mnt != file_out->f_path.mnt ||
-		    inode_in->i_sb != inode_out->i_sb)
-			return -EXDEV;
-	}
-
-	if (same_inode)
-		inode_lock(inode_in);
-	else
-		btrfs_double_inode_lock(inode_in, inode_out);
-
 	/*
 	 * Now that the inodes are locked, we need to start writeback ourselves
 	 * and can not rely on the writeback from the VFS's generic helper
@@ -4022,26 +4006,14 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	ret = btrfs_wait_ordered_range(inode_in, ALIGN_DOWN(pos_in, bs),
 				       wb_len);
 	if (ret < 0)
-		goto out_unlock;
+		return ret;
 	ret = btrfs_wait_ordered_range(inode_out, ALIGN_DOWN(pos_out, bs),
 				       wb_len);
 	if (ret < 0)
-		goto out_unlock;
+		return ret;
 
-	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
+	return generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 					    len, remap_flags);
-	if (ret < 0 || *len == 0)
-		goto out_unlock;
-
-	return 0;
-
- out_unlock:
-	if (same_inode)
-		inode_unlock(inode_in);
-	else
-		btrfs_double_inode_unlock(inode_in, inode_out);
-
-	return ret;
 }
 
 loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
@@ -4056,16 +4028,33 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
+	if (!(remap_flags & REMAP_FILE_DEDUP)) {
+		struct btrfs_root *root_out = BTRFS_I(dst_inode)->root;
+
+		if (btrfs_root_readonly(root_out))
+			return -EROFS;
+
+		if (src_file->f_path.mnt != dst_file->f_path.mnt ||
+		    src_inode->i_sb != dst_inode->i_sb)
+			return -EXDEV;
+	}
+
+	if (same_inode)
+		inode_lock(src_inode);
+	else
+		btrfs_double_inode_lock(src_inode, dst_inode);
+
 	ret = btrfs_remap_file_range_prep(src_file, off, dst_file, destoff,
 					  &len, remap_flags);
 	if (ret < 0 || len == 0)
-		return ret;
+		goto out_unlock;
 
 	if (remap_flags & REMAP_FILE_DEDUP)
 		ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
 	else
 		ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
 
+out_unlock:
 	if (same_inode)
 		inode_unlock(src_inode);
 	else
-- 
2.16.4

