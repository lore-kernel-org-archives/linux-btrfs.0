Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41647 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3GWNEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 09:04:38 -0400
Received: by mail-ob0-f169.google.com with SMTP id up14so10182411obb.14
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 06:04:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51EE13DB.5060205@cn.fujitsu.com>
References: <51EE13DB.5060205@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 21:04:37 +0800
Message-ID: <CAP9B-QkK5ee=gvCCK-jfZ4eWbnGj6=s8VEXibJv0F24Ou=HtMg@mail.gmail.com>
Subject: Re: [PATCH 1/3] Btrfs: add sanity checks regarding to parsing mount options
From: Shilong Wang <wangshilong1991@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am sorry for wrong format patch, please ignore this patchset, i will resend
them later.

Thank,
Wang
2013/7/23 Wang Shilong <wangsl.fnst@cn.fujitsu.com>:
> I just notice the following commands succeed:
>         mount <dev> <mnt> -o thread_pool=-1
>
> This is ridiculous, only positive thread_pool makes sense,this
> patch adds sanity checks for them, and also catches the error of
> ENOMEM if allocating memory fails.
>
> Signed-off-by: Wang Shilong<wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie<miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/super.c | 47 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8eb6191..cc00295 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -496,10 +496,15 @@ int btrfs_parse_options(struct btrfs_root *root, char
> *options)
>                         btrfs_set_opt(info->mount_opt, NOBARRIER);
>                         break;
>                 case Opt_thread_pool:
> -                       intarg = 0;
> -                       match_int(&args[0], &intarg);
> -                       if (intarg)
> +                       ret = match_int(&args[0], &intarg);
> +                       if (ret) {
> +                               goto out;
> +                       } else if (intarg > 0) {
>                                 info->thread_pool_size = intarg;
> +                       } else {
> +                               ret = -EINVAL;
> +                               goto out;
> +                       }
>                         break;
>                 case Opt_max_inline:
>                         num = match_strdup(&args[0]);
> @@ -514,6 +519,9 @@ int btrfs_parse_options(struct btrfs_root *root, char
> *options)
>                                 }
>                                 printk(KERN_INFO "btrfs: max_inline at
> %llu\n",
>                                         (unsigned long
> long)info->max_inline);
> +                       } else {
> +                               ret = -ENOMEM;
> +                               goto out;
>                         }
>                         break;
>                 case Opt_alloc_start:
> @@ -526,6 +534,9 @@ int btrfs_parse_options(struct btrfs_root *root, char
> *options)
>                                 printk(KERN_INFO
>                                         "btrfs: allocations start at
> %llu\n",
>                                         (unsigned long
> long)info->alloc_start);
> +                       } else {
> +                               ret = -ENOMEM;
> +                               goto out;
>                         }
>                         break;
>                 case Opt_noacl:
> @@ -540,12 +551,16 @@ int btrfs_parse_options(struct btrfs_root *root, char
> *options)
>                         btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
>                         break;
>                 case Opt_ratio:
> -                       intarg = 0;
> -                       match_int(&args[0], &intarg);
> -                       if (intarg) {
> +                       ret = match_int(&args[0], &intarg);
> +                       if (ret) {
> +                               goto out;
> +                       } else if (intarg >= 0) {
>                                 info->metadata_ratio = intarg;
>                                 printk(KERN_INFO "btrfs: metadata ratio
> %d\n",
>                                        info->metadata_ratio);
> +                       } else {
> +                               ret = -EINVAL;
> +                               goto out;
>                         }
>                         break;
>                 case Opt_discard:
> @@ -596,13 +611,17 @@ int btrfs_parse_options(struct btrfs_root *root, char
> *options)
>                         btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
>                         break;
>                 case Opt_check_integrity_print_mask:
> -                       intarg = 0;
> -                       match_int(&args[0], &intarg);
> -                       if (intarg) {
> +                       ret = match_int(&args[0], &intarg);
> +                       if (ret) {
> +                               goto out;
> +                       } else if (intarg >= 0) {
>                                 info->check_integrity_print_mask = intarg;
>                                 printk(KERN_INFO "btrfs:"
>                                        " check_integrity_print_mask 0x%x\n",
>                                        info->check_integrity_print_mask);
> +                       } else {
> +                               ret = -EINVAL;
> +                               goto out;
>                         }
>                         break;
>  #else
> @@ -679,17 +698,25 @@ static int btrfs_parse_early_options(const char
> *options, fmode_t flags,
>                 case Opt_subvol:
>                         kfree(*subvol_name);
>                         *subvol_name = match_strdup(&args[0]);
> +                       if (!*subvol_name) {
> +                               error = -ENOMEM;
> +                               goto out;
> +                       }
>                         break;
>                 case Opt_subvolid:
> -                       intarg = 0;
>                         error = match_int(&args[0], &intarg);
>                         if (!error) {
> +                               goto out;
> +                       } else if (intarg >= 0) {
>                                 /* we want the original fs_tree */
>                                 if (!intarg)
>                                         *subvol_objectid =
>                                                 BTRFS_FS_TREE_OBJECTID;
>                                 else
>                                         *subvol_objectid = intarg;
> +                       } else {
> +                               error = -EINVAL;
> +                               goto out;
>                         }
>                         break;
>                 case Opt_subvolrootid:
> -- 1.8.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
