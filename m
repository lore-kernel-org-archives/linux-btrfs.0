Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754040AbeEWGcl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 02:32:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4N6Q2wi146476
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2j4nh7tg90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4N6WdZ5008866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:40 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4N6WdHe015683
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 06:32:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/3] btrfs: add helper function describe_block_group()
Date: Wed, 23 May 2018 14:35:06 +0800
Message-Id: <20180523063508.18695-2-anand.jain@oracle.com>
In-Reply-To: <20180523063508.18695-1-anand.jain@oracle.com>
References: <20180523063508.18695-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Improve on describe_relocation() add a common helper function to describe
the block groups.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3->v4: Just pass full flag name in the define DESCRIBE_FLAG(flag,..),
	 so that it can be used at couple of more places.
	Rename describe_block_groups() to btrfs_describe_block_groups().
	Drop useless return u32.
v3:	Born.

 fs/btrfs/relocation.c | 30 +++---------------------------
 fs/btrfs/volumes.c    | 36 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h    |  1 +
 3 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 879b76fa881a..0434cebc2ea2 100644
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
+	btrfs_describe_block_groups(block_group->flags, buf, sizeof(buf));
 
 	btrfs_info(fs_info,
 		   "relocating block group %llu flags %s",
-		   block_group->key.objectid, buf + 1);
+		   block_group->key.objectid, buf);
 }
 
 /*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b6757b53c297..44f4799bf06f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -126,6 +126,42 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
+void btrfs_describe_block_groups(u64 bg_flags, char *buf, u32 size_buf)
+{
+	int i;
+	u32 ret;
+	char *bp = buf;
+	u64 flags = bg_flags;
+
+	if (!flags) {
+		snprintf(bp, size_buf, "%s", "NONE");
+		return;
+	}
+
+#define DESCRIBE_FLAG(f, d) \
+	do { \
+		if (flags & f) { \
+			bp += snprintf(bp, buf - bp + size_buf, "%s|", d); \
+			flags &= ~f; \
+		} \
+	} while (0)
+
+	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_DATA, "data");
+	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_SYSTEM, "system");
+	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_METADATA, "metadata");
+	DESCRIBE_FLAG(BTRFS_AVAIL_ALLOC_BIT_SINGLE, "single");
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+		DESCRIBE_FLAG(btrfs_raid_array[i].bg_flag,
+			      btrfs_raid_array[i].raid_name);
+#undef DESCRIBE_FLAG
+
+	if (flags)
+		bp += snprintf(bp, buf - bp + size_buf, "0x%llx|", flags);
+
+	ret = bp - buf - 1;
+	buf[ret] = '\0'; /* remove last | */
+}
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..5b9637a3ed48 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -433,6 +433,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
 		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
+void btrfs_describe_block_groups(u64 flags, char *buf, u32 size_buf);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
-- 
2.7.0

