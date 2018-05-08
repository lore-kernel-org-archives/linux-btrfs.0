Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:34098 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbeEHTEd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 15:04:33 -0400
Received: by mail-ua0-f195.google.com with SMTP id f22so21373182uam.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 12:04:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1525774298-6919-2-git-send-email-robbieko@synology.com>
References: <1525774298-6919-1-git-send-email-robbieko@synology.com> <1525774298-6919-2-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 8 May 2018 20:04:31 +0100
Message-ID: <CAL3q7H7t_GLym37vOR5-hij-u=2t2eVdfV+60vpoBA6oAz7i-w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs: incremental send, optimization add orphan_dir_info
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 8, 2018 at 11:11 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> moving the allocation to the end in order to avoid unnecessary
> allocations
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/send.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 484e2af..2830871 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2855,12 +2855,6 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
>         struct rb_node *parent = NULL;
>         struct orphan_dir_info *entry, *odi;
>
> -       odi = kmalloc(sizeof(*odi), GFP_KERNEL);
> -       if (!odi)
> -               return ERR_PTR(-ENOMEM);
> -       odi->ino = dir_ino;
> -       odi->gen = 0;
> -
>         while (*p) {
>                 parent = *p;
>                 entry = rb_entry(parent, struct orphan_dir_info, node);
> @@ -2869,11 +2863,16 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
>                 } else if (dir_ino > entry->ino) {
>                         p = &(*p)->rb_right;
>                 } else {
> -                       kfree(odi);
>                         return entry;
>                 }
>         }
>
> +       odi = kmalloc(sizeof(*odi), GFP_KERNEL);
> +       if (!odi)
> +               return ERR_PTR(-ENOMEM);
> +       odi->ino = dir_ino;
> +       odi->gen = 0;
> +
>         rb_link_node(&odi->node, parent, p);
>         rb_insert_color(&odi->node, &sctx->orphan_dirs);
>         return odi;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
