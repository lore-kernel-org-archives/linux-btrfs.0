Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35113 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbbFVLf7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 07:35:59 -0400
Received: by igblr2 with SMTP id lr2so29322469igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 04:35:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434964128-31757-3-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
	<1434964128-31757-3-git-send-email-robbieko@synology.com>
Date: Mon, 22 Jun 2015 12:35:58 +0100
Message-ID: <CAL3q7H4wHPZg72YSPg2Q-TxLp7QhFX7pZmEBUqGBfcUkwwBn6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] Btrfs: incremental send, avoid circular waiting
 and descendant overwrite ancestor need to update path
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 10:08 AM, Robbie Ko <robbieko@synology.com> wrote:
> Base on [PATCH] Btrfs: incremental send, check if orphanized dir inode needs delayed rename

This is mentioned on the cover letter, so no need to repeat this on
the commit message of every patch in the series.

>
> Example1:
> There's one case where we can't issue a rename operation for a directory
> as soon as we process it. Used to delay directory renames if
> wait_parent_move or wait_for_dest_dir_move, maybe cause circular waiting.

This second sentence is confusing to say the least. What is "if
wait_parent_move"? There's nothing in send.c with that name. And the
maybe is equally confusing and redundant. You already explain below
that the problem is a circular waiting, an example and what is a
circular waiting exactly.

>
> Parent snapshot:
> |---- d/ (ino 257)
>     |---- p1 (ino 258)
> |---- p1/ (ino 259)
>
> Send snapshot:
> |---- d/ (ino 257)
>     |---- p1 (ino 259)
>         |---- p1/ (ino 258)
>
> Here we can not rename 258 from d/p1 to p1/p1 without the rename of inode 259.
> p1 258 is put into wait_parent_move.

"... is put into wait_parent_move" -> what is wait_parent_move?
There's nothing in send.c with that name. Is it a function, is it a
data structure, or what? Even someone familiar with send's internals
scratches his head trying to understand what does this means.

A better alternative: "Inode 258 became a child of inode 259 and both
were renamed in the send snapshot. Therefore inode 258's rename
operation is delayed to happen after 259 is renamed."
Or something along those lines.

> 259 can't be rename to d/p1, so it is put into

It should be mentioned why 259 can't be renamed.

> circular waiting happens" -> so 259's rename is delayed to happen after 258's rename,
> which creates a circular dependency (258 -> 259 -> 258).
>
> Example2:
> There's one case where we can't issue a rename operation for a directory
> immediately we process it.

We are repeating this sentence in every example. Just say at the very
top that there are several more cases where we can't do the renames
immediately.

> After moving 262 outside, path of 265 is stored in the name_cache_entry.

After renaming inode 262, the name inode 265 has in the parent
snapshot is stored in the name cache.

> When 263 try to overwrite 265, its ancestor, 265 is moved to orphanized. Path of 263
> is still the original path, however. This causes error.

What error? It's important to mention what error it is.

You should explain that after orphanizing 265 we were leaving its old
name in the cache and how that causes a problem.

