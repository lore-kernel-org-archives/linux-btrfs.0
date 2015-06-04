Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36476 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbbFDQkY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 12:40:24 -0400
Received: by igbpi8 with SMTP id pi8so142147960igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 09:40:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433416690-19177-5-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-5-git-send-email-robbieko@synology.com>
Date: Thu, 4 Jun 2015 17:40:23 +0100
Message-ID: <CAL3q7H5QdA0swW-Ng1VY7XC6moJVo6cbBeMzSVE8r-EVA4RKbA@mail.gmail.com>
Subject: Re: [PATCH 4/5] Btrfs: incremental send, fix rmdir but dir have a
 unprocess item
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
> There's one case where we can't rmdir issue.

"There's one case where we attempt to rmdir a directory prematurely."

>
> Example:
>
> Parent snapshot:
> |---- a/ (ino 279)
>   |---- c (ino 282)
> |---- del/ (ino 281)
>   |---- tmp/ (ino 280)
>   |---- long/ (ino 283)
>
> Send snapshot:
> |---- a/ (ino 279)
>   |---- long (ino 283)
> |---- c/ (ino 282)
>   |---- tmp/ (ino 280)
>
> Here we process 281 use can_rmdir check, but 280 is waiting, so create orphan_dir_info
> and when 282 is move to dest, so 280 can move to c/tmp, and now run can_rmdir check again.

> Return is true, because sctx->cur_ino is 282 , and call can_rmdir(, sctx->cur_ino + 1)
> so 283 is equal or lesser than (sctx->cur_ino + 1), not anything unprocess.

We pass 283 (sctx->cur_ino + 1) as the send_progress to the
can_rmdir() function and that makes it return true when it shouldn't,
because the inode 283 wasn't processed yet and it's still a child of
the directory with inode number 281, which makes the receiver run into
an ENOTEMPTY error when attempting to remove the directory.

> So fix this rmdir for this case.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index ff9d052..e8eb3ab 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3213,7 +3213,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>                         /* already deleted */
>                         goto finish;
>                 }
> -               ret = can_rmdir(sctx, rmdir_ino, odi->gen, sctx->cur_ino + 1);
> +               ret = can_rmdir(sctx, rmdir_ino, odi->gen, sctx->cur_ino);

Looks good, great catch.

Thanks.

>                 if (ret < 0)
>                         goto out;
>                 if (!ret)
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
