Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbbJBPuL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 11:50:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 974C1ACB8
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2015 15:50:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: fix error checking in load_device_info
Date: Fri,  2 Oct 2015 17:49:08 +0200
Message-Id: <1443800948-27933-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

load_device_info queries the FS_INFO ioctl and this may fail with EPERM
on older kernels. The check did not verify the ioctl return value and
incorrectly returned EPERM if it was previously stored in errno.

This fixes 'btrfs fi usage' that will print the overall summary for all
users (provided that the FS_INFO ioctl is already unprivileged).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-fi-usage.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 54b8b1c1d996..50d633372023 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -504,7 +504,7 @@ static int cmp_device_info(const void *a, const void *b)
 static int load_device_info(int fd, struct device_info **device_info_ptr,
 			   int *device_info_count)
 {
-	int ret, i, ndevs, e;
+	int ret, i, ndevs;
 	struct btrfs_ioctl_fs_info_args fi_args;
 	struct btrfs_ioctl_dev_info_args dev_info;
 	struct device_info *info;
@@ -513,12 +513,11 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 	*device_info_ptr = 0;
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
-	e = errno;
-	if (e == EPERM)
-		return -e;
 	if (ret < 0) {
+		if (errno == EPERM)
+			return -errno;
 		fprintf(stderr, "ERROR: cannot get filesystem info - %s\n",
-				strerror(e));
+				strerror(errno));
 		return 1;
 	}
 
-- 
2.1.3

