Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48974 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3JKLp0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 07:45:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: use the marco BTRFS_UPDATE_KERNEL where needed
Date: Fri, 11 Oct 2013 19:52:54 +0800
Message-Id: <1381492374-7227-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1381492374-7227-1-git-send-email-anand.jain@oracle.com>
References: <1381492374-7227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |    2 +-
 utils.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 1315918..6f32356 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -203,7 +203,7 @@ static int cmd_scan_dev(int argc, char **argv)
 	if(argc<=devstart){
 		int ret;
 		printf("Scanning for Btrfs filesystems\n");
-		ret = scan_for_btrfs(where, 1);
+		ret = scan_for_btrfs(where, BTRFS_UPDATE_KERNEL);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 1;
diff --git a/utils.c b/utils.c
index 2f1d54f..f324147 100644
--- a/utils.c
+++ b/utils.c
@@ -961,7 +961,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(0)))
+		if((ret = btrfs_scan_for_fsid(!BTRFS_UPDATE_KERNEL)))
 			return ret;
 	}
 
-- 
1.7.1

