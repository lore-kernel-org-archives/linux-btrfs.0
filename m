Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35185 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932955AbcJ1PNP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 11:13:15 -0400
Received: by mail-oi0-f65.google.com with SMTP id n202so4025043oig.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 08:13:15 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1477618850-12922-4-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com> <1477618850-12922-4-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 28 Oct 2016 16:13:13 +0100
Message-ID: <CAL3q7H4r_acCfujTZPqUL7+LShNmif_txHDNppL1fhjbT8PE9A@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] Btrfs: incremental send, add generation for
 waiting_dir_move struct and check it in can_rmdir.
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2016 at 2:40 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> Example scenario:
> Parent snapshot:
> |---- dir258/ (ino 258, gen 27)
>     |---- dir257/ (ino 257, gen 27)
> |---- dir259/ (ino 259, gen 27)
>
> Send snapshot:
> |---- new_dir259/ (ino 259, gen 38)
>     |---- new_dir258/ (ino 258, gen 38)
>         |---- new_dir257/ (ino 257, gen 38)
>
> rmdir dir258/dir257
> mkdir o257-38-0
> mkdir o258-38-0
> chown o257-38-0 - uid=0, gid=0
> chmod o257-38-0 - mode=0755
> rename dir258 -> o258-27-0  -----> dir is empty, but waiting o257-38-0
> mkdir o259-38-0
> chown o258-38-0 - uid=0, gid=0
> chmod o258-38-0 - mode=0755
> rmdir dir259
> rename o259-38-0 -> new_dir259
> utimes
> chown new_dir259 - uid=0, gid=0
> chmod new_dir259 - mode=0755
> rename o258-38-0 -> new_dir259/new_dir258
> utimes new_dir259/new_dir258
> utimes new_dir259
> rename o257-38-0 -> new_dir259/new_dir258/new_dir257
> rmdir o258-27-0             -----> when o257-38-0 finish, delete
> utimes new_dir259/new_dir258/new_dir257
> utimes new_dir259/new_dir258
> utimes new_dir259
>
> While computing the send stream the following steps happen:
>
> 1) While processing inode 257 we delete dir258/dir257 immediately.
>    After create o257-38-0, we then delay its rename operation
>    because its new parent in the send snapshot, inode 258,
>    was not yet processed and therefore not yet renamed.
>
> 2) On processing inode 258, we need to check if all under files are done
>    before rmdir dir258. However, the waiting o257-38-0 (ino 257) will
>    mislead the check making it think dir257 (ino 257) is still there.
>    dir258 will be orphanized at first but in fact it has become empty.
>
> Fix this by adding generation to waiting_dir_move struct, so can_rmdir
> can use it to correct the result.

Fix what?
Your changelog does not say what is the problem. Does the send
operation fails? Or is it the receiver that fails for example due to
an operation using a wrong path name or attempting to rmdir a
non-empty directory? Or is the problem something else, like for
example are you optimizing something like avoiding unnecessary
renames?

Also the subject is not a summary of what is being fixed (e.g. "btrfs:
incremental send, fix invalid rmdir operations"). Instead you say what
code changes you do... and not what problem they are solving.

I haven't read all the other patches you sent along (and probably
won't have the time today), but by just looking at their subjects I
can infer the same comments apply.




>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---

After this line (---) you should mention what changed between patch
versions, see [1]

[1] https://btrfs.wiki.kernel.org/index.php/Writing_patch_for_btrfs#Updating_patches


thanks


>  fs/btrfs/send.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 22eca86..eaf1c92 100644
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
> @@ -2930,6 +2931,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>         struct btrfs_key found_key;
>         struct btrfs_key loc;
>         struct btrfs_dir_item *di;
> +       u64 gen;
>
>         /*
>          * Don't try to rmdir the top/root subvolume dir.
> @@ -2969,8 +2971,13 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
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
> @@ -3010,7 +3017,8 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino)
>         return entry != NULL;
>  }
>
> -static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
> +static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, u64 gen,
> +                    bool orphanized)
>  {
>         struct rb_node **p = &sctx->waiting_dir_moves.rb_node;
>         struct rb_node *parent = NULL;
> @@ -3020,6 +3028,7 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino, bool orphanized)
>         if (!dm)
>                 return -ENOMEM;
>         dm->ino = ino;
> +       dm->gen = gen;
>         dm->rmdir_ino = 0;
>         dm->orphanized = orphanized;
>
> @@ -3117,7 +3126,7 @@ static int add_pending_dir_move(struct send_ctx *sctx,
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
