Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34797 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbFDQY5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 12:24:57 -0400
Received: by iebmu5 with SMTP id mu5so4754622ieb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 09:24:54 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433416690-19177-4-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-4-git-send-email-robbieko@synology.com>
Date: Thu, 4 Jun 2015 17:24:54 +0100
Message-ID: <CAL3q7H5Rj48S8BGT4xy+3pHhcwmNTAiEQB9ra3VLAOxfpcAeAw@mail.gmail.com>
Subject: Re: [PATCH 3/5] Btrfs: incremental send, fix orphan_dir_info not
 completely cleared
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
> There's one case where we not clear orphan_dir_info issue.

You mean where we leak a orphan_dir_info structure.

>
> Example:
>
> Parent snapshot:
> |---- a/ (ino 279)
>   |---- c (ino 282)
> |---- del/ (ino 281)
>   |---- tmp/ (ino 280)
>   |---- long/ (ino 283)
>   |---- longlong/ (ino 284)
>
> Send snapshot:
> |---- a/ (ino 279)
>   |---- long (ino 283)
>   |---- longlong (ino 284)
> |---- c/ (ino 282)
>   |---- tmp/ (ino 280)
>
> Here we process 281 use can_rmdir check, but 280 is waiting, so create orphan_dir_info
> and when 282 is move to dest, so 280 can move to c/tmp, and now run can_rmdir check again.
> Return is false, because 283 and 284 is unprocess, but now not release orphan_dir_info.
> When 283 and 284 is processd, 281 be delete, but not delete orphan_dir_info.
> So fix this by release orphan_dir_info for this case.

Could be described more generically as freeing an existing
orphan_dir_info for a directory, when we realize we can't rmdir the
directory because it has a descendant that wasn't yet processed, and
the orphan_dir_info was created because it had a descendant that had
its rename operation delayed.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 596b9dc..ff9d052 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2785,12 +2785,6 @@ add_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
>         struct rb_node *parent = NULL;
>         struct orphan_dir_info *entry, *odi;
>
> -       odi = kmalloc(sizeof(*odi), GFP_NOFS);
> -       if (!odi)
> -               return ERR_PTR(-ENOMEM);
> -       odi->ino = dir_ino;
> -       odi->gen = 0;
> -
>         while (*p) {
>                 parent = *p;
>                 entry = rb_entry(parent, struct orphan_dir_info, node);
> @@ -2799,11 +2793,16 @@ add_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
>                 } else if (dir_ino > entry->ino) {
>                         p = &(*p)->rb_right;
>                 } else {
> -                       kfree(odi);
>                         return entry;
>                 }
>         }
>
> +       odi = kmalloc(sizeof(*odi), GFP_NOFS);
> +       if (!odi)
> +               return ERR_PTR(-ENOMEM);
> +       odi->ino = dir_ino;
> +       odi->gen = 0;
> +

All the above changes don't fix the issue described in this change -
the memory leak - they just avoid the overhead of allocating an
orphan_dir_info object unnecessarily.

The change is ok, but should be a separate patch in the series that
does only that.

>         rb_link_node(&odi->node, parent, p);
>         rb_insert_color(&odi->node, &sctx->orphan_dirs);
>         return odi;
> @@ -2913,6 +2912,12 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>                 }
>
>                 if (loc.objectid > send_progress) {
> +                       struct orphan_dir_info *odi;
> +
> +                       odi = get_orphan_dir_info(sctx, dir);
> +                       if (odi) {
> +                               free_orphan_dir_info(sctx, odi);
> +                       }

Looks correct, great catch.

Thanks.

>                         ret = 0;
>                         goto out;
>                 }
> --
> 1.9.1
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
