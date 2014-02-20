Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaBTCwu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 21:52:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K2qdxd013316
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 10:52:44 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs: fix wrong error msg for exec btrfsck as non-root
Date: Thu, 20 Feb 2014 10:49:05 +0800
Message-Id: <1392864546-545-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When exec btrfsck as non-root user on a disk, btrfsck will always
warn that "No such file or directory", despite that a directory
(e.g. /dev/vboxusb)actually exists. We just have no permission.
In this case, return the -errno set by the opendir call in
btrfs_scan_one_dir rather than blindly return -ENOENT.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 1878abc..12ed2f4 100644
--- a/utils.c
+++ b/utils.c
@@ -1114,7 +1114,7 @@ again:
 	dirp = opendir(dirname);
 	if (!dirp) {
 		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
-		ret = -ENOENT;
+		ret = -errno;
 		goto fail;
 	}
 	while(1) {
-- 
1.8.1.4

