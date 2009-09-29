From: Sage Weil <sage@newdream.net>
Subject: [PATCH 4/4] Btrfs: add TRANS_RESV_START ioctl to check/reserve free space on transaction start
Date: Tue, 29 Sep 2009 11:50:05 -0700
Message-ID: <1254250205-8175-4-git-send-email-sage@newdream.net>
References: <1254250205-8175-1-git-send-email-sage@newdream.net>
 <1254250205-8175-2-git-send-email-sage@newdream.net>
 <1254250205-8175-3-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1254250205-8175-3-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

The current TRANS_START ioctl is problematic when the volume fills up
because a process can get ENOSPC on any operation that's supoosed to be
"contained" within its transaction without any prior warning.  This
defines a new ioctl, TRANS_RESV_START, that checks and sets aside space
for the entire transaction, so that the process will get ENOSPC right
away.

The bytes_ioctl_trans_reserved is only checked and adjusted by the
TRANS_RESV_START ioctl; any write()s that follow will be allowed to use
up that reserved space.  This is clearly imperfect (a mixture of an
ioctl transaction workload and a regular workload will violate the
reservations), but unavoidable with the current user transaction approach
because we don't know whether any given operation is contained by a
user transaction or not.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ctree.h       |    7 ++++
 fs/btrfs/extent-tree.c |   59 +++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.c       |   92 +++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ioctl.h       |    6 +++
 4 files changed, 153 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3959a1..14b7980 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -682,6 +682,9 @@ struct btrfs_space_info {
 	u64 bytes_delalloc;	/* number of bytes currently reserved for
 				   delayed allocation */
 
+	u64 bytes_ioctl_trans_reserved; /* number of bytes reserved by ioctl
+					   transactions */
+
 	int full;		/* indicates that we cannot allocate any more
 				   chunks for this space */
 	int force_alloc;	/* set if we need to force a chunk alloc for
@@ -2036,6 +2039,10 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes);
 void btrfs_free_reserved_data_space(struct btrfs_root *root,
 				    struct inode *inode, u64 bytes);
+int btrfs_reserve_ioctl_trans_free_space(struct btrfs_root *root,
+					 u64 bytes, u64 ops);
+void btrfs_unreserve_ioctl_trans_space(struct btrfs_root *root,
+					  u64 bytes, u64 ops);
 void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c190bdb..d6316f8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2670,6 +2670,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->bytes_reserved = 0;
 	found->bytes_readonly = 0;
 	found->bytes_delalloc = 0;
+	found->bytes_ioctl_trans_reserved = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -3129,6 +3130,14 @@ static int __alloc_chunk(struct btrfs_root *root, u64 bytes)
 	return ret;
 }
 
+/*
+ * if @inode is defined, reserve bytes on that inode.  otherwise, we
+ * are reserving the space for an ioctl transaction, and need to
+ * subtract off other ioctl reserved space too.  we _only_ check ioctl
+ * reserved space here: the write() that follows needs to be able to
+ * use it, and we don't know which writes "belong" to which ioctl
+ * transactions.
+ */
 int btrfs_check_data_free_space_info(struct btrfs_root *root,
 				     struct btrfs_space_info *data_sinfo,
 				     u64 bytes,
@@ -3142,6 +3151,7 @@ again:
 	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
 	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
 	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
+	    (inode ? 0 : data_sinfo->bytes_ioctl_trans_reserved) -
 	    data_sinfo->bytes_may_use - data_sinfo->bytes_super < bytes) {
 		struct btrfs_trans_handle *trans;
 
@@ -3160,7 +3170,8 @@ again:
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
-		if (!committed && !root->fs_info->open_ioctl_trans) {
+		if (!committed &&
+		    (!inode || !root->fs_info->open_ioctl_trans)) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
@@ -3184,8 +3195,12 @@ again:
 		       (unsigned long long)data_sinfo->total_bytes);
 		return -ENOSPC;
 	}
-	data_sinfo->bytes_may_use += bytes;
-	BTRFS_I(inode)->reserved_bytes += bytes;
+	if (inode) {
+		data_sinfo->bytes_may_use += bytes;
+		BTRFS_I(inode)->reserved_bytes += bytes;
+	} else {
+		data_sinfo->bytes_ioctl_trans_reserved += bytes;
+	}
 	spin_unlock(&data_sinfo->lock);
 	return 0;
 }
@@ -3215,6 +3230,44 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 	return btrfs_check_data_free_space_info(root, data_sinfo, bytes, inode);
 }
 
