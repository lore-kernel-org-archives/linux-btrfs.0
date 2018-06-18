Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:28187 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968188AbeFRIiM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:12 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id D68FCAC0116
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 018593286F9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 02/20] btrfs-progs: ioctl/libbtrfsutil: Add 3 definitions of new unprivileged ioctl
Date: Mon, 18 Jun 2018 17:40:50 +0900
Message-ID: <fd7e334d6bea39fa510ad98048357918ac1e9b24.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copy and add 3 definitions of new unprivileged ioctl
(BTRFS_IOC_GET_SUBVOL_INFO, BTRFS_IOC_GET_SUBVOL_ROOTREF and
BTRFS_IOC_INO_LOOKUP_USER) from kernel. They will be used to implement
the user version of "btrfs subvolume list/show" etc.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 ioctl.h              | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 libbtrfsutil/btrfs.h | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 196 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 709e996f..cce55dbd 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -320,6 +320,22 @@ struct btrfs_ioctl_ino_lookup_args {
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_lookup_args) == 4096);
 
+#define BTRFS_INO_LOOKUP_USER_PATH_MAX (4080 - BTRFS_VOL_NAME_MAX - 1)
+struct btrfs_ioctl_ino_lookup_user_args {
+	/* in, inode number containing the subvolume of 'subvolid' */
+	__u64 dirid;
+	/* in */
+	__u64 treeid;
+	/* out, name of the subvolume of 'treeid' */
+	char name[BTRFS_VOL_NAME_MAX + 1];
+	/*
+	 * out, constructed path from the directory with which the ioctl is
+	 * called to dirid
+	 */
+	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
+};
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_lookup_user_args) == 4096);
+
 struct btrfs_ioctl_search_key {
 	/* which root are we searching.  0 is the tree of tree roots */
 	__u64 tree_id;
@@ -672,6 +688,83 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_send_args_64) == 72);
 
 #define BTRFS_IOC_SEND_64_COMPAT_DEFINED 1
 
+/*
+ * Information about a fs tree root.
+ *
+ * All items are filled by the ioctl
+ */
+struct btrfs_ioctl_get_subvol_info_args {
+	/* Id of this subvolume */
+	__u64 treeid;
+
+	/* Name of this subvolume, used to get the real name at mount point */
+	char name[BTRFS_VOL_NAME_MAX + 1];
+
+	/*
+	 * Id of the subvolume which contains this subvolume.
+	 * Zero for top-level subvolume or a deleted subvolume.
+	 */
+	__u64 parent_id;
+
+	/*
+	 * Inode number of the directory which contains this subvolume.
+	 * Zero for top-level subvolume or a deleted subvolume
+	 */
+	__u64 dirid;
+
+	/* Latest transaction id of this subvolume */
+	__u64 generation;
+
+	/* Flags of this subvolume */
+	__u64 flags;
+
+	/* UUID of this subvolume */
+	__u8 uuid[BTRFS_UUID_SIZE];
+
+	/*
+	 * UUID of the subvolume of which this subvolume is a snapshot.
+	 * All zero for a non-snapshot subvolume.
+	 */
+	__u8 parent_uuid[BTRFS_UUID_SIZE];
+
+	/*
+	 * UUID of the subvolume from which this subvolume was received.
+	 * All zero for non-received subvolume.
+	 */
+	__u8 received_uuid[BTRFS_UUID_SIZE];
+
+	/* Transaction id indicating when change/create/send/receive happened */
+	__u64 ctransid;
+	__u64 otransid;
+	__u64 stransid;
+	__u64 rtransid;
+	/* Time corresponding to c/o/s/rtransid */
+	struct btrfs_ioctl_timespec ctime;
+	struct btrfs_ioctl_timespec otime;
+	struct btrfs_ioctl_timespec stime;
+	struct btrfs_ioctl_timespec rtime;
+
+	/* Must be zero */
+	__u64 reserved[8];
+};
+
+#define BTRFS_MAX_ROOTREF_BUFFER_NUM 255
+struct btrfs_ioctl_get_subvol_rootref_args {
+		/* in/out, minimum id of rootref's treeid to be searched */
+		__u64 min_treeid;
+
+		/* out */
+		struct {
+			__u64 treeid;
+			__u64 dirid;
+		} rootref[BTRFS_MAX_ROOTREF_BUFFER_NUM];
+
+		/* out, number of found items */
+		__u8 num_items;
+		__u8 align[7];
+};
+BUILD_ASSERT(sizeof(struct btrfs_ioctl_get_subvol_rootref_args) == 4096);
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	notused,
@@ -828,6 +921,12 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
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
diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
index c293f6bf..95740de2 100644
--- a/libbtrfsutil/btrfs.h
+++ b/libbtrfsutil/btrfs.h
@@ -421,6 +421,21 @@ struct btrfs_ioctl_ino_lookup_args {
 	char name[BTRFS_INO_LOOKUP_PATH_MAX];
 };
 
