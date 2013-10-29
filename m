Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37086 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3J2Q0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 12:26:36 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9TGQZpG010809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 16:26:36 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9TGQYCK022881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 16:26:35 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9TGQYm7022877
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 16:26:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: lblkid wouldn't find non mapper path input
Date: Wed, 30 Oct 2013 00:34:50 +0800
Message-Id: <1383064490-28875-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new test case when disk is unmounted and if the non mapper
disk path is given as the argument to the btrfs filesystem show <arg>
we still need this to work but lblkid will pull only mapper disks,
it won't match. So this will normalize the input to find btrfs
by fsid and pass it to the search.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index fcabdb0..3a494fd 100644
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
@@ -480,11 +516,21 @@ static int cmd_show(int argc, char **argv)
 				if (!ret)
 					/* given block dev is mounted*/
 					search = mp;
-				else
+				else {
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

