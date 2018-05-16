Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52564 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752412AbeEPCtG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 22:49:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G2kwWN069824
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hxpvcsfh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:05 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4G2n4XS029717
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:04 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4G2n4Ah004634
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 02:49:04 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: balance: add args info during start and resume
Date: Wed, 16 May 2018 10:51:27 +0800
Message-Id: <20180516025128.9899-3-anand.jain@oracle.com>
In-Reply-To: <20180516025128.9899-1-anand.jain@oracle.com>
References: <20180516025128.9899-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance args info is an important information to be reviewed for the
system audit. So this patch adds it to the kernel log.

Example:

-> btrfs bal start -dprofiles='raid1|single',convert=raid5 -mprofiles='raid1|single',convert=raid5 /btrfs

 kernel: BTRFS info (device sdb): balance: start data profiles=raid1|single convert=raid5 metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5

-> btrfs bal start -dprofiles=raid5,convert=single -mprofiles='raid1|single',convert=raid5 --background /btrfs

 kernel: BTRFS info (device sdb): balance: start data profiles=raid5 convert=single metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Change log update.
        Move adding the logs for balance complete and end to a new patch

 fs/btrfs/volumes.c | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 143 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 27da66c47ef2..ce68c4f42f94 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -126,6 +126,32 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
+static void get_all_raid_names(u64 bg_flags, char *raid_types)
+{
+	int i;
+	bool found = false;
+
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		if (bg_flags & btrfs_raid_array[i].bg_flag) {
+			if (found) {
+				strcat(raid_types, "|");
+				strcat(raid_types, btrfs_raid_array[i].raid_name);
+			} else {
+				found = true;
+				sprintf(raid_types, "%s", btrfs_raid_array[i].raid_name);
+			}
+		}
+	}
+	if (bg_flags & BTRFS_AVAIL_ALLOC_BIT_SINGLE) {
+		if (found) {
+			strcat(raid_types, "|");
+			strcat(raid_types, "single");
+		} else {
+			sprintf(raid_types, "%s", "single");
+		}
+	}
+}
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
@@ -3766,6 +3792,121 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
 		 (bctl_arg->target & ~allowed)));
 }
 
+static void get_balance_args(struct btrfs_balance_args *bargs, char *args)
+{
+	char value[64];
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_PROFILES) {
+		strcat(args, "profiles=");
+		get_all_raid_names(bargs->profiles, value);
+		strcat(args, value);
+		strcat(args, " ");
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
+		snprintf(value, 64, "usage=%llu ", bargs->usage);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
+		snprintf(value, 64, "usage_min=%u usage_max=%u ",
+			bargs->usage_min, bargs->usage_max);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_DEVID) {
+		snprintf(value, 64, "devid=%llu ", bargs->devid);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_DRANGE) {
+		snprintf(value, 64, "pstart=%llu pend=%llu ",
+			 bargs->pstart, bargs->pend);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_VRANGE) {
+		snprintf(value, 64, "vstart=%llu vend %llu ",
+			 bargs->vstart, bargs->vend);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_LIMIT) {
+		snprintf(value, 64, "limit=%llu ", bargs->limit);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE) {
+		snprintf(value, 64, "limit_min=%u limit_max=%u ",
+			 bargs->limit_min, bargs->limit_max);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE) {
+		snprintf(value, 64, "stripes_min=%u stripes_max=%u ",
+			 bargs->stripes_min, bargs->stripes_max);
+		strcat(args, value);
+	}
+
+	if (bargs->flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		int index = btrfs_bg_flags_to_raid_index(bargs->target);
+		snprintf(value, 64, "convert=%s ",
+			 get_raid_name(index));
+		strcat(args, value);
+	}
+
+	/* If space was the last char remove it */
+	if (strlen(args) && (args[strlen(args) - 1] == ' '))
+		args[strlen(args) - 1] = '\0';
+}
+
+static void print_balance_start_or_resume(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
+	int log_size = 1024;
+	char *args;
+
+	args = kzalloc(log_size, GFP_KERNEL);
+	if (!args) {
+		btrfs_warn(fs_info, "balance: failed to log: ENOMEM");
+		return;
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_ARGS_SOFT) {
+		strcat(args, "soft ");
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_FORCE) {
+		strcat(args, "force ");
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_DATA) {
+		strcat(args, "data ");
+		get_balance_args(&bctl->data, args);
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_METADATA) {
+		if (strlen(args) > 0)
+			strcat(args, " ");
+		strcat(args, "metadata ");
+		get_balance_args(&bctl->meta, args);
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
+		if (strlen(args) > 0)
+			strcat(args, " ");
+		strcat(args, "system ");
+		get_balance_args(&bctl->sys, args);
+	}
+
+	BUG_ON(strlen(args) > log_size);
+	btrfs_info(fs_info, "%s %s",
+		   bctl->flags & BTRFS_BALANCE_RESUME ?\
+		   "balance: resume":"balance: start", args);
+
+	kfree(args);
+}
+
 /*
  * Should be called with balance mutexe held
  */
@@ -3906,6 +4047,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 
 	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
 	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
+	print_balance_start_or_resume(fs_info);
 	mutex_unlock(&fs_info->balance_mutex);
 
 	ret = __btrfs_balance(fs_info);
@@ -3943,10 +4085,8 @@ static int balance_kthread(void *data)
 	int ret = 0;
 
 	mutex_lock(&fs_info->balance_mutex);
-	if (fs_info->balance_ctl) {
-		btrfs_info(fs_info, "balance: resuming");
+	if (fs_info->balance_ctl)
 		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
-	}
 	mutex_unlock(&fs_info->balance_mutex);
 
 	return ret;
-- 
2.7.0

