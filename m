Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3GOF0T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:19 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 10/11] btrfs-progs: get string for the group profile and type
Date: Mon, 15 Jul 2013 13:30:56 +0800
Message-Id: <1373866257-10519-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

Code can be well reused and this is the prepatory work
for the patch following this.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   83 ++++++++++++++++++++++++++++++----------------------
 ctree.h           |   11 +++++++
 2 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1e105b..5225db0 100644
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
 static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 {
 	u64 count = 0;
@@ -94,45 +132,20 @@ static void print_df(struct btrfs_ioctl_space_args *sargs)
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
 
 		total_bytes = pretty_size(sargs->spaces[i].total_bytes);
 		used_bytes = pretty_size(sargs->spaces[i].used_bytes);
diff --git a/ctree.h b/ctree.h
index e0decb9..1ad62bc 100644
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
1.7.7.6

