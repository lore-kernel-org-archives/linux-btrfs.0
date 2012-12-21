Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47937 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2LULCp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 06:02:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBLAe8Rj031105
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 18:40:08 +0800
Message-ID: <50D43C3A.7090608@cn.fujitsu.com>
Date: Fri, 21 Dec 2012 18:38:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 1/3] Btrfs: fix missing write access release in btrfs_ioctl_resize()
References: <50D42998.1010100@cn.fujitsu.com>
In-Reply-To: <50D42998.1010100@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to give up the write access after we find some device operation
is going on. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- don't break the string
---
 fs/btrfs/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7624212..d6f43fa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1339,6 +1339,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
 		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		mnt_drop_write_file(file);
 		return -EINPROGRESS;
 	}
 
-- 
1.7.11.7

