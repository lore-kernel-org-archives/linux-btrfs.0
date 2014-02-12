Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2073 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaBLFnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 00:43:47 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] btrfs-progs: Fix check_arg_type() which doesn't use realpath() result.
Date: Wed, 12 Feb 2014 13:44:37 +0800
Message-Id: <1392183877-25032-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix a problem that does not use the result of realpath(), which caused
check_arg_type() can't handle mount point which ends with a final '/'.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b12976f..e3c1156 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -448,10 +448,10 @@ static int check_arg_type(char *input)
 		return -EINVAL;
 
 	if (realpath(input, path)) {
-		if (is_block_device(input) == 1)
+		if (is_block_device(path) == 1)
 			return BTRFS_ARG_BLKDEV;
 
-		if (is_mount_point(input) == 1)
+		if (is_mount_point(path) == 1)
 			return BTRFS_ARG_MNTPOINT;
 
 		return BTRFS_ARG_UNKNOWN;
-- 
1.8.5.4

