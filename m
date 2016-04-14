Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([125.16.236.3]:54564 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbcDNIdm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 04:33:42 -0400
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 14 Apr 2016 14:03:39 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3E8Xa4Y5505390
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:03:36 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3E8XYsK021684
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:03:36 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com, aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH V16 16/18] Btrfs: btrfs_clone: Flush dirty blocks of a page that do not map the clone range
Date: Thu, 14 Apr 2016 14:02:53 +0530
Message-Id: <1460622775-20723-17-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1460622775-20723-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1460622775-20723-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After cloning the required extents, we truncate all the pages that map
the file range being cloned. In subpage-blocksize scenario, we could
have dirty blocks before and/or after the clone range in the
leading/trailing pages. Truncating these pages would lead to data
loss. Hence this commit forces such dirty blocks to be flushed to disk
before performing the clone operation.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ioctl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4ff7cf8..3038589 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3849,6 +3849,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	int ret;
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
+	u64 dest_end;
 	int same_inode = src == inode;
 
 	/*
@@ -3909,6 +3910,21 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 			goto out_unlock;
 	}
 
+	if ((round_down(destoff, PAGE_CACHE_SIZE) < inode->i_size) &&
+		!IS_ALIGNED(destoff, PAGE_CACHE_SIZE)) {
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+					round_down(destoff, PAGE_CACHE_SIZE),
+					destoff - 1);
+	}
+
+	dest_end = destoff + len - 1;
+	if ((dest_end < inode->i_size) &&
+		!IS_ALIGNED(dest_end + 1, PAGE_CACHE_SIZE)) {
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+					dest_end + 1,
+					round_up(dest_end, PAGE_CACHE_SIZE));
+	}
+
 	if (destoff > inode->i_size) {
 		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
 		if (ret)
-- 
2.1.0

