Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35671 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbcEDJvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 05:51:17 -0400
Received: by mail-io0-f196.google.com with SMTP id u185so6030116iod.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 02:51:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1462354346-17654-1-git-send-email-dsterba@suse.com>
References: <1462354346-17654-1-git-send-email-dsterba@suse.com>
Date: Wed, 4 May 2016 10:51:11 +0100
Message-ID: <CAL3q7H4X5NjNFGRp8oj87pkHkZxPMvicM7=Kh0r-MCkO7Y__yA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: ioctl: reorder exclusive op check in RM_DEV
From: Filipe Manana <fdmanana@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2016 at 10:32 AM, David Sterba <dsterba@suse.com> wrote:
> From: David Sterba <dsterba@suse.cz>
>
> Move the op exclusivity check before the other code (same as in
> ADD_DEV).
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ioctl.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e3239272fa61..45beb6dd8417 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2680,32 +2680,31 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>         if (ret)
>                 return ret;
>
> +       if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
> +                       1)) {
> +               ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
> +               goto out_drop_write;
> +       }
> +
>         vol_args = memdup_user(arg, sizeof(*vol_args));
>         if (IS_ERR(vol_args)) {
>                 ret = PTR_ERR(vol_args);
> -               goto err_drop;
> +               goto out_drop_write;

goto out, otherwise
root->fs_info->mutually_exclusive_operation_running remains with value
1 forever...

>         }
>
>         vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
> -
> -       if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
> -                       1)) {
> -               ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
> -               goto out;
> -       }
> -
>         mutex_lock(&root->fs_info->volume_mutex);
>         ret = btrfs_rm_device(root, vol_args->name);
>         mutex_unlock(&root->fs_info->volume_mutex);
> -       atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
>
>         if (!ret)
>                 btrfs_info(root->fs_info, "disk deleted %s",vol_args->name);
> -
> -out:
>         kfree(vol_args);
> -err_drop:
> +out:
> +       atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
> +out_drop_write:
>         mnt_drop_write_file(file);
> +
>         return ret;
>  }
>
> --
> 2.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
