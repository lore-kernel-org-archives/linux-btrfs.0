Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaBZFkp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 00:40:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1Q5ebLM012431
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 13:40:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Remove the get_fslist error message.
Date: Wed, 26 Feb 2014 13:41:38 +0800
Message-Id: <1393393298-25652-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When calling get_fslist on a kernel doesn't support
BTRFS_IOC_GET_FSLIST, an error message will output but the codes will
continue using the old way to scan mounted fs.

Since the error message will fail xfstest/btrfs/006 testcase and there
is a fallback way, the message should not be printed.

Also other error message in get_fslist is not needed since the functions
in utils.c should not print any thing and caller will handle the error.
This patch just remove the unneeded perror messages.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/utils.c b/utils.c
index 33b3ddc..364c191 100644
--- a/utils.c
+++ b/utils.c
@@ -2209,10 +2209,8 @@ int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count)
 
 	fd = open("/dev/btrfs-control", O_RDWR);
 	e = errno;
-	if (fd < 0) {
-		perror("failed to open /dev/btrfs-control");
+	if (fd < 0)
 		return -e;
-	}
 
 	/* space to hold 512 fsids, doesn't matter if small
 	 * it would fail and return count so then we try again
@@ -2238,8 +2236,6 @@ again:
 		free(fsargs);
 		goto again;
 	} else if (ret < 0) {
-		printf("ERROR: scan_fsid ioctl failed - %s\n",
-			strerror(e));
 		ret = -e;
 		goto out;
 	}
-- 
1.9.0

