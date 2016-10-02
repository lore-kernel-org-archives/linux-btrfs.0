Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751802AbcJBN0K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:26:10 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNCV9060670
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:26:10 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25t99m4q7q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:26:09 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:26:09 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 16/19] Btrfs: subpage-blocksize: btrfs_clone: Flush dirty blocks of a page that do not map the clone range
Date: Sun,  2 Oct 2016 18:54:25 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-17-git-send-email-chandan@linux.vnet.ibm.com>
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
index cf13029..0fdc0a0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3914,6 +3914,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	int ret;
 	u64 len = olen;
 	u64 bs = root->fs_info->sb->s_blocksize;
+	u64 dest_end;
 	int same_inode = src == inode;
 
 	/*
@@ -3974,6 +3975,21 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 			goto out_unlock;
 	}
 
+	if ((round_down(destoff, PAGE_SIZE) < inode->i_size) &&
+		!IS_ALIGNED(destoff, PAGE_SIZE)) {
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+					round_down(destoff, PAGE_SIZE),
+					destoff - 1);
+	}
+
+	dest_end = destoff + len - 1;
+	if ((dest_end < inode->i_size) &&
+		!IS_ALIGNED(dest_end + 1, PAGE_SIZE)) {
+		ret = filemap_write_and_wait_range(inode->i_mapping,
+					dest_end + 1,
+					round_up(dest_end, PAGE_SIZE));
+	}
+
 	if (destoff > inode->i_size) {
 		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
 		if (ret)
-- 
2.5.5

