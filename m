Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34009 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932491AbcJLJJ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 05:09:58 -0400
Received: by mail-io0-f194.google.com with SMTP id i202so2665089ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 02:09:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476259970-1866-2-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com> <1476259970-1866-2-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 12 Oct 2016 10:09:55 +0100
Message-ID: <CAL3q7H5Mo=tw-exEa7Fpzu=sMYSFJH6=sdJT7MVZJYWk4LuxWw@mail.gmail.com>
Subject: Re: [PATCH 1/5] Btrfs: incremental send, fix don't skip root inode in overwrite_ref
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 9:12 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> When root dir item change, don't skip will_overwrite_ref,
> because root inode always exist.

What do you mean by root dir item change? You mean indoe 256 changed,
how did it change (and how can it change)?

>
> Example:
> Parent snapshot:
> |---- a1/ (ino 257, dir)
> |---- a2/ (ino 258, dir)
>
> Send snapshot:
> |---- a2 (ino 257, file)
>
> ERROR: rename o257-29-0 -> a2 failed: Is a directory
>
> when process 257, first rmdir (ino 257,dir), and then mkfile o257-29-0,
> and rename o257-29-0 -> a2, but now parent snapshot had a2(ino 258,dir),
> we don't ignore it.
>
> therefore is_inode_existent always return 1,
> and will_overwrite_ref don't check gen for root inode.

Please refer to change logs of past send fixes to have an idea on how
to describe and explain the problem (and fix).

Also, can you please start sending xfstests too?
Last batch of send fixes you've sent, I've asked you to do them, but
you totally ignored it and later on I had to do them myself and
rewrite all change logs (and remove some unnecessary code).

Thanks.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index a87675f..1862f8a 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1681,6 +1681,10 @@ static int is_inode_existent(struct send_ctx *sctx, u64 ino, u64 gen)
>  {
>         int ret;
>
> +       if (ino == BTRFS_FIRST_FREE_OBJECTID) {
> +               return 1;
> +       }
> +
>         ret = get_cur_inode_state(sctx, ino, gen);
>         if (ret < 0)
>                 goto out;
> @@ -1866,7 +1870,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>          * not deleted and then re-created, if it was then we have no overwrite
>          * and we can just unlink this entry.
>          */
> -       if (sctx->parent_root) {
> +       if (sctx->parent_root && dir != BTRFS_FIRST_FREE_OBJECTID) {
>                 ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL,
>                                      NULL, NULL, NULL);
>                 if (ret < 0 && ret != -ENOENT)
> --
> 1.9.1
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
