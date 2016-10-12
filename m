Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36800 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbcJLLW7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 07:22:59 -0400
Received: by mail-it0-f65.google.com with SMTP id o19so3757217ito.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 04:22:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476259970-1866-4-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com> <1476259970-1866-4-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 12 Oct 2016 10:13:07 +0100
Message-ID: <CAL3q7H6RfKZVFfV_p_re_pz5=gt+=2X7wdB=a0wL5CB8bfnxuA@mail.gmail.com>
Subject: Re: [PATCH 3/5] Btrfs: incremental send, add gen in waiting_dir_move
 for some corner case
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

> add compare generation with dir items,
> and waiting_dir_move in the can_rmdir.

Please add some explanation of the problem and the fix.

Also, can you please start sending xfstests too?
Last batch of send fixes you've sent, I've asked you to do them, but
you totally ignored it and later on I had to do them myself and
rewrite all change logs (and remove some unnecessary code).

Thanks.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 95d3718..d908624 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -237,6 +237,7 @@ struct pending_dir_move {
>  struct waiting_dir_move {
>         struct rb_node node;
>         u64 ino;
> +       u64 gen;
>         /*
>          * There might be some directory that could not be removed because it
>          * was waiting for this directory inode to be moved first. Therefore
> @@ -2931,6 +2932,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>         struct btrfs_key found_key;
>         struct btrfs_key loc;
>         struct btrfs_dir_item *di;
> +       u64 gen;
>
>         /*
>          * Don't try to rmdir the top/root subvolume dir.
> @@ -2970,8 +2972,13 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>                                 struct btrfs_dir_item);
>                 btrfs_dir_item_key_to_cpu(path->nodes[0], di, &loc);
>
> +               ret = get_inode_info(root, loc.objectid, NULL, &gen, NULL,
> +                                    NULL, NULL, NULL);
> +               if (ret < 0)
> +                       goto out;
> +
>                 dm = get_waiting_dir_move(sctx, loc.objectid);
> -               if (dm) {
> +               if (dm && dm->gen == gen) {
>                         struct orphan_dir_info *odi;
>
>                         odi = add_orphan_dir_info(sctx, dir);
> @@ -3011,7 +3018,7 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino)
>         return entry != NULL;
>  }
>
> -static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
> +static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, u64 gen, bool orphanized)
>  {
>         struct rb_node **p = &sctx->waiting_dir_moves.rb_node;
>         struct rb_node *parent = NULL;
> @@ -3021,6 +3028,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
>         if (!dm)
>                 return -ENOMEM;
>         dm->ino = ino;
> +       dm->gen = gen;
>         dm->rmdir_ino = 0;
>         dm->orphanized = orphanized;
>
> @@ -3118,7 +3126,7 @@ static int add_pending_dir_move(struct send_ctx *sctx,
>                         goto out;
>         }
>
> -       ret = add_waiting_dir_move(sctx, pm->ino, is_orphan);
> +       ret = add_waiting_dir_move(sctx, pm->ino, pm->gen, is_orphan);
>         if (ret)
>                 goto out;
>
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
