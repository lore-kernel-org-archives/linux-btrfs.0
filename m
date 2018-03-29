Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:28102 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbeC2IXt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 04:23:49 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id EAB87AC00EC
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:23:42 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 325DB58426C
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:23:42 +0900 (JST)
Subject: [PATCH v2 3/3] btrfs-progs: fi usage: cleanup unnecessary permission
 error check
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Message-ID: <a7a4f704-f2bc-1231-dec2-de5524f3bbdd@jp.fujitsu.com>
Date: Thu, 29 Mar 2018 17:23:39 +0900
MIME-Version: 1.0
In-Reply-To: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since BTRFS_IOC_FS_INFO does not require root privilege, there is no
need to check EPERM error.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-fi-usage.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 2d45b3bb..5ce87a37 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -549,8 +549,6 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
 	if (ret < 0) {
-		if (errno == EPERM)
-			return -errno;
 		error("cannot get filesystem info: %m");
 		return 1;
 	}
@@ -635,11 +633,6 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
 	}
 
 	ret = load_device_info(fd, devinfo, devcount);
-	if (ret == -EPERM) {
-		warning(
-		"cannot get filesystem info from ioctl(FS_INFO), run as root");
-		ret = 0;
-	}
 
 	return ret;
 }
-- 
2.14.3

