Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34445 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbcGLIpN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 04:45:13 -0400
Received: by mail-it0-f66.google.com with SMTP id u186so627446ita.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 01:45:13 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 12 Jul 2016 09:45:12 +0100
Message-ID: <CAL3q7H4qi-NawAJwxNcbsYRsw3rZ_os5YGn54sW1v=8pqoO8rA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix unexpected balance crash due to BUG_ON
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>

On Mon, Jul 11, 2016 at 6:21 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Mounting a btrfs can resume previous balance operations asynchronously.
> An user got a crash when one drive has some corrupt sectors.
>
> Since balance can cancel itself in case of any error, we can gracefully
> return errors to upper layers and let balance do the cancel job.
>
> Reported-by: sash <master.b.at.raven@chefmail.de>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: - Initialize path with NULL.
>     - Show more information when we bail out.
>
>  fs/btrfs/volumes.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 589f128..348a183 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3421,7 +3421,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>         u64 size_to_free;
>         u64 chunk_type;
>         struct btrfs_chunk *chunk;
> -       struct btrfs_path *path;
> +       struct btrfs_path *path = NULL;
>         struct btrfs_key key;
>         struct btrfs_key found_key;
>         struct btrfs_trans_handle *trans;
> @@ -3455,13 +3455,35 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>                 ret = btrfs_shrink_device(device, old_size - size_to_free);
>                 if (ret == -ENOSPC)
>                         break;
> -               BUG_ON(ret);
> +               if (ret) {
> +                       /* btrfs_shrink_device never returns ret > 0 */
> +                       WARN_ON(ret > 0);
> +                       goto error;
> +               }
>
>                 trans = btrfs_start_transaction(dev_root, 0);
> -               BUG_ON(IS_ERR(trans));
> +               if (IS_ERR(trans)) {
> +                       ret = PTR_ERR(trans);
> +                       btrfs_info(fs_info,
> +                "%s:%d fails on btrfs_start_transaction() right after shrinking devivce %s (original size is %llu new size is %llu",

devivce -> device

> +                                  __func__, __LINE__,
> +                                  rcu_str_deref(device->name), old_size,
> +                                  old_size - size_to_free);
> +                       goto error;
> +               }
>
>                 ret = btrfs_grow_device(trans, device, old_size);
> -               BUG_ON(ret);
> +               if (ret) {
> +                       btrfs_end_transaction(trans, dev_root);
> +                       /* btrfs_grow_device never returns ret > 0 */
> +                       WARN_ON(ret > 0);
> +                       btrfs_info(fs_info,
> +                "%s:%d fails on btrfs_grow_device() right after shrinking devivce %s (original size is %llu new size is %llu",

devivce -> device

> +                                  __func__, __LINE__,
> +                                  rcu_str_deref(device->name), old_size,
> +                                  old_size - size_to_free);
> +                       goto error;
> +               }
>
>                 btrfs_end_transaction(trans, dev_root);
>         }
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
