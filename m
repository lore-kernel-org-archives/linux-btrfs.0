Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail4.fujitsu.co.jp ([164.71.1.141]:45472 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbaEPI3j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 04:29:39 -0400
Received: from fgwmail.fujitsu.co.jp (fgwmail.fujitsu.co.jp [164.71.1.133])
	by fgwmail4.fujitsu.co.jp (Postfix) with ESMTP id D2CC6178B0F0
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 17:21:21 +0900 (JST)
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 4B8853EE0EA
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 17:21:10 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 30929AC05FA
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 17:21:09 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D04621DB8047
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 17:21:08 +0900 (JST)
Message-ID: <5375CA68.4090808@jp.fujitsu.com>
Date: Fri, 16 May 2014 17:20:56 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: provide better error message for raid profile
 mismatch
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current error messages are like following:
  Error: unable to create FS with metadata profile 32 (have 2 devices)
  Error: unable to create FS with metadata profile 256 (have 2 devices)

Obviously it is hard for users to interpret "profile XX" to proper
meaning, such as "raidN". So use recongizable string instead of
internal numerical value. In case of "dup", use an explicit message.

Plus this patch fix a bug that message mistake metadata profile
for data profile.

After applying this patch, messages will be like:
  Error: dup is not allowed when FS have multiple devices
  Error: unable to create FS with metadata profile RAID6 (have 2
  devices but 3 devices are required)

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 cmds-filesystem.c |   22 ------------------
 utils.c           |   63 +++++++++++++++++++++++++++++++++++++++++++++++-----
 utils.h           |    1 +
 3 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index bd9ba66..400e8d9 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -134,28 +134,6 @@ static char *group_type_str(u64 flag)
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
index 3e9c527..3f5d328 100644
--- a/utils.c
+++ b/utils.c
@@ -1943,6 +1943,47 @@ out:
 	return ret;
 }
 
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
+
+static int group_profile_devs_min(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0: /* single */
+	case BTRFS_BLOCK_GROUP_DUP:
+		return 1;
+	case BTRFS_BLOCK_GROUP_RAID0:
+	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_RAID5:
+		return 2;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		return 3;
+	case BTRFS_BLOCK_GROUP_RAID10:
+		return 4;
+	default:
+		return -1;
+	}
+}
+
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr)
 {
@@ -1963,16 +2004,26 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
 	}
 
+	if (dev_cnt > 1 &&
+	    ((metadata_profile | data_profile) & BTRFS_BLOCK_GROUP_DUP)) {
+		snprintf(estr, sz,
+			"dup is not allowed when FS have multiple devices\n");
+		return 1;
+	}
 	if (metadata_profile & ~allowed) {
-		snprintf(estr, sz, "unable to create FS with metadata "
-			"profile %llu (have %llu devices)\n",
-			metadata_profile, dev_cnt);
+		snprintf(estr, sz,
+			"unable to create FS with metadata profile %s "
+			"(have %llu devices but %d devices are required)\n",
+			group_profile_str(metadata_profile), dev_cnt,
+			group_profile_devs_min(metadata_profile));
 		return 1;
 	}
 	if (data_profile & ~allowed) {
-		snprintf(estr, sz, "unable to create FS with data "
-			"profile %llu (have %llu devices)\n",
-			metadata_profile, dev_cnt);
+		snprintf(estr, sz,
+			"unable to create FS with data profile %s "
+			"(have %llu devices but %d devices are required)\n",
+			group_profile_str(data_profile), dev_cnt,
+			group_profile_devs_min(data_profile));
 		return 1;
 	}
 
diff --git a/utils.h b/utils.h
index 3c62066..af5dd84 100644
--- a/utils.h
+++ b/utils.h
@@ -88,6 +88,7 @@ u64 btrfs_device_size(int fd, struct stat *st);
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
+char *group_profile_str(u64 flag);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
 int is_vol_small(char *file);
-- 
1.7.1


