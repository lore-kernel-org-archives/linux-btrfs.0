Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:43051 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964827AbeEJPZl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 11:25:41 -0400
Received: by mail-vk0-f67.google.com with SMTP id x191-v6so1422609vke.10
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 08:25:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <35b9fda73e091d42845d5bbf34607c052da1147f.1525932796.git.osandov@fb.com>
References: <cover.1525932796.git.osandov@fb.com> <35b9fda73e091d42845d5bbf34607c052da1147f.1525932796.git.osandov@fb.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 10 May 2018 16:25:40 +0100
Message-ID: <CAL3q7H4rWVtY0tDxcftTj0XaNa1Y_NHSL-T=hppa7Xm0RgxH_w@mail.gmail.com>
Subject: Re: [PATCH 10/10] Btrfs: reserve space for O_TMPFILE orphan item deletion
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 7:21 AM, Omar Sandoval <osandov@osandov.com> wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> btrfs_link() calls btrfs_orphan_del() if it's linking an O_TMPFILE but
> it doesn't reserve space to do so. Even before the removal of the
> orphan_block_rsv it wasn't using it.
>
> Fixes: ef3b9af50bfa ("Btrfs: implement inode_operations callback tmpfile")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 88b89a48b66f..2a610a8d30c4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6535,8 +6535,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>          * 2 items for inode and inode ref
>          * 2 items for dir items
>          * 1 item for parent inode
> +        * 1 item for orphan item deletion if O_TMPFILE
>          */
> -       trans = btrfs_start_transaction(root, 5);
> +       trans = btrfs_start_transaction(root, inode->i_nlink ? 5 : 6);
>         if (IS_ERR(trans)) {
>                 err = PTR_ERR(trans);
>                 trans = NULL;
> --
> 2.17.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
