From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] Btrfs: added new ioctl to set fs label V3
Date: Mon, 05 Sep 2011 15:30:03 +0800
Message-ID: <4E647A7B.7000009@oracle.com>
References: <4E5F47C7.3030803@oracle.com> <4E5F7216.7040909@oracle.com> <20110902125208.GF11678@ds.suse.cz> <4E60D67E.2070903@oracle.com> <20110902154810.GH11678@ds.suse.cz> <46CBCF59-89E1-4A80-B85D-17C65F695247@oracle.com> <20110904170301.GE9907@carfax.org.uk>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110904170301.GE9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

According to Hugo and David's advise, the ioctl number of 
BTRFS_IOC_FS_SETLABEL ioctl was changed to 50 now.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
  fs/btrfs/ctree.h |    4 ++++
  fs/btrfs/ioctl.c |   36 ++++++++++++++++++++++++++++++++++++
  fs/btrfs/ioctl.h |    2 ++
  3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..a4669f0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1259,6 +1259,10 @@ struct btrfs_ioctl_defrag_range_args {
  };


+struct btrfs_ioctl_fs_label_args {
+    char label[BTRFS_LABEL_SIZE];
+};
+
  /*
   * inode items have the data typically returned from stat and store other
   * info about object characteristics.  There is one for every file and 
dir in
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..c872e88 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -268,6 +268,40 @@ static int btrfs_ioctl_getversion(struct file 
*file, int __user *arg)
      return put_user(inode->i_generation, arg);
  }

+static int btrfs_ioctl_fs_setlabel(struct btrfs_root *root, void __user 
*arg)
+{
+    struct btrfs_super_block *super_block = &(root->fs_info->super_copy);
+    struct btrfs_ioctl_fs_label_args *label_args;
+    struct btrfs_trans_handle *trans;
+    int ret;
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
+    label_args->label[BTRFS_LABEL_SIZE - 1] = '\0';
+
+    mutex_lock(&root->fs_info->volume_mutex);
+    trans = btrfs_start_transaction(root, 0);
+    if (IS_ERR(trans)) {
+        ret = PTR_ERR(trans);
+        goto out_unlock;
+    }
+    strcpy(super_block->label, label_args->label);
+    btrfs_end_transaction(trans, root);
+
+out_unlock:
+    mutex_unlock(&root->fs_info->volume_mutex);
+    kfree(label_args);
+    return 0;
+}
+
  static noinline int btrfs_ioctl_fitrim(struct file *file, void __user 
*arg)
  {
      struct btrfs_root *root = fdentry(file)->d_sb->s_fs_info;
@@ -2876,6 +2910,8 @@ long btrfs_ioctl(struct file *file, unsigned int
          return btrfs_ioctl_fs_info(root, argp);
      case BTRFS_IOC_DEV_INFO:
          return btrfs_ioctl_dev_info(root, argp);
+    case BTRFS_IOC_FS_SETLABEL:
+        return btrfs_ioctl_fs_setlabel(root, argp);
      case BTRFS_IOC_BALANCE:
          return btrfs_balance(root->fs_info->dev_root);
      case BTRFS_IOC_CLONE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index ad1ea78..1117fe8 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -248,4 +248,6 @@ struct btrfs_ioctl_space_args {
                   struct btrfs_ioctl_dev_info_args)
  #define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
                     struct btrfs_ioctl_fs_info_args)
+#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
+                   struct btrfs_ioctl_fs_label_args)
  #endif
-- 
1.7.4.1

