Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38638 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932972AbbHZORv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 10:17:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7QEHhcC027056
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 22:17:43 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: remove code for setup mntid in cmd_subvol_show
Date: Wed, 26 Aug 2015 22:16:14 +0800
Message-ID: <88362f08a12bcf5c094b57cca9424ef5438e3605.1440598568.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to use value of mntid in cmd_subvol_show(), no need
to get its value.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-subvolume.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 20e2c01..75ecd45 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -939,7 +939,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
 	char *fullpath = NULL, *svpath = NULL, *mnt = NULL;
 	char raw_prefix[] = "\t\t\t\t";
-	u64 sv_id, mntid;
+	u64 sv_id;
 	int fd = -1, mntfd = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL, *dirstream2 = NULL;
@@ -999,12 +999,6 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	ret = btrfs_list_get_path_rootid(mntfd, &mntid);
-	if (ret) {
-		fprintf(stderr, "ERROR: can't get rootid for '%s'\n", mnt);
-		goto out;
-	}
-
 	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
 		printf("%s is btrfs root\n", fullpath);
 		goto out;
-- 
1.8.5.1

