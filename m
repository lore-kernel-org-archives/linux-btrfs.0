Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52004 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQUM6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:12:58 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so46300wiv.8
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:12:57 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/8] Move group_profile_str() in utils.c
Date: Wed, 17 Dec 2014 21:14:06 +0100
Message-Id: <1418847252-14184-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a preparation patch.
Move the group_profile_str() function from cmds-filesystem.c to utils.c
to be re-used from other modules (in this case from mkfs.c)

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-filesystem.c | 22 ----------------------
 utils.c           | 22 ++++++++++++++++++++++
 utils.h           |  2 ++
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 253f105..d1afeba 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -157,28 +157,6 @@ static char *group_type_str(u64 flag)
 	}
 }
 
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
index 2a92416..19049bb 100644
--- a/utils.c
+++ b/utils.c
@@ -2450,3 +2450,25 @@ int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
 	}
 	return 1;
 }
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
index 289e86b..bb8a449 100644
--- a/utils.h
+++ b/utils.h
@@ -161,4 +161,6 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 
+char *group_profile_str(u64 flag);
+
 #endif
-- 
2.1.3

