Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbbJJOb1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Oct 2015 10:31:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs-progs: Code optimize and cleanup device add
Date: Sat, 10 Oct 2015 22:30:57 +0800
Message-Id: <1444487458-2988-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
References: <1444487458-2988-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is needed by the patch which introduces new devid option for the
btrfs device delete.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 5f2b952..ee48c2e 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -51,8 +51,9 @@ static int cmd_device_add(int argc, char **argv)
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
 	DIR	*dirstream = NULL;
-	int discard = 1;
-	int force = 0;
+	int	discard = 1;
+	int	force = 0;
+	int	last_dev;
 
 	while (1) {
 		int c;
@@ -77,18 +78,17 @@ static int cmd_device_add(int argc, char **argv)
 		}
 	}
 
-	argc = argc - optind;
-
-	if (check_argc_min(argc, 2))
+	if (check_argc_min(argc - optind, 2))
 		usage(cmd_device_add_usage);
 
-	mntpnt = argv[optind + argc - 1];
+	last_dev = argc - 1;
+	mntpnt = argv[last_dev];
 
 	fdmnt = btrfs_open_dir(mntpnt, &dirstream, 1);
 	if (fdmnt < 0)
 		return 1;
 
-	for (i = optind; i < optind + argc - 1; i++){
+	for (i = optind; i < last_dev; i++){
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
-- 
2.4.1

