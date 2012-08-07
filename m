Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24254 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2HGI6q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 04:58:46 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q778wj4L004533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:58:45 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q778wiTT009563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 08:58:45 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q778wi1t026324
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Aug 2012 03:58:44 -0500
Message-ID: <5020D899.4070301@oracle.com>
Date: Tue, 07 Aug 2012 16:58:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 5/5] btrfs-progs: let this feature works at subvolume
 command group.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <5020D84E.4010900@oracle.com>

make this feature works as `btrfs subvolume diff-snapshot [options] <src> <dest>`.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 cmds-subvolume.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3508ce6..e7cc3cc 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -28,6 +28,7 @@
 #include "ioctl.h"
 
 #include "commands.h"
+#include "diff-snapshot.h"
 
 /* btrfs-list.c */
 int list_subvols(int fd, int print_parent, int get_default);
@@ -515,6 +516,94 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_snapshot_diff_usage[] = {
+	"btrfs subvolume diff-snapshot [options] <source> <dest>",
+	"List the differences between two snapshots",
+	"By default, list all changes in destination snapshot towards source",
+	"",
+	"-n	list the new items in destination snapshot\n",
+	"-r	list the removed items in destination snapshot\n",
+	"-u	list the updated items in destination snapshot\n",
+	NULL
+};
+
+static int cmd_snapshot_diff(int argc, char **argv)
+{
+	int ret;
+	int src_fd;
+	int dst_fd;
+	char *src_snapshot;
+	char *dest_snapshot;
+	unsigned int flags = 0;
+
+	while (1) {
+		int c = getopt(argc, argv, "rnu");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'r':
+			flags |= SNAPSHOT_DIFF_LIST_REMOVED_ITEM;
+			break;
+		case 'n':
+			flags |= SNAPSHOT_DIFF_LIST_NEW_ITEM;
+			break;
+		case 'u':
+			flags |= SNAPSHOT_DIFF_LIST_UPDATED_ITEM;
+			break;
+		default:
+			fprintf(stderr, "ERROR: snapshot diff args invalid.\n"
+					" -r  list removed items\n"
+					" -n  list new items\n"
+					" -u  list updated items\n");
+			return 1;
+		}
+	}
+
+	src_snapshot = argv[argc - 2];
+	dest_snapshot = argv[argc - 1];
+
+	ret = test_issubvolume(src_snapshot);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n",
+			src_snapshot);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
+			src_snapshot);
+		return 13;
+	}
+
+	ret = test_issubvolume(dest_snapshot);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n",
+			dest_snapshot);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
+			dest_snapshot);
+		return 13;
+	}
+
+	src_fd = open_file_or_dir(src_snapshot);
+	if (src_fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", src_snapshot);
+		return 12;
+	}
+
+	dst_fd = open_file_or_dir(dest_snapshot);
+	if (dst_fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", dest_snapshot);
+		return 12;
+	}
+
+	ret = snapshot_diff(src_fd, dst_fd, src_snapshot, dest_snapshot, flags);
+	if (ret)
+		return 19;
+	return 0;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -526,6 +615,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "set-default", cmd_subvol_set_default,
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
+		{ "diff-snapshot", cmd_snapshot_diff, cmd_snapshot_diff_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
-- 
1.7.4.1
