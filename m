Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:45634 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeG3PC7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 11:02:59 -0400
Received: by mail-ua0-f196.google.com with SMTP id k8-v6so7802081uaq.12
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2018 06:27:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180727000455.2647-1-naota@elisp.net>
References: <20180727000455.2647-1-naota@elisp.net>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 30 Jul 2018 14:27:58 +0100
Message-ID: <CAL3q7H7zHc1NMJfAC7JQ1Ugo-n5+Z_w_ZfXTm=xNjsD58AJWZw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: revert fs_devices state on error of btrfs_init_new_device()
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 27, 2018 at 1:04 AM, Naohiro Aota <naota@elisp.net> wrote:
> When btrfs hits error after modifying fs_devices in
> btrfs_init_new_device() (such as btrfs_add_dev_item() returns error), it
> leaves everything as is, but frees allocated btrfs_device. As a result,
> fs_devices->devices and fs_devices->alloc_list contain already freed
> btrfs_device, leading to later use-after-free bug.
>
> Error path also messes the things like ->num_devices. While they go backs
> to the original value by unscanning btrfs devices, it is safe to revert
> them here.
>
> Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, only fs_info->fs_devices->rotating isn't restored but
currently that causes no problems.

> ---
>  fs/btrfs/volumes.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>
>  This patch applies on master, but not on kdave/for-next because of
>  74b9f4e186eb ("btrfs: declare fs_devices in btrfs_init_new_device()")
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1da162928d1a..5f0512fffa52 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2410,7 +2410,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>         struct list_head *devices;
>         struct super_block *sb = fs_info->sb;
>         struct rcu_string *name;
> -       u64 tmp;
> +       u64 orig_super_total_bytes, orig_super_num_devices;
>         int seeding_dev = 0;
>         int ret = 0;
>         bool unlocked = false;
> @@ -2509,12 +2509,14 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>         if (!blk_queue_nonrot(q))
>                 fs_info->fs_devices->rotating = 1;
>
> -       tmp = btrfs_super_total_bytes(fs_info->super_copy);
> +       orig_super_total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
>         btrfs_set_super_total_bytes(fs_info->super_copy,
> -               round_down(tmp + device->total_bytes, fs_info->sectorsize));
> +               round_down(orig_super_total_bytes + device->total_bytes,
> +                          fs_info->sectorsize));
>
> -       tmp = btrfs_super_num_devices(fs_info->super_copy);
> -       btrfs_set_super_num_devices(fs_info->super_copy, tmp + 1);
> +       orig_super_num_devices = btrfs_super_num_devices(fs_info->super_copy);
> +       btrfs_set_super_num_devices(fs_info->super_copy,
> +                                   orig_super_num_devices + 1);
>
>         /* add sysfs device entry */
>         btrfs_sysfs_add_device_link(fs_info->fs_devices, device);
> @@ -2594,6 +2596,22 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>
>  error_sysfs:
>         btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
> +       mutex_lock(&fs_info->fs_devices->device_list_mutex);
> +       mutex_lock(&fs_info->chunk_mutex);
> +       list_del_rcu(&device->dev_list);
> +       list_del(&device->dev_alloc_list);
> +       fs_info->fs_devices->num_devices--;
> +       fs_info->fs_devices->open_devices--;
> +       fs_info->fs_devices->rw_devices--;
> +       fs_info->fs_devices->total_devices--;
> +       fs_info->fs_devices->total_rw_bytes -= device->total_bytes;
> +       atomic64_sub(device->total_bytes, &fs_info->free_chunk_space);
> +       btrfs_set_super_total_bytes(fs_info->super_copy,
> +                                   orig_super_total_bytes);
> +       btrfs_set_super_num_devices(fs_info->super_copy,
> +                                   orig_super_num_devices);
> +       mutex_unlock(&fs_info->chunk_mutex);
> +       mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>  error_trans:
>         if (seeding_dev)
>                 sb->s_flags |= SB_RDONLY;
> --
> 2.18.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
