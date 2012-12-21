Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2LUJSu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 04:18:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qBL9KWoT026387
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 17:20:32 +0800
Message-ID: <50D42998.1010100@cn.fujitsu.com>
Date: Fri, 21 Dec 2012 17:19:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: fix missing write access release in btrfs_ioctl_resize()
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to give up the write access after we find some device operation
is going on. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7624212..679b82c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1338,7 +1338,9 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
+		pr_info("btrfs: dev add/delete/balance/replace/resize operation"
+			" in progress\n");
+		mnt_drop_write_file(file);
 		return -EINPROGRESS;
 	}
 
-- 
1.7.11.7
