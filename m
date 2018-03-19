Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:60628 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754531AbeCSH2B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:28:01 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 789F9AC0126
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:27:58 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 8FD9A328605
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:27:57 +0900 (JST)
Subject: [PATCH v3 2/3] btrfs: Add unprivileged ioctl which returns
 subvolume's ROOT_REF
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cef1bb9a-5a32-066b-e9f6-b0010803c8bf@jp.fujitsu.com>
Message-ID: <b1b01fcb-f1a4-5e3e-64cf-0bb376f3c0a4@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:27:54 +0900
MIME-Version: 1.0
In-Reply-To: <cef1bb9a-5a32-066b-e9f6-b0010803c8bf@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add unprivileged ioctl BTRFS_IOC_GET_SUBVOL_ROOTREF which
returns ROOT_REF information of the subvolume containing this inode.
The min id of root ref's subvolume to be searched is specified by
min_id in struct btrfs_ioctl_get_subvol_rootref_args.

If there are more root refs than BTRFS_MAX_ROOTREF_BUFFER_NUM,
this ioctl sets min_id to the last searched root ref's subvolid + 1
and return -EOVERFLOW. Therefore the caller can just call this ioctl
again without changing the argument to continue search.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c           | 91 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h | 16 ++++++++
 2 files changed, 107 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be2abe7a5bba..5b97a735790e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2425,6 +2425,95 @@ static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
 	return ret;
 }
 
+/* Returns ROOT_REF information of the subvolume contining this inode. */
+static noinline int btrfs_ioctl_get_subvol_rootref(struct file *file,
+					   void __user *argp)
+{
+	struct btrfs_ioctl_get_subvol_rootref_args *rootrefs;
+	struct btrfs_root_ref *rref;
+	struct btrfs_root *root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+
+	struct extent_buffer *l;
+	int slot;
+
+	struct inode *inode;
+	int i, nritems;
+	int ret;
+	u64 objectid;
+	u8 found;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	rootrefs = memdup_user(argp, sizeof(*rootrefs));
+	if (!rootrefs) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
+
+	inode = file_inode(file);
+	root = BTRFS_I(inode)->root->fs_info->tree_root;
+	objectid = BTRFS_I(inode)->root->root_key.objectid;
+
+	key.objectid = objectid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = rootrefs->min_id;
+	found = 0;
+	while (1) {
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+
+		l = path->nodes[0];
+		slot = path->slots[0];
+		nritems = btrfs_header_nritems(l);
+		if (nritems - slot == 0) {
+			ret = 0;
+			goto out;
+		}
+
+		for (i = slot; i < nritems; i++) {
+			btrfs_item_key_to_cpu(l, &key, i);
+			if (key.objectid != objectid ||
+					key.type != BTRFS_ROOT_REF_KEY) {
+				ret = 0;
+				goto out;
+			}
+
+			if (found == BTRFS_MAX_ROOTREF_BUFFER_NUM) {
+				/* update min_id for next search */
+				rootrefs->min_id = key.offset;
+				ret = -EOVERFLOW;
+				goto out;
+			}
+
+			rref = btrfs_item_ptr(l, i, struct btrfs_root_ref);
+			rootrefs->rootref[found].subvolid = key.offset;
+			rootrefs->rootref[found].dirid =
+					  btrfs_root_ref_dirid(l, rref);
+			found++;
+		}
+
+		btrfs_release_path(path);
+		key.offset++;
+	}
+
+out:
+	if (!ret || ret == -EOVERFLOW) {
+		rootrefs->num_items = found;
+		if (copy_to_user(argp, rootrefs, sizeof(*rootrefs)))
+			ret = -EFAULT;
+	}
+
+	btrfs_free_path(path);
+	kfree(rootrefs);
+
+	return ret;
+}
+
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
@@ -5781,6 +5870,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_features(file, argp);
 	case BTRFS_IOC_GET_SUBVOL_INFO:
 		return btrfs_ioctl_get_subvol_info(file, argp);
+	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
+		return btrfs_ioctl_get_subvol_rootref(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index ed053852c71f..82c88d52d6e6 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -774,6 +774,20 @@ struct btrfs_ioctl_get_subvol_info_args {
 	__u64 reserved[8];
 };
 
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
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
@@ -894,5 +908,7 @@ enum btrfs_err_code {
 					struct btrfs_ioctl_logical_ino_args)
 #define BTRFS_IOC_GET_SUBVOL_INFO _IOR(BTRFS_IOCTL_MAGIC, 60, \
 				struct btrfs_ioctl_get_subvol_info_args)
+#define BTRFS_IOC_GET_SUBVOL_ROOTREF _IOWR(BTRFS_IOCTL_MAGIC, 61, \
+				struct btrfs_ioctl_get_subvol_rootref_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.14.3

