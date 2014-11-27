Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15539 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbaK0CD3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 21:03:29 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAR236Ng010593
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 10:03:06 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: apply realpath for btrfs fi show when mount point is given
Date: Thu, 27 Nov 2014 10:01:35 +0800
Message-ID: <1417053695-14210-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1417053695-14210-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1417053695-14210-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For now,
	# btrfs fi show /mnt/btrfs
gives info correctly, while
	# btrfs fi show /mnt/btrfs/
gives nothing.

This implies that the @realpath() function should be applied to
unify the behavior.

Made a more clear comment right above the call as well.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 60 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index cd6b3c6..4e6d2f6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -901,39 +901,47 @@ static int cmd_show(int argc, char **argv)
 		if (strlen(search) == 0)
 			usage(cmd_show_usage);
 		type = check_arg_type(search);
+
+		/*
+		 * For search is a device:
+		 *     realpath do /dev/mapper/XX => /dev/dm-X
+		 *     which is required by BTRFS_SCAN_DEV
+		 * For search is a mountpoint:
+		 *     realpath do  /mnt/btrfs/  => /mnt/btrfs
+		 *     which shall be recognized by btrfs_scan_kernel()
+		 */
+		if (!realpath(search, path)) {
+			fprintf(stderr, "ERROR: Could not show %s: %s\n",
+					search, strerror(errno));
+			return 1;
+		}
+
+		search = path;
+
 		/*
 		 * needs spl handling if input arg is block dev
 		 * And if input arg is mount-point just print it
 		 * right away
 		 */
-		if (type == BTRFS_ARG_BLKDEV) {
-			if (where == BTRFS_SCAN_LBLKID) {
-				/* we need to do this because
-				 * legacy BTRFS_SCAN_DEV
-				 * provides /dev/dm-x paths
-				 */
-				if (realpath(search, path))
-					search = path;
+		if (type == BTRFS_ARG_BLKDEV && where != BTRFS_SCAN_LBLKID) {
+			ret = get_btrfs_mount(search,
+					mp, sizeof(mp));
+			if (!ret) {
+				/* given block dev is mounted*/
+				search = mp;
+				type = BTRFS_ARG_MNTPOINT;
 			} else {
-				ret = get_btrfs_mount(search,
-						mp, sizeof(mp));
-				if (!ret) {
-					/* given block dev is mounted*/
-					search = mp;
-					type = BTRFS_ARG_MNTPOINT;
-				} else {
-					ret = dev_to_fsid(search, fsid);
-					if (ret) {
-						fprintf(stderr,
-							"ERROR: No btrfs on %s\n",
-							search);
-						return 1;
-					}
-					uuid_unparse(fsid, uuid_buf);
-					search = uuid_buf;
-					type = BTRFS_ARG_UUID;
-					goto devs_only;
+				ret = dev_to_fsid(search, fsid);
+				if (ret) {
+					fprintf(stderr,
+						"ERROR: No btrfs on %s\n",
+						search);
+					return 1;
 				}
+				uuid_unparse(fsid, uuid_buf);
+				search = uuid_buf;
+				type = BTRFS_ARG_UUID;
+				goto devs_only;
 			}
 		}
 	}
-- 
1.8.1.4

