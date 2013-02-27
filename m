Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:37969 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3B0LD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 06:03:27 -0500
Received: by mail-da0-f42.google.com with SMTP id n15so247300dad.29
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 03:03:27 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH 1/2] Btrfs-progs: let the error message outputed only once
Date: Wed, 27 Feb 2013 19:03:21 +0800
Message-Id: <1361963001-1934-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

If we fail to execute the command:
		btrfs qgroup show <mnt>
It will output the follow messages:
	ERROR: can't perform the search - Inappropriate ioctl for device
	ERROR: can't list qgroups

The error is outputed twice, this is wrong, fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 26f0ab0..79888c8 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -120,7 +120,6 @@ int list_qgroups(int fd)
 	struct btrfs_ioctl_search_header *sh;
 	unsigned long off = 0;
 	unsigned int i;
-	int e;
 	struct btrfs_qgroup_info_item *info;
 
 	memset(&args, 0, sizeof(args));
@@ -143,13 +142,9 @@ int list_qgroups(int fd)
 
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		e = errno;
-		if (ret < 0) {
-			fprintf(stderr,
-				"ERROR: can't perform the search - %s\n",
-				strerror(e));
+		if (ret < 0)
 			return ret;
-		}
+
 		/* the ioctl returns the number of item it found in nr_items */
 		if (sk->nr_items == 0)
 			break;
-- 
1.7.7.6

