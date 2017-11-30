Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:50167 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdK3HxT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 02:53:19 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A626AAC002B
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:53:16 +0900 (JST)
Received: from g01jpexchkw36.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id C4AB93287E9
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:53:15 +0900 (JST)
Subject: [PATCH 3/3] btrfs-progs: fi usage: cleanup unneccessary permission
 error check
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Message-ID: <9be13116-09f2-6f24-7e81-d215f5b215cc@jp.fujitsu.com>
Date: Thu, 30 Nov 2017 16:53:12 +0900
MIME-Version: 1.0
In-Reply-To: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since BTRFS_IOC_FS_INFO does not require root privilege, there is no
need to check EPERM error.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-fi-usage.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 7bbc9896..b0721560 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -522,8 +522,6 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
 	if (ret < 0) {
-		if (errno == EPERM)
-			return -errno;
 		error("cannot get filesystem info: %s",
 				strerror(errno));
 		return 1;
@@ -597,11 +595,6 @@ int load_chunk_and_device_info(int fd, struct chunk_info **chunkinfo,
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
2.13.6

