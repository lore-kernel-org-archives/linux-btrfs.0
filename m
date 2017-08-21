Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38260 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdHUJVR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <eea2ad68-7f8d-bbe4-1cdf-6439a46fb04e@users.sourceforge.net>
References: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net> <eea2ad68-7f8d-bbe4-1cdf-6439a46fb04e@users.sourceforge.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 Aug 2017 12:20:36 +0300
Message-ID: <CAGqmi74Fu_i4ah_EbSwXsvAAoo1btATgyLHcj7g2qD=mGD8Pzg@mail.gmail.com>
Subject: Re: [PATCH 3/4] btrfs: Improve eight size determinations
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You use that doc [1], so it's okay, because that's style are more safe.
But i don't think that at now such cleanups are really usefull at now.
Because that's not improve anything.

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

[1] - https://www.kernel.org/doc/html/v4.12/process/coding-style.html#allocating-memory

2017-08-20 23:19 GMT+03:00 SF Markus Elfring <elfring@users.sourceforge.net>:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 20 Aug 2017 21:55:56 +0200
>
> Replace the specification of data types by pointer dereferences
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/btrfs/ctree.c         | 10 ++++------
>  fs/btrfs/delayed-inode.c |  4 ++--
>  fs/btrfs/raid56.c        |  2 +-
>  fs/btrfs/super.c         |  2 +-
>  4 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index b89c101ef45e..3b49f39eaaf6 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -578,7 +578,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>         if (!tree_mod_need_log(fs_info, eb))
>                 return 0;
>
> -       tm_list = kcalloc(nr_items, sizeof(struct tree_mod_elem *), GFP_NOFS);
> +       tm_list = kcalloc(nr_items, sizeof(*tm_list), GFP_NOFS);
>         if (!tm_list)
>                 return -ENOMEM;
>
> @@ -677,8 +677,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>
>         if (log_removal && btrfs_header_level(old_root) > 0) {
>                 nritems = btrfs_header_nritems(old_root);
> -               tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *),
> -                                 GFP_NOFS);
> +               tm_list = kcalloc(nritems, sizeof(*tm_list), GFP_NOFS);
>                 if (!tm_list) {
>                         ret = -ENOMEM;
>                         goto free_tms;
> @@ -813,8 +812,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>         if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0)
>                 return 0;
>
> -       tm_list = kcalloc(nr_items * 2, sizeof(struct tree_mod_elem *),
> -                         GFP_NOFS);
> +       tm_list = kcalloc(nr_items * 2, sizeof(*tm_list), GFP_NOFS);
>         if (!tm_list)
>                 return -ENOMEM;
>
> @@ -904,7 +902,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
>                 return 0;
>
>         nritems = btrfs_header_nritems(eb);
> -       tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *), GFP_NOFS);
> +       tm_list = kcalloc(nritems, sizeof(*tm_list), GFP_NOFS);
>         if (!tm_list)
>                 return -ENOMEM;
>
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 19e4ad2f3f2e..865aaca445b9 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -750,13 +750,13 @@ static int btrfs_batch_insert_items(struct btrfs_root *root,
>          */
>         btrfs_set_path_blocking(path);
>
> -       keys = kmalloc_array(nitems, sizeof(struct btrfs_key), GFP_NOFS);
> +       keys = kmalloc_array(nitems, sizeof(*keys), GFP_NOFS);
>         if (!keys) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
>
> -       data_size = kmalloc_array(nitems, sizeof(u32), GFP_NOFS);
> +       data_size = kmalloc_array(nitems, sizeof(*data_size), GFP_NOFS);
>         if (!data_size) {
>                 ret = -ENOMEM;
>                 goto error;
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 208638384cd2..c85f0f534532 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1798,7 +1798,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
>         int err;
>         int i;
>
> -       pointers = kcalloc(rbio->real_stripes, sizeof(void *), GFP_NOFS);
> +       pointers = kcalloc(rbio->real_stripes, sizeof(*pointers), GFP_NOFS);
>         if (!pointers) {
>                 err = -ENOMEM;
>                 goto cleanup_io;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 0b7a1d8cd08b..cd2ba5e3b2d0 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1571,7 +1571,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>          * it for searching for existing supers, so this lets us do that and
>          * then open_ctree will properly initialize everything later.
>          */
> -       fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_KERNEL);
> +       fs_info = kzalloc(sizeof(*fs_info), GFP_KERNEL);
>         if (!fs_info) {
>                 error = -ENOMEM;
>                 goto error_sec_opts;
> --
> 2.14.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
