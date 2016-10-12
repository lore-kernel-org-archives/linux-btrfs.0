Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35390 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932408AbcJLJPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 05:15:54 -0400
Received: by mail-it0-f67.google.com with SMTP id l13so3583748itl.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 02:15:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476259970-1866-6-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com> <1476259970-1866-6-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 12 Oct 2016 10:15:25 +0100
Message-ID: <CAL3q7H643Lv+udiRfsoYKYhR+pUd+PJrbgZgP0-Q43HU5nKy8g@mail.gmail.com>
Subject: Re: [PATCH 5/5] Btrfs: incremental send, add gen check if has
 waiting_dir_move in the will_overwrite_ref
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

> add check generation if has waiting_dir_move in the will_overwrite_ref

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
>  fs/btrfs/send.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e090db2..92b7518 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1858,6 +1858,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>         u64 gen;
>         u64 other_inode = 0;
>         u8 other_type = 0;
> +       struct waiting_dir_move *dm = NULL;
>
>         if (!sctx->parent_root)
>                 goto out;
> @@ -1899,11 +1900,15 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>          * overwrite anything at this point in time.
>          */
>         if (other_inode > sctx->send_progress ||
> -           is_waiting_for_move(sctx, other_inode)) {
> +               ((dm = get_waiting_dir_move(sctx, other_inode)) != NULL)) {
>                 ret = get_inode_info(sctx->parent_root, other_inode, NULL,
>                                 who_gen, NULL, NULL, NULL, NULL);
>                 if (ret < 0)
>                         goto out;
> +               if (dm && dm->gen != *who_gen) {
> +                       ret = 0;
> +                       goto out;
> +               }
>
>                 ret = 1;
>                 *who_ino = other_inode;
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
