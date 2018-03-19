Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:26566 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754511AbeCSHbe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:31:34 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D1BFAAC0126
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:31:26 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 05983BD64E9
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:31:26 +0900 (JST)
Subject: [RFC PATCH v3 2/7] btrfs-progs: ioctl: Add 3 definitions of new
 unprivileged ioctl
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Message-ID: <009426f6-10d9-7e59-8abc-a3f879ee9a0f@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:31:22 +0900
MIME-Version: 1.0
In-Reply-To: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add 3 definitions of new unprivileged ioctl (BTRFS_IOC_GET_SUBVOL_INFO,
BTRFS_IOC_GET_SUBVOL_ROOTREF and BTRFS_IOC_INO_LOOKUP_USER). They will
be used to implement user version of "btrfs subvolume list" etc.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 ioctl.h | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 709e996f..c6624352 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -320,6 +320,22 @@ struct btrfs_ioctl_ino_lookup_args {
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_lookup_args) == 4096);
 
+#define BTRFS_INO_LOOKUP_USER_PATH_MAX (4080-BTRFS_VOL_NAME_MAX-1)
+struct btrfs_ioctl_ino_lookup_user_args {
+	/* in, inode number containing the subvolume of 'subvolid' */
+	__u64 dirid;
+	/* in */
+	__u64 subvolid;
+	/* out, name of the subvolume of 'subvolid' */
+	char name[BTRFS_VOL_NAME_MAX + 1];
+	/*
+	 * out, constructed path from the directory with which
+	 * the ioctl is called to dirid
+	 */
+	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
+};
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_lookup_user_args) == 4096);
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -672,6 +688,70 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_send_args_64) == 72);
 
 #define BTRFS_IOC_SEND_64_COMPAT_DEFINED 1
 
+struct btrfs_ioctl_get_subvol_info_args {
+	/* All filed is out */
+	/* Id of this subvolume */
+	__u64 id;
+	/* Name of this subvolume, used to get the real name at mount point */
+	char name[BTRFS_VOL_NAME_MAX + 1];
+	/*
+	 * Id of the subvolume which contains this subvolume.
+	 * Zero for top-level subvolume or deleted subvolume
+	 */
+	__u64 parent_id;
+	/*
+	 * Inode number of the directory which contains this subvolume.
+	 * Zero for top-level subvolume or deleted subvolume
+	 */
+	__u64 dirid;
+
+	/* Latest transaction id of this subvolume */
+	__u64 generation;
+	/* Flags of this subvolume */
+	__u64 flags;
+
+	/* uuid of this subvolume */
+	__u8 uuid[BTRFS_UUID_SIZE];
+	/*
+	 * uuid of the subvolume of which this subvolume is a snapshot.
+	 * All zero for non-snapshot subvolume
+	 */
+	__u8 parent_uuid[BTRFS_UUID_SIZE];
+	/*
+	 * uuid of the subvolume from which this subvolume is received.
+	 * All zero for non-received subvolume
+	 */
+	__u8 received_uuid[BTRFS_UUID_SIZE];
+
+	/* Transaction id indicates when change/create/send/receive happens */
+	__u64 ctransid;
+	__u64 otransid;
+	__u64 stransid;
+	__u64 rtransid;
+	/* Time corresponds to c/o/s/rtransid */
+	struct btrfs_ioctl_timespec ctime;
+	struct btrfs_ioctl_timespec otime;
+	struct btrfs_ioctl_timespec stime;
+	struct btrfs_ioctl_timespec rtime;
+
+	__u64 reserved[8];
+};
+
+#define BTRFS_MAX_ROOTREF_BUFFER_NUM 255
+struct btrfs_ioctl_get_subvol_rootref_args {
+		/* in/out, min id of rootref's subvolid to be searched */
+		__u64 min_id;
+		/* out */
+		struct {
+			__u64 subvolid;
+			__u64 dirid;
+		} rootref[BTRFS_MAX_ROOTREF_BUFFER_NUM];
+		/* out, number of found items */
+		__u8 num_items;
+		__u8 align[7];
+};
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_get_subvol_rootref_args) == 4096);
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	notused,
@@ -828,6 +908,12 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
+				struct btrfs_ioctl_get_subvol_info_args)
+#define BTRFS_IOC_GET_SUBVOL_ROOTREF _IOWR(BTRFS_IOCTL_MAGIC, 61, \
+				struct btrfs_ioctl_get_subvol_rootref_args)
+#define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
+				struct btrfs_ioctl_ino_lookup_user_args)
 #ifdef __cplusplus
 }
 #endif
-- 
2.14.3