>
> Parent snapshot:
> |---- a/ (ino 259)
>     |---- c (ino 266)
> |---- d/ (ino 260)
>     |---- ance (ino 265)
>         |---- e (ino 261)
>         |---- f (ino 262)
>         |---- ance (ino 263)
>
> Send snapshot:
> |---- a/ (ino 259)
> |---- c/ (ino 266)
>     |---- ance (ino 265)
> |---- d/ (ino 260)
>     |---- ance (ino 263)
> |---- f/ (ino 262)
>     |---- e (ino 261)
>
> Example3:
> There is another case for 2nd scenario where is_ancestor() can't be used.
>
> Parent snapshot:
> |---- a/ (ino 261)
>     |---- c (ino 267)
> |---- d/ (ino 259)
>     |---- ance/ (ino 266)
>         |---- waiting_dir/ (ino 262)
> |---- pre/ (ino 264)
>     |---- ance/ (ino 265)
>
> Send snapshot:
> |---- a/ (ino 261)
>     |---- ance/ (ino 266)
> |---- c (ino 267)
>     |---- waiting_dir/ (ino 262)
>         |---- pre/ (ino 264)
> |---- d/ (ino 259)
>     |---- ance/ (ino 265)
>
> First, 262 can't move to c/waiting_dir without the rename of inode 267.
> Second, 264 can move into dir 262. Although 262 is waiting, 264 is not
> parent of 262 in the parent root.
> (The second behavior will happen after applying "[PATCH] Btrfs:
> incremental send, don't delay directory renames unnecessarily")
> Finally, 265 will overwrite 266 and path for 265 should be updated
> since 266 is not the ancestor of 265.
> Here we need to check the current state of tree rather than parent
> root which  is_ancestor function does.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>
> V2:when orphanized inode always get_cur_path again.
>
>  fs/btrfs/send.c | 38 ++++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 257753b..44ad144 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -230,7 +230,6 @@ struct pending_dir_move {
>         u64 parent_ino;
>         u64 ino;
>         u64 gen;
> -       bool is_orphan;
>         struct list_head update_refs;
>  };
>
> @@ -1840,7 +1839,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>          * was already unlinked/moved, so we can safely assume that we will not
>          * overwrite anything at this point in time.
>          */
> -       if (other_inode > sctx->send_progress) {
> +       if (other_inode > sctx->send_progress || is_waiting_for_move(sctx, other_inode)) {
>                 ret = get_inode_info(sctx->parent_root, other_inode, NULL,
>                                 who_gen, NULL, NULL, NULL, NULL);
>                 if (ret < 0)
> @@ -3014,7 +3013,6 @@ static int add_pending_dir_move(struct send_ctx *sctx,
>         pm->parent_ino = parent_ino;
>         pm->ino = ino;
>         pm->gen = ino_gen;
> -       pm->is_orphan = is_orphan;
>         INIT_LIST_HEAD(&pm->list);
>         INIT_LIST_HEAD(&pm->update_refs);
>         RB_CLEAR_NODE(&pm->node);
> @@ -3134,6 +3132,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>         u64 rmdir_ino = 0;
>         int ret;
>         u64 ancestor = 0;
> +       bool is_orphan;
>
>         name = fs_path_alloc();
>         from_path = fs_path_alloc();
> @@ -3145,9 +3144,10 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>         dm = get_waiting_dir_move(sctx, pm->ino);
>         ASSERT(dm);
>         rmdir_ino = dm->rmdir_ino;
> +       is_orphan = dm->orphanized;
>         free_waiting_dir_move(sctx, dm);
>
> -       if (pm->is_orphan) {
> +       if (is_orphan) {
>                 ret = gen_unique_name(sctx, pm->ino,
>                                       pm->gen, from_path);
>         } else {
> @@ -3171,7 +3171,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>                 ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
>                 ret = add_pending_dir_move(sctx, pm->ino, pm->gen, ancestor,
>                                            &pm->update_refs, &deleted_refs,
> -                                          pm->is_orphan);
> +                                          is_orphan);
>                 if (ret < 0)
>                         goto out;
>                 if (rmdir_ino) {
> @@ -3351,6 +3351,7 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
>         u64 left_gen;
>         u64 right_gen;
>         int ret = 0;
> +       struct waiting_dir_move *wdm;
>
>         if (RB_EMPTY_ROOT(&sctx->waiting_dir_moves))
>                 return 0;
> @@ -3409,7 +3410,8 @@ static int wait_for_dest_dir_move(struct send_ctx *sctx,
>                 goto out;
>         }
>
> -       if (is_waiting_for_move(sctx, di_key.objectid)) {
> +       wdm = get_waiting_dir_move(sctx, di_key.objectid);
> +       if (wdm && !wdm->orphanized) {
>                 ret = add_pending_dir_move(sctx,
>                                            sctx->cur_ino,
>                                            sctx->cur_inode_gen,
> @@ -3669,11 +3671,23 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>                                 goto out;
>                         if (ret) {
>                                 struct name_cache_entry *nce;
> +                               struct waiting_dir_move *wdm;
>
>                                 ret = orphanize_inode(sctx, ow_inode, ow_gen,
>                                                 cur->full_path);
>                                 if (ret < 0)
>                                         goto out;
> +
> +                               /*
> +                                * check is waiting dir, if yes change the ino
> +                                * to orphanized in the waiting tree.
> +                                */

Confusing comment. "check is waiting dir" - what is this? Should be
something like: "If ow_inode has its rename operation delayed, make
sure that its orphanized name is used in the source path when
performing its rename operation."

> +                               if (is_waiting_for_move(sctx, ow_inode)) {
> +                                       wdm = get_waiting_dir_move(sctx, ow_inode);
> +                                       ASSERT(wdm);
> +                                       wdm->orphanized = true;
> +                               }
> +
>                                 /*
>                                  * Make sure we clear our orphanized inode's
>                                  * name from the name cache. This is because the
> @@ -3689,6 +3703,18 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>                                         name_cache_delete(sctx, nce);
>                                         kfree(nce);
>                                 }
> +
> +                               /*
> +                                * ow_inode might currently be an ancestor of
> +                                * cur_ino, therefore compute valid_path (the
> +                                * current path of cur_ino) again because it
> +                                * might contain the pre-orphanization name of
> +                                * ow_inode, which is no longer valid.
> +                                */
> +                               fs_path_reset(valid_path);
> +                               ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, valid_path);
> +                               if (ret < 0)
> +                                       goto out;
>                         } else {
>                                 ret = send_unlink(sctx, cur->full_path);
>                                 if (ret < 0)

Also please run your patch against checkpath.pl, as mentioned in the
first review:

$ /path/to/kernel/source/scripts/checkpatch.pl  your_patch_file

(...)

WARNING: line over 80 characters
#118: FILE: fs/btrfs/send.c:1842:
+ if (other_inode > sctx->send_progress || is_waiting_for_move(sctx,
other_inode)) {

WARNING: line over 80 characters
#193: FILE: fs/btrfs/send.c:3686:
+ wdm = get_waiting_dir_move(sctx, ow_inode);

WARNING: line over 80 characters
#214: FILE: fs/btrfs/send.c:3715:
+ ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, valid_path);

(...)

Same comment applies to all your patches.


> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
