Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34791 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752809AbcJLLU5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 07:20:57 -0400
Received: by mail-io0-f194.google.com with SMTP id i202so2845842ioi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 04:20:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476259970-1866-5-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com> <1476259970-1866-5-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 12 Oct 2016 10:14:42 +0100
Message-ID: <CAL3q7H4eRChWT8kPvrzMSmqbfroMoZi5GkDxd8w+Ved5Y_VviA@mail.gmail.com>
Subject: Re: [PATCH 4/5] Btrfs: incremental send, add gen check in did_overwrite_ref
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 9:12 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> There a some case similar as before.

As before what?
Each change log should be complete and the reader is not supposed to
guess what's the previous patch or commit this is referring to.
Imagine yourself or someone else reading the change log some time
after this is committed to a git tree. How does he/she figures out
what is "before", what commit or patch is it?

> add check parent generation in the did_overwrite_ref.

Please add some explanation of what problem is being fixed and how.
This change log has absolutely no value.

Also, can you please start sending xfstests too?
Last batch of send fixes you've sent, I've asked you to do them, but
you totally ignored it and later on I had to do them myself and
rewrite all change logs (and remove some unnecessary code).

Thanks.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index d908624..e090db2 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1939,6 +1939,19 @@ static int did_overwrite_ref(struct send_ctx *sctx,
>         if (ret <= 0)
>                 goto out;
>
> +       if (dir != BTRFS_FIRST_FREE_OBJECTID) {
> +               ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL,
> +                                    NULL, NULL, NULL);
> +               if (ret < 0 && ret != -ENOENT)
> +                       goto out;
> +               if (ret) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +               if (gen != dir_gen)
> +                       goto out;
> +       }
> +
>         /* check if the ref was overwritten by another ref */
>         ret = lookup_dir_item_inode(sctx->send_root, dir, name, name_len,
>                         &ow_inode, &other_type);
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
