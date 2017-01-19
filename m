Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35059 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdASMOJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:14:09 -0500
Received: by mail-io0-f193.google.com with SMTP id m98so4756765iod.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 04:14:09 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1483604700-21017-3-git-send-email-robbieko@synology.com>
References: <1483604700-21017-1-git-send-email-robbieko@synology.com> <1483604700-21017-3-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jan 2017 12:05:52 +0000
Message-ID: <CAL3q7H4=eofHHGNMYZBpiDStZ8j=qb=idjOP=Q7Oo+OFt=c9zg@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] Btrfs: incremental send, fix invalid path for
 truncate operations
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 5, 2017 at 8:24 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> Under certain situations, an incremental send operation can

Again, missing some word after the word "can", without it the phrase
doesn't make any sense.
Tip: don't copy paste change logs and then modify them for each patch,
it's a lot easier to make errors like that.

> a truncate operation that will make the receiving end fail when
> attempting to execute it, because the path is not exist.

The problem is generating wrong paths, and that can be for any
operation, not just truncates.
The subject should reflect that. As it is, it is misleading.

>
> Example scenario:
> Parent snapshot:
> |---- dir258/ (ino 258, gen 15, dir)
>     |--- dir257/ (ino 257, gen 15, dir)
> |---- dir259/ (ino 259, gen 15, dir)
>
> Send snapshot:
> |---- file258 (ino 258, gen 21, file)
> |---- new_dir259/ (ino 259, gen 21, dir)
>     |--- dir257/ (ino 257, gen 15, dir)
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
> While computing the send stream the following steps happen:
>
> 1) While processing inode 257, we create o259-21-0 and delay
>    dir257 rename operation, because its new parent in the send
>    snapshot, inode 259, was not yet processed and therefore not
>    yet renamed.

The problem is exactly here. There's no need to delay the rename of
257, because inode 259 is a new inode.
The whole logic for delaying renames is meant to be applied when
there's really a need to do so, when the child and parent inodes exist
in both snapshots.
So the problem is fully fixed by not delaying the rename for 257,
doing this also avoids the extra complexity and the need for all the
patches in your patchset except for patches 1/6 and 4/6.

I've added such a fix into my 4.11 integration branch and just sent it
to the list too.
It's here:

https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/commit/?h=integration-4.11&id=b271d6c72e1dc34e93ff6035096e29d45ffa933e

thanks



>
> 2) Later when processing inode 258, we delay rmdir operation for dir258
>    because it's not empty, and then orphanize it.
>
> 3) After we create o258-21-0 and rename it to file258, we get ENOENT on
>    truncate file258. The reason is that the dir258 with inode 258 is
>    waiting for rmdir operation and file258's inode is also 258, then
>    get_current_path called before truncate will return a unique name.
>
> Fix this by adding generation check for the inode waiting for rmdir
> operation.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
> V3: improve the change log
>  fs/btrfs/send.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 2060e75..22eca86 100644
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
> @@ -2292,7 +2292,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
>
>                 fs_path_reset(name);
>
> -               if (is_waiting_for_rm(sctx, ino)) {
> +               if (is_waiting_for_rm(sctx, ino, gen)) {
>                         ret = gen_unique_name(sctx, ino, gen, name);
>                         if (ret < 0)
>                                 goto out;
> @@ -2899,11 +2899,11 @@ get_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
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
> @@ -3166,7 +3166,7 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
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
