Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:45509 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbeEHJKm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 05:10:42 -0400
Received: by mail-ua0-f194.google.com with SMTP id j5so20211215uak.12
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 02:10:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1525747843-31894-1-git-send-email-robbieko@synology.com>
References: <1525747843-31894-1-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Tue, 8 May 2018 10:10:41 +0100
Message-ID: <CAL3q7H43k4+B7Ugp6ZqDMyB3Ts=9NWirLBa+tRCA-866vtP4Fg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: send, improve rmdir performance for large directory
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 8, 2018 at 3:50 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> At present, we check if the directory can be deleted.

At present, and in the future... it will always be needed.

> We need to check whether all the files under this directory
> have been processed every time we finished processing an
> entry under that directory.

I would rephrase to something more clear like:

"Currently when checking if we can delete a directory, we always check
if all its children have been processed."

>
> Example: 2,000,000 files in 1 directory.
> Parent snapshot:
> |---- dir/ (ino 257, dir)
>     |---- f1 (ino 258, file1)
>     |---- f2 (ino 259, file2)

Those comments of "dir", "file1", "file2", are irrelevant, they don't
provide any useful information.

>     |---- ...
>     |---- f2000000
>
> Send snapshot: (Empty)

Heck, for such trivial case to understand, you don't need to add these
diagrams. Just because I do them most of the time, and ask you too,
doesn't mean they're always needed.
Just say a directory with many files was deleted. Anyone can understand that.

>
> Result:
> original : 1994m57.071s
> patch : 1m38.554s
>
> [FIX]
> We add a offset hint for dir index when check can_rmdir.
> This hint records the offset to which the last can_rmdir
> was processed.

Something like:

"Instead of checking all children on all calls to can_rmdir(), we keep
track of the directory index offset of the child last
checked in the last call to can_rmdir(), and then use it as the
starting point for future calls to can_rmdir()".

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 45 +++++++++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 16 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 484e2af..43b0364 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -247,6 +247,7 @@ struct orphan_dir_info {
>         struct rb_node node;
>         u64 ino;
>         u64 gen;
> +       u64 offset_hint;

This name is confusing. A better name could be used like
"last_dir_index_offset".

>  };
>
>  struct name_cache_entry {
> @@ -2855,12 +2856,6 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
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
> @@ -2869,11 +2864,17 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
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
> +       odi->offset_hint = 0;
> +

So moving the allocation to the end in order to avoid unnecessary
allocations is a whole different change and optimization (not
mentioned in the changelog).
Please split this into its own patch.

>         rb_link_node(&odi->node, parent, p);
>         rb_insert_color(&odi->node, &sctx->orphan_dirs);
>         return odi;
> @@ -2928,6 +2929,7 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>         struct btrfs_key found_key;
>         struct btrfs_key loc;
>         struct btrfs_dir_item *di;
> +       struct orphan_dir_info *odi = NULL;
>
>         /*
>          * Don't try to rmdir the top/root subvolume dir.
> @@ -2942,6 +2944,11 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>         key.objectid = dir;
>         key.type = BTRFS_DIR_INDEX_KEY;
>         key.offset = 0;
> +
> +       odi = get_orphan_dir_info(sctx, dir);
> +       if (odi)
> +               key.offset = odi->offset_hint;
> +
>         ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>         if (ret < 0)
>                 goto out;
> @@ -2969,24 +2976,26 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>
>                 dm = get_waiting_dir_move(sctx, loc.objectid);
>                 if (dm) {
> -                       struct orphan_dir_info *odi;
> -
>                         odi = add_orphan_dir_info(sctx, dir);
>                         if (IS_ERR(odi)) {
>                                 ret = PTR_ERR(odi);
>                                 goto out;
>                         }
>                         odi->gen = dir_gen;
> +                       odi->offset_hint = found_key.offset;
>                         dm->rmdir_ino = dir;
>                         ret = 0;
>                         goto out;
>                 }
>
>                 if (loc.objectid > send_progress) {
> -                       struct orphan_dir_info *odi;
> -
> -                       odi = get_orphan_dir_info(sctx, dir);
> -                       free_orphan_dir_info(sctx, odi);
> +                       odi = add_orphan_dir_info(sctx, dir);
> +                       if (IS_ERR(odi)) {
> +                               ret = PTR_ERR(odi);
> +                               goto out;
> +                       }
> +                       odi->gen = dir_gen;
> +                       odi->offset_hint = found_key.offset;
>                         ret = 0;
>                         goto out;
>                 }
> @@ -2994,6 +3003,8 @@ static int can_rmdir(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>                 path->slots[0]++;
>         }
>
> +       if (odi)
> +               free_orphan_dir_info(sctx, odi);

Remove the "if (odi)", free_orphan_dir_info() deals with NULL properly.

>         ret = 1;
>
>  out:
> @@ -3270,13 +3281,16 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>
>         if (rmdir_ino) {
>                 struct orphan_dir_info *odi;
> +               u64 gen;
>
>                 odi = get_orphan_dir_info(sctx, rmdir_ino);
>                 if (!odi) {
>                         /* already deleted */
>                         goto finish;
>                 }
> -               ret = can_rmdir(sctx, rmdir_ino, odi->gen, sctx->cur_ino);
> +               gen = odi->gen;
> +
> +               ret = can_rmdir(sctx, rmdir_ino, gen, sctx->cur_ino);
>                 if (ret < 0)
>                         goto out;
>                 if (!ret)
> @@ -3287,13 +3301,12 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>                         ret = -ENOMEM;
>                         goto out;
>                 }
> -               ret = get_cur_path(sctx, rmdir_ino, odi->gen, name);
> +               ret = get_cur_path(sctx, rmdir_ino, gen, name);
>                 if (ret < 0)
>                         goto out;
>                 ret = send_rmdir(sctx, name);
>                 if (ret < 0)
>                         goto out;
> -               free_orphan_dir_info(sctx, odi);
>         }
>
>  finish:
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