+int btrfs_reserve_ioctl_trans_free_space(struct btrfs_root *root, u64 bytes,
+				       u64 ops)
+{
+	struct btrfs_space_info *data_sinfo;
+	u64 alloc_target;
+	int ret;
+
+	/* make sure bytes are sectorsize aligned */
+	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	bytes += calculate_bytes_needed(root, ops * 5);
+
+	alloc_target = btrfs_get_alloc_profile(root, 1);
+	data_sinfo = __find_space_info(root->fs_info, alloc_target);
+	ret = btrfs_check_data_free_space_info(root, data_sinfo, bytes, NULL);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+void btrfs_unreserve_ioctl_trans_space(struct btrfs_root *root,
+				       u64 bytes, u64 ops)
+{
+	struct btrfs_space_info *data_sinfo;
+	u64 alloc_target;
+
+	/* make sure bytes are sectorsize aligned */
+	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	bytes += calculate_bytes_needed(root, ops * 5);
+
+	if (bytes) {
+		alloc_target = btrfs_get_alloc_profile(root, 1);
+		data_sinfo = __find_space_info(root->fs_info, alloc_target);
+		spin_lock(&data_sinfo->lock);
+		data_sinfo->bytes_ioctl_trans_reserved -= bytes;
+		spin_unlock(&data_sinfo->lock);
+	}
+}
+
 /*
  * if there was an error for whatever reason after calling
  * btrfs_check_data_free_space, call this so we can cleanup the counters.
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9a780c8..dd4fde1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1227,11 +1227,76 @@ static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
  * basically own the machine, and have a very in depth understanding
  * of all the possible deadlocks and enospc problems.
  */
+struct btrfs_ioctl_trans {
+	struct btrfs_trans_handle *trans;
+	u64 reserved_bytes, reserved_ops;
+};
+
+static long btrfs_ioctl_trans_resv_start(struct file *file, void __user *argp)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_ioctl_trans *ioctl_trans;
+	struct btrfs_ioctl_trans_resv_start resv;
+	int ret;
+
+	ret = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto out;
+
+	ret = -EINPROGRESS;
+	if (file->private_data)
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&resv, argp, sizeof(resv)))
+		goto out;
+
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		goto out;
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans++;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	ret = btrfs_reserve_ioctl_trans_free_space(root, resv.bytes, resv.ops);
+	if (ret)
+		goto out_drop;
+
+	ret = -ENOMEM;
+	ioctl_trans = kzalloc(sizeof(*ioctl_trans), GFP_KERNEL);
+	if (!ioctl_trans)
+		goto out_free_bytes;
+
+	ioctl_trans->trans = btrfs_start_ioctl_transaction(root, 0);
+	if (!ioctl_trans->trans)
+		goto out_free_ioctl_trans;
+
+	ioctl_trans->reserved_bytes = resv.bytes;
+	ioctl_trans->reserved_ops = resv.ops;
+	file->private_data = ioctl_trans;
+	return 0;
+
+out_free_ioctl_trans:
+	kfree(ioctl_trans);
+out_free_bytes:
+	btrfs_unreserve_ioctl_trans_space(root, resv.bytes, resv.ops);
+out_drop:
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans--;
+	mutex_unlock(&root->fs_info->trans_mutex);
+	mnt_drop_write(file->f_path.mnt);
+out:
+	return ret;
+}
+
+
 static long btrfs_ioctl_trans_start(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_ioctl_trans *ioctl_trans;
 	int ret;
 
 	ret = -EPERM;
@@ -1251,13 +1316,19 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	ret = -ENOMEM;
-	trans = btrfs_start_ioctl_transaction(root, 0);
-	if (!trans)
+	ioctl_trans = kzalloc(sizeof(*ioctl_trans), GFP_KERNEL);
+	if (!ioctl_trans)
 		goto out_drop;
 
-	file->private_data = trans;
+	ioctl_trans->trans = btrfs_start_ioctl_transaction(root, 0);
+	if (ioctl_trans->trans)
+		goto out_free_ioctl_trans;
+
+	file->private_data = ioctl_trans;
 	return 0;
 
+out_free_ioctl_trans:
+	kfree(ioctl_trans);
 out_drop:
 	mutex_lock(&root->fs_info->trans_mutex);
 	root->fs_info->open_ioctl_trans--;
@@ -1277,14 +1348,17 @@ long btrfs_ioctl_trans_end(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_ioctl_trans *ioctl_trans;
 
-	trans = file->private_data;
-	if (!trans)
+	ioctl_trans = file->private_data;
+	if (!ioctl_trans)
 		return -EINVAL;
 	file->private_data = NULL;
 
-	btrfs_end_transaction(trans, root);
+	btrfs_unreserve_ioctl_trans_space(root, ioctl_trans->reserved_bytes,
+					  ioctl_trans->reserved_ops);
+	btrfs_end_transaction(ioctl_trans->trans, root);
+	kfree(ioctl_trans);
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	root->fs_info->open_ioctl_trans--;
@@ -1327,6 +1401,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
 		return btrfs_ioctl_clone_range(file, argp);
+	case BTRFS_IOC_TRANS_RESV_START:
+		return btrfs_ioctl_trans_resv_start(file, argp);
 	case BTRFS_IOC_TRANS_START:
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index bc49914..9810980 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -48,6 +48,12 @@ struct btrfs_ioctl_clone_range_args {
  * use by applications that know how to avoid the
  * resulting deadlocks
  */
+/* check/reserve disk space for the transaction up-front */
+struct btrfs_ioctl_trans_resv_start {
+	__u64 bytes, ops;
+};
+#define BTRFS_IOC_TRANS_RESV_START _IOW(BTRFS_IOCTL_MAGIC, 5,	\
+					struct btrfs_ioctl_trans_resv_start)
 #define BTRFS_IOC_TRANS_START  _IO(BTRFS_IOCTL_MAGIC, 6)
 #define BTRFS_IOC_TRANS_END    _IO(BTRFS_IOCTL_MAGIC, 7)
 #define BTRFS_IOC_SYNC         _IO(BTRFS_IOCTL_MAGIC, 8)
-- 
1.5.6.5

