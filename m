Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35478 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbcJLKBL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 06:01:11 -0400
Received: by mail-it0-f67.google.com with SMTP id l13so3647285itl.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 03:01:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476259970-1866-3-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com> <1476259970-1866-3-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 12 Oct 2016 10:11:08 +0100
Message-ID: <CAL3q7H7X1PBwsG4KiSaAdSBAb-j0BmR=d+9uLns2quft1cK1Bw@mail.gmail.com>
Subject: Re: [PATCH 2/5] Btrfs: incremental send, add gen for
 is_waiting_for_rm when some corner case
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 9:12 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> There a one case for old_gen waiting_for_rm,
> but new_gen use get_cur_path with the same inode.
>
> Example:
>     Parent snapshot:
>     |---- dir258/ (ino 258, dir)
>         |--- dir257/ (ino 257, dir)
>     |---- dir259/ (ino 259, dir)
>
>     Send snapshot:
>     |---- file258 (ino 258, file)
>     |---- new_dir259/ (ino 259, dir)
>         |--- dir257/ (ino 257, dir)
>
> utimes
> mkdir o259-21-0
> rename dir258 -> o258-15-0
> utimes
> mkfile o258-21-0
> rename o258-21-0 -> file258
> utimes
> truncate o258-21-0 size=0
> ERROR: truncate o258-21-0 failed: No such file or directory
>
> dir258 will be delete, but dir257 is waiting for move,
> so dir258 is waiting for rm, and then file258 be create,
> and rename it, and then need to truncate it, so use get_cur_path
> to get path, but is_waiting_for_rm olny check ino, dosen't check gen,
> match dir258 is waiting for rm, so get error path o258-21-0.
>
> therefore, add gen check in is_waiting_for_rm.

Same comments as for patch 1.

Can you please start sending xfstests too?
Last batch of send fixes you've sent, I've asked you to do them, but
you totally ignored it and later on I had to do them myself and
rewrite all change logs (and remove some unnecessary code).

Thanks.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 1862f8a..95d3718 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -311,7 +311,7 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino);
>  static struct waiting_dir_move *
>  get_waiting_dir_move(struct send_ctx *sctx, u64 ino);
>
> -static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino);
> +static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 dir_gen);
>
>  static int need_send_hole(struct send_ctx *sctx)
>  {
> @@ -2293,7 +2293,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
>
>                 fs_path_reset(name);
>
> -               if (is_waiting_for_rm(sctx, ino)) {
> +               if (is_waiting_for_rm(sctx, ino, gen)) {
>                         ret = gen_unique_name(sctx, ino, gen, name);
>                         if (ret < 0)
>                                 goto out;
> @@ -2900,11 +2900,11 @@ get_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
>         return NULL;
>  }
>
> -static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino)
> +static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 dir_gen)
>  {
>         struct orphan_dir_info *odi = get_orphan_dir_info(sctx, dir_ino);
>
> -       return odi != NULL;
> +       return (odi != NULL && odi->gen == dir_gen);
>  }
>
>  static void free_orphan_dir_info(struct send_ctx *sctx,
> @@ -3167,7 +3167,7 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
>         while (ino != BTRFS_FIRST_FREE_OBJECTID) {
>                 fs_path_reset(name);
>
> -               if (is_waiting_for_rm(sctx, ino))
> +               if (is_waiting_for_rm(sctx, ino, gen))
>                         break;
>                 if (is_waiting_for_move(sctx, ino)) {
>                         if (*ancestor_ino == 0)
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
