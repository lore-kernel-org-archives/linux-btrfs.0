Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:15775 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbeEOHcG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:32:06 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E8416AC0235
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:32:01 +0900 (JST)
Received: from G01JPEXCHYT14.g01.fujitsu.local (G01JPEXCHYT14.g01.fujitsu.local [10.128.194.53])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 390EF46E777
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:32:01 +0900 (JST)
Subject: [PATCH 1/2] btrfs: sysfs: Use enum/define value intead of magic
 number
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
Message-ID: <c480bd4e-ae0c-0db1-30d9-1dd71b476bb0@jp.fujitsu.com>
Date: Tue, 15 May 2018 16:31:47 +0900
MIME-Version: 1.0
In-Reply-To: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/sysfs.c | 11 ++++++-----
 fs/btrfs/sysfs.h |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index fa6c8c88b250..217d401fe8ae 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -514,10 +514,11 @@ static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj)
 }
 
 #define NUM_FEATURE_BITS 64
-static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
-static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
+#define BTRFS_FEATURE_NAME_MAX 13
+static char btrfs_unknown_feature_names[FEAT_MAX][NUM_FEATURE_BITS][BTRFS_FEATURE_NAME_MAX];
+static struct btrfs_feature_attr btrfs_feature_attrs[FEAT_MAX][NUM_FEATURE_BITS];
 
-static const u64 supported_feature_masks[3] = {
+static const u64 supported_feature_masks[FEAT_MAX] = {
 	[FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
 	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
 	[FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
@@ -609,7 +610,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
 }
 
-const char * const btrfs_feature_set_names[3] = {
+const char * const btrfs_feature_set_names[FEAT_MAX] = {
 	[FEAT_COMPAT]	 = "compat",
 	[FEAT_COMPAT_RO] = "compat_ro",
 	[FEAT_INCOMPAT]	 = "incompat",
@@ -673,7 +674,7 @@ static void init_feature_attrs(void)
 			if (fa->kobj_attr.attr.name)
 				continue;
 
-			snprintf(name, 13, "%s:%u",
+			snprintf(name, BTRFS_FEATURE_NAME_MAX, "%s:%u",
 				 btrfs_feature_set_names[set], i);
 
 			fa->kobj_attr.attr.name = name;
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index b567560d9aa9..40716b357c1d 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -77,7 +77,7 @@ attr_to_btrfs_feature_attr(struct attribute *attr)
 }
 
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
-extern const char * const btrfs_feature_set_names[3];
+extern const char * const btrfs_feature_set_names[FEAT_MAX];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
-- 
2.14.3

