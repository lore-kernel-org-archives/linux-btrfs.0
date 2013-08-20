Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28884 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3HTGJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 02:09:46 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7K69iVk006172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 06:09:45 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7K69iWp028083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 06:09:44 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7K69hG9001617
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 06:09:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: v3, move out print in cmd_df to another function
Date: Tue, 20 Aug 2013 14:16:01 +0800
Message-Id: <1376979361-2971-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376657303-14931-2-git-send-email-anand.jain@oracle.com>
References: <1376657303-14931-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a prepatory work for the following btrfs fi show command
fixes. So that we have a function get_df to get the fs sizes

v3:
 accepts Zach review comments
v2:
combined the other patches as below and rebase
 btrfs-progs: get string for the group profile and type

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |  181 ++++++++++++++++++++++++++++------------------------
 ctree.h           |   11 +++
 2 files changed, 108 insertions(+), 84 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a4e30ea..d06de35 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -44,28 +44,51 @@ static const char * const cmd_df_usage[] = {
 	NULL
 };
 
-static int cmd_df(int argc, char **argv)
+static char * group_type_str(u64 flag)
 {
-	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
-	u64 count = 0, i;
-	int ret;
-	int fd;
-	int e;
-	char *path;
-	DIR  *dirstream = NULL;
-
-	if (check_argc_exact(argc, 2))
-		usage(cmd_df_usage);
-
-	path = argv[1];
+	switch (flag & BTRFS_BLOCK_GROUP_TYPE_MASK) {
+	case BTRFS_BLOCK_GROUP_DATA:
+		return "data";
+	case BTRFS_BLOCK_GROUP_SYSTEM:
+		return "system";
+	case BTRFS_BLOCK_GROUP_METADATA:
+		return "metadata";
+	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
+		return "mixed";
+	default:
+		return "unknown";
+	}
+}
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
+static char * group_profile_str(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0:
+		return "single";
+	case BTRFS_BLOCK_GROUP_RAID0:
+		return "RAID0";
+	case BTRFS_BLOCK_GROUP_RAID1:
+		return "RAID1";
+	case BTRFS_BLOCK_GROUP_RAID5:
+		return "RAID5";
+	case BTRFS_BLOCK_GROUP_RAID6:
+		return "RAID6";
+	case BTRFS_BLOCK_GROUP_DUP:
+		return "DUP";
+	case BTRFS_BLOCK_GROUP_RAID10:
+		return "RAID10";
+	default:
+		return "unknown";
 	}
+}
 
-	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
+{
+	u64 count = 0;
+	int ret, e;
+	struct btrfs_ioctl_space_args *sargs;
+
+	sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
 	if (!sargs)
 		return -ENOMEM;
 
@@ -75,89 +98,79 @@ static int cmd_df(int argc, char **argv)
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	e = errno;
 	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		goto out;
+		fprintf(stderr, "ERROR: couldn't get space info - %s\n",
+			strerror(e));
+		free(sargs);
+		return ret;
 	}
 	if (!sargs->total_spaces) {
-		ret = 0;
-		goto out;
+		free(sargs);
+		return 0;
 	}
-
 	count = sargs->total_spaces;
+	free(sargs);
 
-	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
+	sargs = malloc(sizeof(struct btrfs_ioctl_space_args) +
 			(count * sizeof(struct btrfs_ioctl_space_info)));
-	if (!sargs) {
-		sargs = sargs_orig;
+	if (!sargs)
 		ret = -ENOMEM;
-		goto out;
-	}
 
 	sargs->space_slots = count;
 	sargs->total_spaces = 0;
-
 	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
 	e = errno;
 	if (ret) {
-		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
-		goto out;
+		fprintf(stderr, "ERROR: get space info count %llu - %s\n",
+				count, strerror(e));
+		free(sargs);
+		return ret;
 	}
+	*sargs_ret = sargs;
+	return 0;
+}
 
-	for (i = 0; i < sargs->total_spaces; i++) {
-		char description[80];
-		int written = 0;
-		u64 flags = sargs->spaces[i].flags;
-
-		memset(description, 0, 80);
-
-		if (flags & BTRFS_BLOCK_GROUP_DATA) {
-			if (flags & BTRFS_BLOCK_GROUP_METADATA) {
-				snprintf(description, 14, "%s",
-					 "Data+Metadata");
-				written += 13;
-			} else {
-				snprintf(description, 5, "%s", "Data");
-				written += 4;
-			}
-		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-			snprintf(description, 7, "%s", "System");
-			written += 6;
-		} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
-			snprintf(description, 9, "%s", "Metadata");
-			written += 8;
-		}
+static void print_df(struct btrfs_ioctl_space_args *sargs)
+{
+	u64 i;
+	struct btrfs_ioctl_space_info *sp = sargs->spaces;
+
+	for (i = 0; i < sargs->total_spaces; i++, sp++) {
+		printf("%s, %s: total=%s, used=%s\n",
+			group_type_str(sp->flags),
+			group_profile_str(sp->flags),
+			pretty_size(sp->total_bytes),
+			pretty_size(sp->used_bytes));
+	}
+}
 
-		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
-			snprintf(description+written, 8, "%s", ", RAID0");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
-			snprintf(description+written, 8, "%s", ", RAID1");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
-			snprintf(description+written, 6, "%s", ", DUP");
-			written += 5;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
-			snprintf(description+written, 9, "%s", ", RAID10");
-			written += 8;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID5) {
-			snprintf(description+written, 9, "%s", ", RAID5");
-			written += 7;
-		} else if (flags & BTRFS_BLOCK_GROUP_RAID6) {
-			snprintf(description+written, 9, "%s", ", RAID6");
-			written += 7;
-		}
+static int cmd_df(int argc, char **argv)
+{
+	struct btrfs_ioctl_space_args *sargs = NULL;
+	int ret;
+	int fd;
+	char *path;
+	DIR  *dirstream = NULL;
 
-		printf("%s: total=%s, used=%s\n", description,
-			pretty_size(sargs->spaces[i].total_bytes),
-			pretty_size(sargs->spaces[i].used_bytes));
+	if (check_argc_exact(argc, 2))
+		usage(cmd_df_usage);
+
+	path = argv[1];
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
 	}
-out:
-	close_file_or_dir(fd, dirstream);
-	free(sargs);
+	ret = get_df(fd, &sargs);
 
-	return 0;
+	if (!ret && sargs) {
+		print_df(sargs);
+		free(sargs);
+	} else
+		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(ret));
+
+	close_file_or_dir(fd, dirstream);
+	return ret;
 }
 
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
diff --git a/ctree.h b/ctree.h
index 3c65d0a..3322c68 100644
--- a/ctree.h
+++ b/ctree.h
@@ -828,6 +828,17 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID6    (1ULL << 8)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 
+#define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
+					 BTRFS_BLOCK_GROUP_SYSTEM |  \
+					 BTRFS_BLOCK_GROUP_METADATA)
+
+#define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
+					 BTRFS_BLOCK_GROUP_RAID1 |   \
+					 BTRFS_BLOCK_GROUP_RAID5 |   \
+					 BTRFS_BLOCK_GROUP_RAID6 |   \
+					 BTRFS_BLOCK_GROUP_DUP |     \
+					 BTRFS_BLOCK_GROUP_RAID10)
+
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
-- 
1.7.1

