Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33443 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbFDPne (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 11:43:34 -0400
Received: by iebgx4 with SMTP id gx4so38813667ieb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 08:43:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433416690-19177-3-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-3-git-send-email-robbieko@synology.com>
Date: Thu, 4 Jun 2015 16:43:33 +0100
Message-ID: <CAL3q7H5NDgVNopfp1v+qweRX99-G9+D41HeRqkhpDfSvBBjffw@mail.gmail.com>
Subject: Re: [PATCH 2/5] Btrfs: incremental send, avoid ancestor rename to descendant
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
> Base on [PATCH] Btrfs: incremental send, don't delay directory renames unnecessarily
>
> There's one case where we can't issue a rename operation for a directory

Should be "There's one more case where..." - we already have at least
a handful of cases where we can't rename a directory as soon as we
finish processing it :)

> as soon as we process it. We move a directory from ancestor to descendant,
> if not wait_parent_move or wait_for_dest_dir_move so that happen path loop.

Can you elaborate here? I think this doesn't explain what's the
problem and why it happens.

What does "move a directory from ancestor to descendant" means? Does
it mean renaming it from the name in the parent snapshot to its name
in the send snapshot? Or something else? Ancestor of which inode and
descendant of which inode?

Mentioning "if not wait_parent_mobe or wait_for_dest_dir" isn't
helpful either, it doesn't tells us what cases those functions cover
and which case they are missing, nor does it explain why we get into a
path building loop problem (I assume that's what you mean with "so
that happen path loop").

>
> Example:
>
> Parent snapshot:
> |---- @tmp/ (ino 257)
> |---- pre/ (ino 259)
>   |---- wait_dir (ino 260)
>     |---- finish_dir2/ (ino 261)
> |---- ance/ (ino 263)
>   |---- finish_dir1/ (ino 258)
> |---- desc/ (ino 262)
> |---- other_dir/ (ino 264)
>
> Send snapshot:
> |---- @tmp/ (ino 257)
>   |---- other_dir/ (ino 264)
>     |---- wait_dir/ (ino 260)
>       |---- finish_dir2/ (ino 261)
>         |---- desc/ (ino 262)
>           |---- ance/ (ino 263)
>             |---- finish_dir1/ (ino 258)
>               |---- pre/ (ino 259)
> Here we can not rename 263 from ance to ance/finish_dir1/pre/wait_dir/finish_dir2/desc/ance
> without the rename of inode 260, so that happen path loop.
> So fix this by delaying directory renames for this case.

By delaying directory renames for which directories? And why exactly?

You should explain why the path loop happens and why a rename of inode
263 from "ance" to
"ance/finish_dir1/pre/wait_dir/finish_dir2/desc/ance" is attempted,
what is the bug in the logic of an incremental send that causes such
rename to be performed.

I haven't tried it here, but it seems weird you get 2 problems here:
the path building loop and an incorrect rename operation - for all the
previously solved bugs we had either one or the other happening, but
not both. Unless the "path loop" issue you mention is not the infinite
path build loop that leads to an -ENOMEM error when the path we're
building exceeds PATH_MAX, but instead some other new problem.

The commit message should really explain what causes the problem and
the fix in detail.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index fbfbb8b..596b9dc 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3078,6 +3078,56 @@ static struct pending_dir_move *get_pending_dir_moves(struct send_ctx *sctx,
>         return NULL;
>  }
>
> +static int path_loop(struct send_ctx *sctx, struct fs_path *name,
> +                    u64 ino, u64 gen, u64 *ancestor_ino)
> +{
> +       int ret = 0;
> +       u64 parent_inode = 0;
> +       u64 parent_gen = 0;
> +       u64 start_ino = ino;
> +
> +       *ancestor_ino = 0;
> +       while (ino != BTRFS_FIRST_FREE_OBJECTID) {
> +               struct waiting_dir_move *wdm;
> +               fs_path_reset(name);
> +
> +               if (is_waiting_for_rm(sctx, ino))
> +                       break;
> +
> +               wdm = get_waiting_dir_move(sctx, ino);
> +               if (wdm) {
> +                       if (*ancestor_ino == 0)
> +                               *ancestor_ino = ino;
> +                       if (wdm->orphanized) {
> +                               ret = gen_unique_name(sctx, ino, gen, name);
> +                               break;
> +                       } else {
> +                               ret = get_first_ref(sctx->parent_root, ino,
> +                                                                       &parent_inode, &parent_gen, name);
> +                       }
> +               } else {
> +                       ret = __get_cur_name_and_parent(sctx, ino, gen,
> +                                                       &parent_inode,
> +                                                       &parent_gen, name);
> +                       if (ret > 0) {
> +                               ret = 0;
> +                               break;
> +                       }
> +               }
> +               if (ret < 0)
> +                       break;
> +               if (parent_inode == start_ino) {
> +                       ret = 1;
> +                       if (*ancestor_ino == 0)
> +                               *ancestor_ino = ino;
> +                       break;
> +               }
> +               ino = parent_inode;
> +               gen = parent_gen;
> +       }
> +       return ret;
> +}
> +
>  static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>  {
>         struct fs_path *from_path = NULL;
> @@ -3089,6 +3139,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>         struct waiting_dir_move *dm = NULL;
>         u64 rmdir_ino = 0;
>         int ret;
> +       u64 ancestor = 0;
>         bool is_orphan;
>
>         name = fs_path_alloc();
> @@ -3122,6 +3173,22 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>                 goto out;
>
>         sctx->send_progress = sctx->cur_ino + 1;
> +       ret = path_loop(sctx, name, pm->ino, pm->gen, &ancestor);
> +       if (ret) {
> +               LIST_HEAD(deleted_refs);
> +               ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
> +               ret = add_pending_dir_move(sctx, pm->ino, pm->gen, ancestor,
> +                                                                       &pm->update_refs, &deleted_refs,
> +                                                                       is_orphan);
> +               if (ret < 0)
> +                       goto out;
> +               if (rmdir_ino) {
> +                       dm = get_waiting_dir_move(sctx, pm->ino);
> +                       ASSERT(dm);
> +                       dm->rmdir_ino = rmdir_ino;
> +               }
> +               goto out;
> +       }

So far you're basically reverting this change:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5f806c3ae2ff6263a10a6901f97abb74dac03d36

That should be a separate 'revert' patch in the series.


>         fs_path_reset(name);
>         to_path = name;
>         name = NULL;
> @@ -3693,6 +3760,34 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>                 }
>
>                 /*
> +                * if cur_ino is cur ancestor, can't move now,
> +                * find descendant who is waiting, waiting it.
> +                */

This comment is confusing too. cur_ino is ancestor of itself, or
ancestor of which inode? Plus the code below is looking for an
ancestor while the comment mentions finding a descendant.

> +               if (can_rename && (strncmp(valid_path->start, cur->full_path->start, fs_path_len(valid_path)) == 0) &&
> +                                                       fs_path_len(cur->full_path) > fs_path_len(valid_path) && cur->full_path->start[fs_path_len(valid_path)] == '/') {

Same comment as in the first patch, too long line.
Also given that this check (second condition) is being repeated in 2
different places, it should be encapsulated in a helper function.

> +                       struct fs_path *name = NULL;
> +                       u64 ancestor;
> +                       u64 old_send_progress = sctx->send_progress;
> +
> +                       name = fs_path_alloc();

Allocation can fail, it can return NULL, need to return -ENOMEM in such case.

thanks

> +                       sctx->send_progress = sctx->cur_ino + 1;
> +                       ret = path_loop(sctx, name, sctx->cur_ino, sctx->cur_inode_gen, &ancestor);
> +                       if (ret) {
> +                               ret = add_pending_dir_move(sctx, sctx->cur_ino, sctx->cur_inode_gen,
> +                                                       ancestor, &sctx->new_refs, &sctx->deleted_refs, is_orphan);
> +                               if (ret < 0) {
> +                                       sctx->send_progress = old_send_progress;
> +                                       fs_path_free(name);
> +                                       goto out;
> +                               }
> +                               can_rename = false;
> +                               *pending_move = 1;
> +                       }
> +                       sctx->send_progress = old_send_progress;
> +                       fs_path_free(name);
> +               }
> +
> +               /*
>                  * link/move the ref to the new place. If we have an orphan
>                  * inode, move it and update valid_path. If not, link or move
>                  * it depending on the inode mode.
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
