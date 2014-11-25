Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56206 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaKYP5h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:57:37 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so9596384wiw.14
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 07:57:36 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/4] Move group_type_str() and group_profile_str().
Date: Tue, 25 Nov 2014 16:57:22 +0100
Message-Id: <1416931045-24259-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move group_type_str() and group_profile_str() functions to the
util.c file, because these are now used also by the command
'btrfs chunk list'.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-filesystem.c | 43 -------------------------------------------
 utils.c           | 43 +++++++++++++++++++++++++++++++++++++++++++
 utils.h           |  3 +++
 3 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index cd6b3c6..269e758 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -136,49 +136,6 @@ static const char * const cmd_df_usage[] = {
        NULL
 };
 
-static char *group_type_str(u64 flag)
-{
-	u64 mask = BTRFS_BLOCK_GROUP_TYPE_MASK |
-		BTRFS_SPACE_INFO_GLOBAL_RSV;
-
-	switch (flag & mask) {
-	case BTRFS_BLOCK_GROUP_DATA:
-		return "Data";
-	case BTRFS_BLOCK_GROUP_SYSTEM:
-		return "System";
-	case BTRFS_BLOCK_GROUP_METADATA:
-		return "Metadata";
-	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
-		return "Data+Metadata";
-	case BTRFS_SPACE_INFO_GLOBAL_RSV:
-		return "GlobalReserve";
-	default:
-		return "unknown";
-	}
-}
-
-static char *group_profile_str(u64 flag)
-{
-	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
-	case 0:
-		return "single";
-	case BTRFS_BLOCK_GROUP_RAID0:
-		return "RAID0";
-	case BTRFS_BLOCK_GROUP_RAID1:
-		return "RAID1";
-	case BTRFS_BLOCK_GROUP_RAID5:
-		return "RAID5";
-	case BTRFS_BLOCK_GROUP_RAID6:
-		return "RAID6";
-	case BTRFS_BLOCK_GROUP_DUP:
-		return "DUP";
-	case BTRFS_BLOCK_GROUP_RAID10:
-		return "RAID10";
-	default:
-		return "unknown";
-	}
-}
-
 static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
 {
 	u64 count = 0;
diff --git a/utils.c b/utils.c
index 2a92416..c9b9e0e 100644
--- a/utils.c
+++ b/utils.c
@@ -2450,3 +2450,46 @@ int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
 	}
 	return 1;
 }
+
+char *group_type_str(u64 flag)
+{
+	u64 mask = BTRFS_BLOCK_GROUP_TYPE_MASK |
+		BTRFS_SPACE_INFO_GLOBAL_RSV;
+
+	switch (flag & mask) {
+	case BTRFS_BLOCK_GROUP_DATA:
+		return "Data";
+	case BTRFS_BLOCK_GROUP_SYSTEM:
+		return "System";
+	case BTRFS_BLOCK_GROUP_METADATA:
+		return "Metadata";
+	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
+		return "Data+Metadata";
+	case BTRFS_SPACE_INFO_GLOBAL_RSV:
+		return "GlobalReserve";
+	default:
+		return "unknown";
+	}
+}
+
+char *group_profile_str(u64 flag)
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
diff --git a/utils.h b/utils.h
index 289e86b..21e3e83 100644
--- a/utils.h
+++ b/utils.h
@@ -161,4 +161,7 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 
+char *group_type_str(u64 flag);
+char *group_profile_str(u64 flag);
+
 #endif
-- 
2.1.3

