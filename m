Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbaCaKHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 06:07:47 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2VA7UTk028418
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 18:07:31 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: filter invalid arg for btrfs resize
Date: Mon, 31 Mar 2014 18:03:25 +0800
Message-Id: <1396260206-14153-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally following cmds will work:
	# btrfs fi resize -10A  <mnt>
	# btrfs fi resize -10Gaha <mnt>
Filter the arg by checking the return pointer of memparse.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e174770..2ed21fa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1459,6 +1459,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device = NULL;
 	char *sizestr;
+	char *retptr;
 	char *devstr = NULL;
 	int ret = 0;
 	int mod = 0;
@@ -1526,8 +1527,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			mod = 1;
 			sizestr++;
 		}
-		new_size = memparse(sizestr, NULL);
-		if (new_size == 0) {
+		new_size = memparse(sizestr, &retptr);
+		if (*retptr != '\0' || new_size == 0) {
 			ret = -EINVAL;
 			goto out_free;
 		}
-- 
1.8.1.4

