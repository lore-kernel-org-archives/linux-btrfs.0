Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47235 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKF5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 00:57:16 -0500
Message-ID: <52A7FEA4.80208@huawei.com>
Date: Wed, 11 Dec 2013 13:56:52 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
MIME-Version: 1.0
To: <clm@fb.com>, <jbacik@fb.com>, <chris.mason@fusionio.com>,
        <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <mfasheh@suse.de>, <hch@lst.de>, <viro@zeniv.linux.org.uk>,
        <miaox@cn.fujitsu.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] fs: btrfs: new helper: file_inode(file)
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a111622..fdfc0d7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2690,7 +2690,7 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	struct btrfs_ioctl_same_args tmp;
 	struct btrfs_ioctl_same_args *same;
 	struct btrfs_ioctl_same_extent_info *info;
-	struct inode *src = file->f_dentry->d_inode;
+	struct inode *src = file_inode(file);
 	struct file *dst_file = NULL;
 	struct inode *dst;
 	u64 off;
@@ -2779,7 +2779,7 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 		if (file->f_path.mnt != dst_file->f_path.mnt)
 			goto next;

-		dst = dst_file->f_dentry->d_inode;
+		dst = file_inode(dst_file);
 		if (src->i_sb != dst->i_sb)
 			goto next;

-- 
1.8.2.2

