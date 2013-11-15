Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25515 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3KOLQx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 06:16:53 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jbacik@fusionio.com
Subject: [PATCH v4 3/3] btrfs-progs: lblkid wouldn't find non mapper path input
Date: Fri, 15 Nov 2013 19:25:35 +0800
Message-Id: <1384514735-24761-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1384514735-24761-1-git-send-email-anand.jain@oracle.com>
References: <1384514735-24761-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new test case when disk is unmounted and if the non mapper
disk path is given as the argument to the btrfs filesystem show <arg>
we still need this to work but lblkid will pull only mapper disks,
it won't match. So this will normalize the input to find btrfs
by fsid and pass it to the search.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---

v4: rebased on integration-20131114
v3: accepts Josef suggested again
v2: accepts Josef suggested

 cmds-filesystem.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b23d337..c98425f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -37,6 +37,7 @@
 #include "version.h"
 #include "commands.h"
 #include "list_sort.h"
+#include "disk-io.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -416,6 +417,39 @@ static int btrfs_scan_kernel(void *search)
 	return 0;
 }
 
+static int dev_to_fsid(char *dev, __u8 *fsid)
+{
+	struct btrfs_super_block *disk_super;
+	char *buf;
+	int ret;
+	int fd;
+
+	buf = malloc(4096);
+	if (!buf)
+		return -ENOMEM;
+
+	fd = open(dev, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		free(buf);
+		return ret;
+	}
+
+	disk_super = (struct btrfs_super_block *)buf;
+	ret = btrfs_read_dev_super(fd, disk_super,
+			BTRFS_SUPER_INFO_OFFSET);
+	if (ret)
+		goto out;
+
+	memcpy(fsid, disk_super->fsid, BTRFS_FSID_SIZE);
+	ret = 0;
+
+out:
+	close(fd);
+	free(buf);
+	return ret;
+}
+
 static const char * const cmd_show_usage[] = {
 	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
 	"Show the structure of a filesystem",
@@ -436,6 +470,8 @@ static int cmd_show(int argc, char **argv)
 	int type = 0;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
+	__u8 fsid[BTRFS_FSID_SIZE];
+	char uuid_buf[37];
 
 	while (1) {
 		int long_index;
@@ -468,6 +504,11 @@ static int cmd_show(int argc, char **argv)
 		if (strlen(search) == 0)
 			usage(cmd_show_usage);
 		type = check_arg_type(search);
+		/*
+		 * needs spl handling if input arg is block dev
+		 * And if input arg is mount-point just print it
+		 * right away
+		 */
 		if (type == BTRFS_ARG_BLKDEV) {
 			if (where == BTRFS_SCAN_DEV) {
 				/* we need to do this because
@@ -479,11 +520,23 @@ static int cmd_show(int argc, char **argv)
 			} else {
 				ret = get_btrfs_mount(search,
 						mp, sizeof(mp));
-				if (!ret)
+				if (!ret) {
 					/* given block dev is mounted*/
 					search = mp;
-				else
+					type = BTRFS_ARG_MNTPOINT;
+				} else {
+					ret = dev_to_fsid(search, fsid);
+					if (ret) {
+						fprintf(stderr,
+							"ERROR: No btrfs on %s\n",
+							search);
+						return 1;
+					}
+					uuid_unparse(fsid, uuid_buf);
+					search = uuid_buf;
+					type = BTRFS_ARG_UUID;
 					goto devs_only;
+				}
 			}
 		} else if (type == BTRFS_ARG_MNTPOINT) {
 			char label[BTRFS_LABEL_SIZE];
-- 
1.7.1

