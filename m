From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] Btrfs: added new ioctl to set fs label
Date: Thu, 01 Sep 2011 16:47:47 +0800
Message-ID: <4E5F46B3.50607@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'd like to introduce a new ioctl to set file system label.
With this feature, we can execute `btrfs filesystem label [label] 
[path]` through btrfs tools to set or change the label.

  Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
  fs/btrfs/ctree.h |    6 ++++++
  fs/btrfs/ioctl.c |   37 +++++++++++++++++++++++++++++++++++++
  fs/btrfs/ioctl.h |    2 ++
  3 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..2889b5e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1259,6 +1259,12 @@ struct btrfs_ioctl_defrag_range_args {
  };


+struct btrfs_ioctl_fs_label_args {
+    /* label length in bytes */
+    __u32 len;
+    char label[BTRFS_LABEL_SIZE];
+};
+
  /*
   * inode items have the data typically returned from stat and store other
   * info about object characteristics.  There is one for every file and 
dir in
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..9e01628 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -268,6 +268,41 @@ static int btrfs_ioctl_getversion(struct file 
*file, int __user *arg)
      return put_user(inode->i_generation, arg);
  }

+static int btrfs_ioctl_fs_setlabel(struct btrfs_root *root, void __user 
*arg)
+{
+    struct btrfs_super_block *super_block = &(root->fs_info->super_copy);
+    struct btrfs_ioctl_fs_label_args *label_args;
+    struct btrfs_trans_handle *trans;
+
+    if (!capable(CAP_SYS_ADMIN))
+        return -EPERM;
+
+    if (btrfs_root_readonly(root))
+        return -EROFS;
+
+    label_args = memdup_user(arg, sizeof(*label_args));
+    if (IS_ERR(label_args))
+        return PTR_ERR(label_args);
+
+    if (label_args->len >= sizeof(label_args->label))
+        return -EINVAL;
+
+    mutex_lock(&root->fs_info->volume_mutex);
+    trans = btrfs_start_transaction(root, 0);
+    if (IS_ERR(trans))
+        return PTR_ERR(trans);
+
+    if (snprintf(super_block->label, BTRFS_LABEL_SIZE, "%s",
+             label_args->label) != label_args->len)
+        return -EFAULT;
+
+    btrfs_end_transaction(trans, root);
+    mutex_unlock(&root->fs_info->volume_mutex);
+
+    kfree(label_args);
+    return 0;
+}
+
  static noinline int btrfs_ioctl_fitrim(struct file *file, void __user 
*arg)
  {
      struct btrfs_root *root = fdentry(file)->d_sb->s_fs_info;
@@ -2876,6 +2911,8 @@ long btrfs_ioctl(struct file *file, unsigned int
          return btrfs_ioctl_fs_info(root, argp);
      case BTRFS_IOC_DEV_INFO:
          return btrfs_ioctl_dev_info(root, argp);
+    case BTRFS_IOC_FS_SETLABEL:
+        return btrfs_ioctl_fs_setlabel(root, argp);
      case BTRFS_IOC_BALANCE:
          return btrfs_balance(root->fs_info->dev_root);
      case BTRFS_IOC_CLONE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ad1ea78..1e0ca2a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -248,4 +248,6 @@ struct btrfs_ioctl_space_args {
                   struct btrfs_ioctl_dev_info_args)
  #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
                     struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 32, \
+                   struct btrfs_ioctl_fs_label_args)
  #endif
-- 
1.7.4.1

