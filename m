Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23849 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423007Ab3FUHyE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:54:04 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7s3l0017668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:03 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s2Bp020697
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:03 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s27G018426
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:02 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/13] btrfs-progs: get string for the group profile and type
Date: Fri, 21 Jun 2013 15:58:03 +0800
Message-Id: <1371801485-14571-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>

Code can be well reused and this is the prepatory work
for the patch following this.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 83 ++++++++++++++++++++++++++++++++-----------------------
 ctree.h           | 11 ++++++++
 2 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index ea69328..5f8c258 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -38,6 +38,44 @@ static const char * const filesystem_cmd_group_usage[] = {
 	NULL
 };
 
+static char * group_type_str(u64 flag)
+{
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
+
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
+	}
+}
+
 static const char * const cmd_df_usage[] = {
 	"btrfs filesystem df <path>",
 	"Show space usage information for a mount point",
@@ -53,45 +91,20 @@ static void print_df(struct btrfs_ioctl_space_args *sargs)
 		char *used_bytes;
 		int written = 0;
 		u64 flags = sargs->spaces[i].flags;
+		char g_str[64];
+		int g_sz;
 
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
 
 		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
 		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
diff --git a/ctree.h b/ctree.h
index 0af7477..6e4a954 100644
--- a/ctree.h
+++ b/ctree.h
@@ -823,6 +823,17 @@ struct btrfs_csum_item {
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
1.8.1.227.g44fe835

