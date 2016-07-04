Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44906 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752791AbcGDEfy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XdNS093749
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:53 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23x7ruh1sp-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:53 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 3 Jul 2016 22:35:53 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 14/19] Btrfs: subpage-blocksize: Enable dedupe ioctl
Date: Mon,  4 Jul 2016 10:04:34 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-15-git-send-email-chandan@linux.vnet.ibm.com>
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
index fb92566..5d9062e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3325,21 +3325,11 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
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
2.5.5

