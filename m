Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:11073 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbeCFId4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:33:56 -0500
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 26D7AAC00C9
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:33:50 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 55E675842B7
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:33:49 +0900 (JST)
Subject: [RFC PATCH 1/7] btrfs-progs: Add 2 definitions of new unprivileged
 ioctl
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Message-ID: <f899fbdc-84db-73e7-4fe3-d85cc8f814a7@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:33:45 +0900
MIME-Version: 1.0
In-Reply-To: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add 2 definitions of new unprivileged ioctl (BTRFS_IOC_GET_SUBVOL_INFO
and BTRFS_IOC_INO_LOOKUP_USER). They will be used to implement
user version of "btrfs subvolume list" etc.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 ioctl.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 709e996f..c5181dd9 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -320,6 +320,21 @@ struct btrfs_ioctl_ino_lookup_args {
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_lookup_args) == 4096);
 
+#define BTRFS_INO_LOOKUP_USER_PATH_MAX (4072-BTRFS_VOL_NAME_MAX)
+struct btrfs_ioctl_ino_lookup_user_args {
+	/* in */
+	__u64 treeid;
+	/* in, 'dirid' is the same as objectid in btrfs_ioctl_ino_lookup_args */
+	__u64 dirid;
+	/* in, subvolume id */
+	__u64 subid;
+	/* out, name of the subvolume whose objectid is 'subid' */
+	char name[BTRFS_VOL_NAME_MAX];
+	/* out, 'path' is the same as 'name' in btrfs_ioctl_ino_lookup_args */
+	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
+};
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_lookup_user_args) == 4096);
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -828,6 +843,10 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_GET_SUBVOL_INFO _IOWR(BTRFS_IOCTL_MAGIC, 60, \
+					struct btrfs_ioctl_search_args)
+#define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 61, \
+					struct btrfs_ioctl_ino_lookup_args)
 #ifdef __cplusplus
 }
 #endif
-- 
2.14.3

