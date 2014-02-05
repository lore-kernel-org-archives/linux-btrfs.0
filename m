Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:58287 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaBEWIx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 17:08:53 -0500
Received: by mail-bk0-f41.google.com with SMTP id na10so411744bkb.28
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 14:08:52 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1391635161-3983-1-git-send-email-jbacik@fb.com>
References: <1391635161-3983-1-git-send-email-jbacik@fb.com>
Date: Wed, 5 Feb 2014 22:08:51 +0000
Message-ID: <CAL3q7H6PgEqOZDNUprKUGSKG1Po3UwSst2EK4FUJQ=2EP4N5tA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix assert screwup for the pending move stuff
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 5, 2014 at 9:19 PM, Josef Bacik <jbacik@fb.com> wrote:
> Wang noticed that he was failing btrfs/030 even though me and Filipe couldn't
> reproduce.  Turns out this is because Wang didn't have CONFIG_BTRFS_ASSERT set,
> which meant that a key part of Filipe's original patch was not being built in.
> This appears to be a mess up with merging Filipe's patch as it does not exist in
> his original patch.  Fix this by changing how we make sure del_waiting_dir_move
> asserts that it did not error and take the function out of the ifdef check.
> This makes btrfs/030 pass with the assert on or off.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Filipe Manana <fdmanana@gmail.com>

Thanks Josef.

I actually had the ASSERT(del_waiting_dir_move(sctx, pm->ino) == 0), I
didn't had only the function declaration inside #ifdef
CONFIG_BTRFS_ASSERT ... #endif. Obviously because I never built with
assertions disabled and totally forgot about not using expressions
with side effects inside assert macros.

> ---
>  fs/btrfs/send.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index f71fcbc..afb145d 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2734,8 +2734,6 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
>         return 0;
>  }
>
> -#ifdef CONFIG_BTRFS_ASSERT
> -
>  static int del_waiting_dir_move(struct send_ctx *sctx, u64 ino)
>  {
>         struct rb_node *n = sctx->waiting_dir_moves.rb_node;
> @@ -2756,8 +2754,6 @@ static int del_waiting_dir_move(struct send_ctx *sctx, u64 ino)
>         return -ENOENT;
>  }
>
> -#endif
> -
>  static int add_pending_dir_move(struct send_ctx *sctx, u64 parent_ino)
>  {
>         struct rb_node **p = &sctx->pending_dir_moves.rb_node;
> @@ -2862,7 +2858,9 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>         }
>
>         sctx->send_progress = sctx->cur_ino + 1;
> -       ASSERT(del_waiting_dir_move(sctx, pm->ino) == 0);
> +       ret = del_waiting_dir_move(sctx, pm->ino);
> +       ASSERT(ret == 0);
> +
>         ret = get_cur_path(sctx, pm->ino, pm->gen, to_path);
>         if (ret < 0)
>                 goto out;
> --
> 1.8.3.1
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
