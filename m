Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:19225 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbeEPFrK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 01:47:10 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id CC8BEAC0534
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 14:47:04 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id D9E5B6926D4
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 14:47:03 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v5 2/3] btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
Date: Wed, 16 May 2018 14:49:38 +0900
Message-ID: <af4638e0d17097f4270e9fea655ca6488ad3a2c6.1526446338.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1526446338.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add unprivileged ioctl BTRFS_IOC_GET_SUBVOL_ROOTREF which
returns ROOT_REF information of the subvolume containing this inode
except the subvolume name (this is because to prevent potential name
leak). The subvolume name will be gained by user version of ino_lookup
ioctl (BTRFS_IOC_INO_LOOKUP_USER) which also performs permission check.

The min id of root ref's subvolume to be searched is specified by
@min_id in struct btrfs_ioctl_get_subvol_rootref_args. After the search
ends, @min_id is set to the last searched root ref's subvolid + 1. Also,
if there are more root refs than BTRFS_MAX_ROOTREF_BUFFER_NUM, -EOVERFLOW
is returned. Therefore the caller can just call this ioctl again without
changing the argument to continue search.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 v4 -> v5
    - Update error handling of btrfs_next_leaf() to cover all cases
    - Use btrfs_next_item() to reduce the call of btrfs_search_slot()

 fs/btrfs/ioctl.c           | 102 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |  16 +++++++
 2 files changed, 118 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c1c9ae9a937d..db5de77540e1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2386,6 +2386,106 @@ static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
 	return ret;
 }
 
+/*
+ * Return ROOT_REF information of the subvolume containing this inode
+ * except the subvolume name.
+ */
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
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out;
+	} else if (path->slots[0] >=
+			btrfs_header_nritems(path->nodes[0])) {
+		ret = btrfs_next_leaf(root, path);
+		if (ret < 0) {
+			goto out;
+		} else if (ret > 0) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+	while (1) {
+		l = path->nodes[0];
+		slot = path->slots[0];
+
+		btrfs_item_key_to_cpu(l, &key, slot);
+		if (key.objectid != objectid ||
+		    key.type != BTRFS_ROOT_REF_KEY) {
+			ret = 0;
+			goto out;
+		}
+
+		if (found == BTRFS_MAX_ROOTREF_BUFFER_NUM) {
+			ret = -EOVERFLOW;
+			goto out;
+		}
+
+		rref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
+		rootrefs->rootref[found].subvolid = key.offset;
+		rootrefs->rootref[found].dirid =
+				  btrfs_root_ref_dirid(l, rref);
+		found++;
+
+		ret = btrfs_next_item(root, path);
+		if (ret < 0) {
+			goto out;
+		} else if (ret > 0) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+
+out:
+	if (!ret || ret == -EOVERFLOW) {
+		rootrefs->num_items = found;
+		/* update min_id for next search */
+		if (found)
+			rootrefs->min_id =
+				rootrefs->rootref[found - 1].subvolid + 1;
+		if (copy_to_user(argp, rootrefs, sizeof(*rootrefs)))
+			ret = -EFAULT;
+	}
+
+	btrfs_free_path(path);
+	kfree(rootrefs);
+	return ret;
+}
+
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
@@ -5520,6 +5620,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_features(file, argp);
 	case BTRFS_IOC_GET_SUBVOL_INFO:
 		return btrfs_ioctl_get_subvol_info(file, argp);
+	case BTRFS_IOC_GET_SUBVOL_ROOTREF:
+		return btrfs_ioctl_get_subvol_rootref(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 02cd1f1994e8..b6633f5d4847 100644
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


