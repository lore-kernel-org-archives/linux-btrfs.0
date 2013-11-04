Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32504 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3KDE2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 23:28:30 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA44STRS026556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 04:28:30 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA44SRUd018093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 04:28:29 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA44SR9f018226
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 04:28:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4 v2] btrfs-progs: lblkid wouldn't find non mapper path input
Date: Mon,  4 Nov 2013 12:36:56 +0800
Message-Id: <1383539816-5197-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1383536745-4635-4-git-send-email-anand.jain@oracle.com>
References: <1383536745-4635-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new test case when disk is unmounted and if the non mapper
disk path is given as the argument to the btrfs filesystem show <arg>
we still need this to work but lblkid will pull only mapper disks,
it won't match. So this will normalize the input to find btrfs
by fsid and pass it to the search.

v2: accepts Josef suggested

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f8e8475..f40178a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -37,6 +37,7 @@
 #include "version.h"
 #include "commands.h"
 #include "list_sort.h"
+#include "disk-io.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -414,6 +415,39 @@ static int btrfs_scan_kernel(void *search)
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
@@ -434,6 +468,8 @@ static int cmd_show(int argc, char **argv)
 	int type = 0;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
+	__u8 fsid[BTRFS_FSID_SIZE];
+	char uuid_buf[37];
 
 	while (1) {
 		int long_index;
@@ -466,6 +502,10 @@ static int cmd_show(int argc, char **argv)
 		if (strlen(search) == 0)
 			usage(cmd_show_usage);
 		type = check_arg_type(search);
+		/*needs spl handling if input arg is block dev
+		 *And if input arg is mount-point just print it
+		 *right away
+		*/
 		if (type == BTRFS_ARG_BLKDEV) {
 			if (where == BTRFS_SCAN_DEV) {
 				/* we need to do this because
@@ -477,14 +517,25 @@ static int cmd_show(int argc, char **argv)
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
-		}
-		if (type == BTRFS_ARG_MNTPOINT) {
+		} else if (type == BTRFS_ARG_MNTPOINT) {
 			char label[BTRFS_LABEL_SIZE];
 			if (get_label_mounted(search, label))
 				return 1;
-- 
1.7.1

