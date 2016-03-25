Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49858 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbcCYOCr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:02:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u2PDtqYT008186
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:02:46 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 21vva21vvc-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:02:46 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: don't use src fd for printk
Date: Fri, 25 Mar 2016 10:02:41 -0400
Message-ID: <1458914561-4638-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fd we pass in may not be on a btrfs file system, so don't try to do
BTRFS_I() on it.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8bbecda..b0d1345 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1644,7 +1644,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 		src_inode = file_inode(src.file);
 		if (src_inode->i_sb != file_inode(file)->i_sb) {
-			btrfs_info(BTRFS_I(src_inode)->root->fs_info,
+			btrfs_info(BTRFS_I(file_inode(file))->root->fs_info,
 				   "Snapshot src from another FS");
 			ret = -EXDEV;
 		} else if (!inode_owner_or_capable(src_inode)) {
-- 
2.5.0

