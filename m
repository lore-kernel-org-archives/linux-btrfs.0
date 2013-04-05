Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39963 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161601Ab3DENFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 09:05:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5E4D89A041D
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2013 07:05:06 -0600 (MDT)
Date: Fri, 5 Apr 2013 09:05:03 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
Message-ID: <20130405130503.GR1876@localhost.localdomain>
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 05, 2013 at 05:38:16AM -0600, Jan Schmidt wrote:
> If qgroup tracking is out of sync, a rescan operation can be started to
> iterate the extent tree and recalculate all qgroup tracking data.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.h           |   17 ++-
>  fs/btrfs/disk-io.c         |    6 +
>  fs/btrfs/ioctl.c           |   83 +++++++++++---
>  fs/btrfs/qgroup.c          |  271 +++++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/btrfs.h |   11 ++-
>  5 files changed, 354 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0d82922..bd4e2a7 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1019,9 +1019,9 @@ struct btrfs_block_group_item {
>   */
>  #define BTRFS_QGROUP_STATUS_FLAG_ON            (1ULL << 0)
>  /*
> - * SCANNING is set during the initialization phase
> + * RESCAN is set during the initialization phase
>   */
> -#define BTRFS_QGROUP_STATUS_FLAG_SCANNING      (1ULL << 1)
> +#define BTRFS_QGROUP_STATUS_FLAG_RESCAN                (1ULL << 1)
>  /*
>   * Some qgroup entries are known to be out of date,
>   * either because the configuration has changed in a way that
> @@ -1050,7 +1050,7 @@ struct btrfs_qgroup_status_item {
>          * only used during scanning to record the progress
>          * of the scan. It contains a logical address
>          */
> -       __le64 scan;
> +       __le64 rescan;
>  } __attribute__ ((__packed__));
> 
>  struct btrfs_qgroup_info_item {
> @@ -1587,6 +1587,11 @@ struct btrfs_fs_info {
>         /* used by btrfs_qgroup_record_ref for an efficient tree traversal */
>         u64 qgroup_seq;
> 
> +       /* qgroup rescan items */
> +       struct mutex qgroup_rescan_lock; /* protects the progress item */
> +       struct btrfs_key qgroup_rescan_progress;
> +       struct btrfs_workers qgroup_rescan_workers;
> +
>         /* filesystem state */
>         unsigned long fs_state;
> 
> @@ -2864,8 +2869,8 @@ BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
>                    version, 64);
>  BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
>                    flags, 64);
> -BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
> -                  scan, 64);
> +BTRFS_SETGET_FUNCS(qgroup_status_rescan, struct btrfs_qgroup_status_item,
> +                  rescan, 64);
> 
>  /* btrfs_qgroup_info_item */
>  BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
> @@ -3784,7 +3789,7 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>                        struct btrfs_fs_info *fs_info);
>  int btrfs_quota_disable(struct btrfs_trans_handle *trans,
>                         struct btrfs_fs_info *fs_info);
> -int btrfs_quota_rescan(struct btrfs_fs_info *fs_info);
> +int btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info);
>  int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
>                               struct btrfs_fs_info *fs_info, u64 src, u64 dst);
>  int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6d19a0a..60d15fe 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2192,6 +2192,7 @@ int open_ctree(struct super_block *sb,
>         fs_info->qgroup_seq = 1;
>         fs_info->quota_enabled = 0;
>         fs_info->pending_quota_state = 0;
> +       mutex_init(&fs_info->qgroup_rescan_lock);
> 
>         btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
>         btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
> @@ -2394,6 +2395,8 @@ int open_ctree(struct super_block *sb,
>         btrfs_init_workers(&fs_info->readahead_workers, "readahead",
>                            fs_info->thread_pool_size,
>                            &fs_info->generic_worker);
> +       btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
> +                          &fs_info->generic_worker);
> 
>         /*
>          * endios are largely parallel and should have a very
> @@ -2428,6 +2431,7 @@ int open_ctree(struct super_block *sb,
>         ret |= btrfs_start_workers(&fs_info->caching_workers);
>         ret |= btrfs_start_workers(&fs_info->readahead_workers);
>         ret |= btrfs_start_workers(&fs_info->flush_workers);
> +       ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
>         if (ret) {
>                 err = -ENOMEM;
>                 goto fail_sb_buffer;
> @@ -2773,6 +2777,7 @@ fail_sb_buffer:
>         btrfs_stop_workers(&fs_info->delayed_workers);
>         btrfs_stop_workers(&fs_info->caching_workers);
>         btrfs_stop_workers(&fs_info->flush_workers);
> +       btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
>  fail_alloc:
>  fail_iput:
>         btrfs_mapping_tree_free(&fs_info->mapping_tree);
> @@ -3463,6 +3468,7 @@ int close_ctree(struct btrfs_root *root)
>         btrfs_stop_workers(&fs_info->caching_workers);
>         btrfs_stop_workers(&fs_info->readahead_workers);
>         btrfs_stop_workers(&fs_info->flush_workers);
> +       btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
> 
>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>         if (btrfs_test_opt(root, CHECK_INTEGRITY))
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 898c572..a4681fb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3693,12 +3693,10 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>                 goto drop_write;
>         }
> 
> -       if (sa->cmd != BTRFS_QUOTA_CTL_RESCAN) {
> -               trans = btrfs_start_transaction(root, 2);
> -               if (IS_ERR(trans)) {
> -                       ret = PTR_ERR(trans);
> -                       goto out;
> -               }
> +       trans = btrfs_start_transaction(root, 2);
> +       if (IS_ERR(trans)) {
> +               ret = PTR_ERR(trans);
> +               goto out;
>         }
> 
>         switch (sa->cmd) {
> @@ -3708,9 +3706,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>         case BTRFS_QUOTA_CTL_DISABLE:
>                 ret = btrfs_quota_disable(trans, root->fs_info);
>                 break;
> -       case BTRFS_QUOTA_CTL_RESCAN:
> -               ret = btrfs_quota_rescan(root->fs_info);
> -               break;
>         default:
>                 ret = -EINVAL;
>                 break;
> @@ -3719,11 +3714,9 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
>         if (copy_to_user(arg, sa, sizeof(*sa)))
>                 ret = -EFAULT;
> 
> -       if (trans) {
> -               err = btrfs_commit_transaction(trans, root);
> -               if (err && !ret)
> -                       ret = err;
> -       }
> +       err = btrfs_commit_transaction(trans, root);
> +       if (err && !ret)
> +               ret = err;
>  out:
>         kfree(sa);
>  drop_write:
> @@ -3877,6 +3870,64 @@ drop_write:
>         return ret;
>  }
> 
> +static long btrfs_ioctl_quota_rescan(struct file *file, void __user *arg)
> +{
> +       struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +       struct btrfs_ioctl_quota_rescan_args *qsa;
> +       int ret;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       ret = mnt_want_write_file(file);
> +       if (ret)
> +               return ret;
> +
> +       qsa = memdup_user(arg, sizeof(*qsa));
> +       if (IS_ERR(qsa)) {
> +               ret = PTR_ERR(qsa);
> +               goto drop_write;
> +       }
> +
> +       if (qsa->flags) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       ret = btrfs_qgroup_rescan(root->fs_info);
> +
> +out:
> +       kfree(qsa);
> +drop_write:
> +       mnt_drop_write_file(file);
> +       return ret;
> +}
> +
> +static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
> +{
> +       struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +       struct btrfs_ioctl_quota_rescan_args *qsa;
> +       int ret = 0;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       qsa = kzalloc(sizeof(*qsa), GFP_NOFS);
> +       if (IS_ERR(qsa))
> +               return PTR_ERR(qsa);
> +

IIRC kzalloc returns NULL if something was wrong, not an ERR_PTR().  Thanks,

Josef
