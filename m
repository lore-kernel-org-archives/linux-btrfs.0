Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37679 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcBDGsC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 01:48:02 -0500
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 4 Feb 2016 16:47:59 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 233AE2CE8057
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Feb 2016 17:47:58 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u146loYM58327132
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Feb 2016 17:47:58 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u146lPUL015796
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Feb 2016 17:47:25 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V14 15/15] Btrfs: subpagesize-blocksize: Enable dedup ioctl
Date: Thu,  4 Feb 2016 12:16:22 +0530
Message-Id: <1454568382-2020-16-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1454568382-2020-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1454568382-2020-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function implementing the dedup ioctl
i.e. btrfs_ioctl_file_extent_same(), returns with an error in
subpagesize-blocksize scenario. This was done due to the fact that Btrfs
did not have code to deal with block size < page size. This commit
removes this restriction since we now support "block size < page size".

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b209415..ab47cfa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3191,7 +3191,6 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	int i;
 	int ret;
 	unsigned long size;
-	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	bool is_admin = capable(CAP_SYS_ADMIN);
 	u16 count;
 
@@ -3228,16 +3227,6 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	if (len > BTRFS_MAX_DEDUPE_LEN)
 		len = BTRFS_MAX_DEDUPE_LEN;
 
-	if (WARN_ON_ONCE(bs < PAGE_CACHE_SIZE)) {
-		/*
-		 * Btrfs does not support blocksize < page_size. As a
-		 * result, btrfs_cmp_data() won't correctly handle
-		 * this situation without an update.
-		 */
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = -EISDIR;
 	if (S_ISDIR(src->i_mode))
 		goto out;
-- 
2.1.0

