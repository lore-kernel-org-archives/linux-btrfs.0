Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbeIGPIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:08:14 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7CA3AE06
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 10:27:54 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: qgroup: Validate btrfs_qgroup_inherit structure before passing it to qgroup
Date: Fri,  7 Sep 2018 18:27:44 +0800
Message-Id: <20180907102745.10387-3-wqu@suse.com>
In-Reply-To: <20180907102745.10387-1-wqu@suse.com>
References: <20180907102745.10387-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_qgroup_inherit structure doesn't goes through much validation
check.

Now do a comprehensive check for it, including:
1) Inherit size
   Should not exceeding SZ_4K and its num_qgroups should not
   exceed its size passed in btrfs_ioctl_vol_args_v2.

2) Flags
   Should not include any unknown flags

3) Qgroupid
   Comprehensive check is already in btrfs_qgroup_inherit(), here we
   only check if there is any obviously invalid qgroupid (0).

Coverity-id: 1021055
Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c           |  5 +++++
 fs/btrfs/qgroup.c          | 33 +++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h          |  3 +++
 include/uapi/linux/btrfs.h | 16 +++++++---------
 4 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5db8680b40a9..ce88d6518076 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1820,6 +1820,11 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 			ret = PTR_ERR(inherit);
 			goto free_args;
 		}
+		ret = btrfs_validate_inherit(
+				BTRFS_I(file_inode(file))->root->fs_info,
+				inherit, vol_args->size);
+		if (ret < 0)
+			goto free_args;
 	}
 
 	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4353bb69bb86..75e1dccf8ed3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2232,6 +2232,39 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 	return ret;
 }
 
+/*
+ * To make sure the inherit passed in is valid
+ *
+ * Here we only check flags and rule out some no-longer supported features.
+ * And we only do very basis qgroupid check to ensure there is no obviously
+ * invalid qgroupid (0). Detailed qgroupid check will be done in
+ * btrfs_qgroup_inherit().
+ */
+int btrfs_validate_inherit(struct btrfs_fs_info *fs_info,
+			   struct btrfs_qgroup_inherit *inherit,
+			   u64 inherit_size)
+{
+	u64 i;
+
+	if (inherit->flags & ~BTRFS_QGROUP_INHERIT_FLAGS_SUPP)
+		return -ENOTTY;
+
+	/* Size check */
+	if (sizeof(u64) * inherit->num_qgroups +
+	    sizeof(u64) * inherit->num_ref_copies * 2 +
+	    sizeof(u64) * inherit->num_excl_copies * 2 +
+	    sizeof(*inherit) >
+	    min_t(u64, BTRFS_QGROUP_INHERIT_MAX_SIZE, inherit_size))
+		return -EINVAL;
+
+	/* Qgroup 0/0 is not allowed */
+	for (i = 0; i < inherit->num_qgroups; i++) {
+		if (inherit->qgroups[i] == 0)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * Copy the accounting information between qgroups. This is necessary
  * when a snapshot or a subvolume is created. Throwing an error will
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 54b8bb282c0e..6031c0beb798 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -241,6 +241,9 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				struct ulist *new_roots);
 int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans);
+int btrfs_validate_inherit(struct btrfs_fs_info *fs_info,
+			   struct btrfs_qgroup_inherit *inherit,
+			   u64 inherit_size);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 			 u64 objectid, struct btrfs_qgroup_inherit *inherit);
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 311edb65567c..3398f35a5528 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -74,21 +74,19 @@ struct btrfs_qgroup_limit {
 	__u64	rsv_excl;
 };
 
-/*
- * flags definition for qgroup inheritance
- *
- * Used by:
- * struct btrfs_qgroup_inherit.flags
- */
+/* flags definition for qgroup inheritance (will be deprecated) */
 #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
 
+#define BTRFS_QGROUP_INHERIT_FLAGS_SUPP (BTRFS_QGROUP_INHERIT_SET_LIMITS)
+
 #define BTRFS_QGROUP_INHERIT_MAX_SIZE	(SZ_4K)
+
 struct btrfs_qgroup_inherit {
 	__u64	flags;
 	__u64	num_qgroups;
-	__u64	num_ref_copies;
-	__u64	num_excl_copies;
-	struct btrfs_qgroup_limit lim;
+	__u64	num_ref_copies;		/* will be deprecated */
+	__u64	num_excl_copies;	/* will be deprecated */
+	struct btrfs_qgroup_limit lim;	/* will be deprecated */
 	__u64	qgroups[0];
 };
 
-- 
2.18.0
