Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([125.16.236.6]:59015 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbcDZN2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:28:17 -0400
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 26 Apr 2016 18:58:14 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3QDSBhf9830854
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:11 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3QDSA3T010035
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 18:58:11 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com
Subject: [PATCH V18 15/18] Btrfs: subpage-blocksize: Enable dedupe ioctl
Date: Tue, 26 Apr 2016 18:57:14 +0530
Message-Id: <1461677237-7703-16-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function implementing the dedupe ioctl
i.e. btrfs_ioctl_file_extent_same(), returns with an error in
subpage-blocksize scenario. This was done due to the fact that Btrfs did
not have code to deal with block size < page size. This commit removes
this restriction since we now support "block size < page size".

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bf79dbc..4ff7cf8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3256,21 +3256,11 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 {
 	struct inode *src = file_inode(src_file);
 	struct inode *dst = file_inode(dst_file);
-	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	ssize_t res;
 
 	if (olen > BTRFS_MAX_DEDUPE_LEN)
 		olen = BTRFS_MAX_DEDUPE_LEN;
 
-	if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
-		/*
-		 * Btrfs does not support blocksize < page_size. As a
-		 * result, btrfs_cmp_data() won't correctly handle
-		 * this situation without an update.
-		 */
-		return -EINVAL;
-	}
-
 	res = btrfs_extent_same(src, loff, olen, dst, dst_loff);
 	if (res)
 		return res;
-- 
2.1.0