+#define BTRFS_INO_LOOKUP_USER_PATH_MAX (4080-BTRFS_VOL_NAME_MAX-1)
+struct btrfs_ioctl_ino_lookup_user_args {
+	/* in, inode number containing the subvolume of 'subvolid' */
+	__u64 dirid;
+	/* in */
+	__u64 treeid;
+	/* out, name of the subvolume of 'treeid' */
+	char name[BTRFS_VOL_NAME_MAX + 1];
+	/*
+	 * out, constructed path from the directory with which the ioctl is
+	 * called to dirid
+	 */
+	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
+};
+
 /* Search criteria for the btrfs SEARCH ioctl family. */
 struct btrfs_ioctl_search_key {
 	/*
@@ -720,6 +735,82 @@ struct btrfs_ioctl_send_args {
 	__u64 reserved[4];		/* in */
 };
 
+/*
+ * Information about a fs tree root.
+ *
+ * All items are filled by the ioctl
+ */
+struct btrfs_ioctl_get_subvol_info_args {
+	/* Id of this subvolume */
+	__u64 treeid;
+
+	/* Name of this subvolume, used to get the real name at mount point */
+	char name[BTRFS_VOL_NAME_MAX + 1];
+
+	/*
+	 * Id of the subvolume which contains this subvolume.
+	 * Zero for top-level subvolume or a deleted subvolume.
+	 */
+	__u64 parent_id;
+
+	/*
+	 * Inode number of the directory which contains this subvolume.
+	 * Zero for top-level subvolume or a deleted subvolume
+	 */
+	__u64 dirid;
+
+	/* Latest transaction id of this subvolume */
+	__u64 generation;
+
+	/* Flags of this subvolume */
+	__u64 flags;
+
+	/* UUID of this subvolume */
+	__u8 uuid[BTRFS_UUID_SIZE];
+
+	/*
+	 * UUID of the subvolume of which this subvolume is a snapshot.
+	 * All zero for a non-snapshot subvolume.
+	 */
+	__u8 parent_uuid[BTRFS_UUID_SIZE];
+
+	/*
+	 * UUID of the subvolume from which this subvolume was received.
+	 * All zero for non-received subvolume.
+	 */
+	__u8 received_uuid[BTRFS_UUID_SIZE];
+
+	/* Transaction id indicating when change/create/send/receive happened */
+	__u64 ctransid;
+	__u64 otransid;
+	__u64 stransid;
+	__u64 rtransid;
+	/* Time corresponding to c/o/s/rtransid */
+	struct btrfs_ioctl_timespec ctime;
+	struct btrfs_ioctl_timespec otime;
+	struct btrfs_ioctl_timespec stime;
+	struct btrfs_ioctl_timespec rtime;
+
+	/* Must be zero */
+	__u64 reserved[8];
+};
+
+#define BTRFS_MAX_ROOTREF_BUFFER_NUM 255
+struct btrfs_ioctl_get_subvol_rootref_args {
+		/* in/out, minimum id of rootref's treeid to be searched */
+		__u64 min_treeid;
+
+		/* out */
+		struct {
+			__u64 treeid;
+			__u64 dirid;
+		} rootref[BTRFS_MAX_ROOTREF_BUFFER_NUM];
+
+		/* out, number of found items */
+		__u8 num_items;
+		__u8 align[7];
+};
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
@@ -836,5 +927,11 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
+				struct btrfs_ioctl_get_subvol_info_args)
+#define BTRFS_IOC_GET_SUBVOL_ROOTREF _IOWR(BTRFS_IOCTL_MAGIC, 61, \
+				struct btrfs_ioctl_get_subvol_rootref_args)
+#define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
+				struct btrfs_ioctl_ino_lookup_user_args)
 
 #endif /* _LINUX_BTRFS_H */
-- 
2.14.4


