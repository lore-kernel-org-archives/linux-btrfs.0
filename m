Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45488 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161500Ab3FUHyD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:54:03 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7li6g023578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:47:45 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s1S2020584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:01 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s1h9020552
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/13] btrfs-progs: move out print in cmd_df to another function
Date: Fri, 21 Jun 2013 15:58:02 +0800
Message-Id: <1371801485-14571-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>

This is a prepatory work for the following btrfs fi show command
fixes. So that we have a function get_df to get the fs sizes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 146 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 79 insertions(+), 67 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 9b7bcf1..ea69328 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -44,71 +44,9 @@ static const char * const cmd_df_usage[] = {
 	NULL
 };
 
-static int cmd_df(int argc, char **argv)
+static void print_df(struct btrfs_ioctl_space_args *sargs)
 {
-	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
-	u64 count = 0, i;
-	int ret;
-	int fd;
-	int e;
-	char *path;
-
-	if (check_argc_exact(argc, 2))
-		usage(cmd_df_usage);
-
-	path = argv[1];
-
-	fd = open_file_or_dir(path);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
-	}
-
-	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
-	if (!sargs)
-		return -ENOMEM;
-
-	sargs->space_slots = 0;
-	sargs->total_spaces = 0;
-
-	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
-	e = errno;
-	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		close(fd);
-		free(sargs);
-		return ret;
-	}
-	if (!sargs->total_spaces) {
-		close(fd);
-		free(sargs);
-		return 0;
-	}
-
-	count = sargs->total_spaces;
-
-	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
-			(count * sizeof(struct btrfs_ioctl_space_info)));
-	if (!sargs) {
-		close(fd);
-		free(sargs_orig);
-		return -ENOMEM;
-	}
-
-	sargs->space_slots = count;
-	sargs->total_spaces = 0;
-
-	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
-	e = errno;
-	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		close(fd);
-		free(sargs);
-		return ret;
-	}
-
+	u64 i;
 	for (i = 0; i < sargs->total_spaces; i++) {
 		char description[80];
 		char *total_bytes;
@@ -160,10 +98,84 @@ static int cmd_df(int argc, char **argv)
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
-	close(fd);
-	free(sargs);
+}
 
-	return 0;
+static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
+{
+	u64 count = 0;
+	int ret, e;
+	struct btrfs_ioctl_space_args *sargs_orig;
+	struct btrfs_ioctl_space_args *sargs;
+
+	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	if (!sargs)
+		return -ENOMEM;
+
+	sargs->space_slots = 0;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e = errno;
+	if (ret) {
+		free(sargs);
+		return -e;
+	}
+	if (!sargs->total_spaces) {
+		free(sargs);
+		return 0;
+	}
+
+	count = sargs->total_spaces;
+
+	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
+			(count * sizeof(struct btrfs_ioctl_space_info)));
+	if (!sargs) {
+		free(sargs_orig);
+		return -ENOMEM;
+	}
+
+	sargs->space_slots = count;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e = errno;
+	if (ret) {
+		free(sargs);
+		return -e;
+	}
+	*sargs_ret = sargs;
+	return ret;
+}
+
+static int cmd_df(int argc, char **argv)
+{
+	struct btrfs_ioctl_space_args *sargs = NULL;
+	int ret;
+	int fd;
+	char *path;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_df_usage);
+
+	path = argv[1];
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+	ret = get_df(fd, &sargs);
+
+	if (!ret) {
+		if (sargs) {
+			print_df(sargs);
+			free(sargs);
+		}
+	} else
+		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(ret));
+
+	close(fd);
+	return ret;
 }
 
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
-- 
1.8.1.227.g44fe835

