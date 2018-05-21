Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43518 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbeEUGfV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 02:35:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4L6VY9c114371
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:21 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2j2bcdavyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4L6ZKWR010293
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:20 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4L6ZJWP016987
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:35:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: add helper function describe_block_group()
Date: Mon, 21 May 2018 14:37:43 +0800
Message-Id: <20180521063745.29343-2-anand.jain@oracle.com>
In-Reply-To: <20180521063745.29343-1-anand.jain@oracle.com>
References: <20180521063745.29343-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Improve on describe_relocation() add a common helper function to describe
the block groups.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: Born.

 fs/btrfs/relocation.c | 30 +++---------------------------
 fs/btrfs/volumes.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h    |  1 +
 3 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..b9b32b0e4ba4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4320,37 +4320,13 @@ static struct reloc_control *alloc_reloc_control(void)
 static void describe_relocation(struct btrfs_fs_info *fs_info,
 				struct btrfs_block_group_cache *block_group)
 {
-	char buf[128];		/* prefixed by a '|' that'll be dropped */
-	u64 flags = block_group->flags;
+	char buf[128];
 
-	/* Shouldn't happen */
-	if (!flags) {
-		strcpy(buf, "|NONE");
-	} else {
-		char *bp = buf;
-
-#define DESCRIBE_FLAG(f, d) \
-		if (flags & BTRFS_BLOCK_GROUP_##f) { \
-			bp += snprintf(bp, buf - bp + sizeof(buf), "|%s", d); \
-			flags &= ~BTRFS_BLOCK_GROUP_##f; \
-		}
-		DESCRIBE_FLAG(DATA,     "data");
-		DESCRIBE_FLAG(SYSTEM,   "system");
-		DESCRIBE_FLAG(METADATA, "metadata");
-		DESCRIBE_FLAG(RAID0,    "raid0");
-		DESCRIBE_FLAG(RAID1,    "raid1");
-		DESCRIBE_FLAG(DUP,      "dup");
-		DESCRIBE_FLAG(RAID10,   "raid10");
-		DESCRIBE_FLAG(RAID5,    "raid5");
-		DESCRIBE_FLAG(RAID6,    "raid6");
-		if (flags)
-			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);
-#undef DESCRIBE_FLAG
-	}
+	describe_block_groups(block_group->flags, buf, sizeof(buf));
 
 	btrfs_info(fs_info,
 		   "relocating block group %llu flags %s",
-		   block_group->key.objectid, buf + 1);
+		   block_group->key.objectid, buf);
 }
 
 /*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 43bd65395106..02b1d14f510d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -126,6 +126,50 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
+u32 describe_block_groups(u64 bg_flags, char *describe, u32 sz)
+{
+	int i;
+	u32 ret;
+	char *dp = describe;
+	u64 flags = bg_flags;
+
+	if (!flags)
+		return snprintf(dp, sz, "%s", "NONE");
+
+#define DESCRIBE_FLAG(f, d) \
+	do { \
+		if (flags & BTRFS_BLOCK_GROUP_##f) { \
+			dp += snprintf(dp, describe - dp + sz, "%s|", d); \
+			flags &= ~BTRFS_BLOCK_GROUP_##f; \
+		} \
+	} while (0)
+	DESCRIBE_FLAG(DATA,     "data");
+	DESCRIBE_FLAG(SYSTEM,   "system");
+	DESCRIBE_FLAG(METADATA, "metadata");
+#undef DESCRIBE_FLAG
+
+	if (flags & BTRFS_AVAIL_ALLOC_BIT_SINGLE) {
+		dp += snprintf(dp, describe - dp + sz,
+			       "%s|", "single");
+		flags &= ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
+	}
+
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		if (flags & btrfs_raid_array[i].bg_flag) {
+			dp += snprintf(dp, describe - dp + sz,
+				       "%s|", btrfs_raid_array[i].raid_name);
+			flags &= ~btrfs_raid_array[i].bg_flag;
+		}
+	}
+
+	if (flags)
+		dp += snprintf(dp, describe - dp + sz, "0x%llx|", flags);
+
+	ret = dp - describe - 1;
+	describe[ret] = '\0'; /* remove last | */
+	return ret;
+}
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..52ac258daa17 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -433,6 +433,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
 		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
+u32 describe_block_groups(u64 flags, char *describe, u32 sz);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
-- 
2.7.0

