Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3IRIaX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 04:30:23 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8I8UFxT030186
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 16:30:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs-progs: do not run ioctls in check_mounted_where()
Date: Wed, 18 Sep 2013 16:27:33 +0800
Message-Id: <1379492856-30639-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to run ioctls when checking whether btrfs
has mounted somewhere.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 134bf80..e3738d3 100644
--- a/utils.c
+++ b/utils.c
@@ -956,7 +956,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(1)))
+		if((ret = btrfs_scan_for_fsid(0)))
 			return ret;
 	}
 
-- 
1.8.3.1

