Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25885 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933870Ab3HHIBT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:01:19 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7881ICj004253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:01:19 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7881HOX005765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:01:18 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7881HRk011488
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:01:17 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: move out print in cmd_df to another function
Date: Thu,  8 Aug 2013 16:07:06 +0800
Message-Id: <1375949227-23729-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375949227-23729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1375949227-23729-1-git-send-email-anand.jain@oracle.com>

This is a prepatory work for the following btrfs fi show command
fixes. So that we have a function get_df to get the fs sizes

v2:
combined the other patches as below and rebase
 btrfs-progs: get string for the group profile and type

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 190 +++++++++++++++++++++++++++++++-----------------------
 ctree.h           |  11 ++++
 2 files changed, 122 insertions(+), 79 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a4e30ea..be8afde 100644
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
+
+static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
+{
+	u64 count = 0;
+	int ret, e;
+	struct btrfs_ioctl_space_args *sargs;
 
-	sargs_orig = sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
 	if (!sargs)
 		return -ENOMEM;
 
@@ -75,89 +98,98 @@ static int cmd_df(int argc, char **argv)
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
+static void print_df(struct btrfs_ioctl_space_args *sargs)
+{
+	char description[80];
+	char *total_bytes;
+	char *used_bytes;
+	u64 flags;
+	u64 i;
+	int written;
+	char g_str[64];
+	int g_sz;
 
+	for (i = 0; i < sargs->total_spaces; i++) {
+		flags = sargs->spaces[i].flags;
+		written = 0;
 		memset(description, 0, 80);
 
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
+		strcpy(g_str, group_type_str(flags));
+		g_sz = strlen(g_str);
+		snprintf(description, g_sz + 1, "%s", g_str);
+		written += g_sz;
 
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
+		strcpy(g_str, group_profile_str(flags));
+		g_sz = strlen(g_str);
+		snprintf(description+written, g_sz + 3, ", %s", g_str);
+		written += g_sz + 2;
 
-		printf("%s: total=%s, used=%s\n", description,
-			pretty_size(sargs->spaces[i].total_bytes),
-			pretty_size(sargs->spaces[i].used_bytes));
+		total_bytes = pretty_size(sargs->spaces[i].total_bytes);
+		used_bytes = pretty_size(sargs->spaces[i].used_bytes);
+		printf("%s: total=%s, used=%s\n", description, total_bytes,
+		       used_bytes);
 	}
-out:
-	close_file_or_dir(fd, dirstream);
-	free(sargs);
+}
 
-	return 0;
+static int cmd_df(int argc, char **argv)
+{
+	struct btrfs_ioctl_space_args *sargs = NULL;
+	int ret;
+	int fd;
+	char *path;
+	DIR  *dirstream = NULL;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_df_usage);
+
+	path = argv[1];
+
+	fd = open_file_or_dir(path, &dirstream);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+	ret = get_df(fd, &sargs);
+
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
index 257396d..21bfa30 100644
--- a/ctree.h
+++ b/ctree.h
@@ -826,6 +826,17 @@ struct btrfs_csum_item {
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
1.8.1.191.g414c78c

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
