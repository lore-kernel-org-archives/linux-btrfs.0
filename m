Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35121 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbbFVLgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 07:36:45 -0400
Received: by iebrt9 with SMTP id rt9so1813484ieb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2015 04:36:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434964128-31757-4-git-send-email-robbieko@synology.com>
References: <1434964128-31757-1-git-send-email-robbieko@synology.com>
	<1434964128-31757-4-git-send-email-robbieko@synology.com>
Date: Mon, 22 Jun 2015 12:36:44 +0100
Message-ID: <CAL3q7H42UsBN-HK5hoKWfAgHHNw3GqKERVTaYn9z6iM60XPDow@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] Btrfs: incremental send, avoid ancestor rename to descendant
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 10:08 AM, Robbie Ko <robbieko@synology.com> wrote:
> There's one more case where we can't issue a rename operation for a directory
> as soon as we process it. We move a directory from ancestor to descendant.
>
> |---- a
>     |---- b
>         |---- c
>              |---- d
> "Move a directory from ancestor to descendant" means moving dir. a into dir. c
>
> This case will happen after applying "[PATCH] Btrfs: incremental send,
> don't delay directory renames unnecessarily".
> Because, that patch changes behavior of wait_for_parent_move function.
>
> Example:
> Parent snapshot:
> |---- @tmp/ (ino 257)
> |---- pre/ (ino 260)
>     |---- wait_dir (ino 261)
> |---- ance/ (ino 263)
>     |---- wait_at_below_ance/ (ino 259)
> |---- desc/ (ino 262)
> |---- other_dir/ (ino 264)
>
> Send snapshot:
> |---- @tmp/ (ino 257)
>     |---- other_dir/ (ino 264)
>         |---- wait_at_below_ance/ (ino 259)
>             |---- pre/ (ino 260)
>         |---- wait_dir/ (ino 261)
>             |---- desc/ (ino 262)
>                 |---- ance/ (ino 263)
>
> 1. 259 must move to @tmp/other_dir, so it is waiting on other_dir(264).
>
> 2. 260 is able to rename as ance/wait_at_below_ance/pre since
> wait_at_below_ance(259) is waiting and 260 is not the ancestor of wait_at_below_ance(259).
>
> 3. 261 must move to @tmp/other_dir, so it is waiting on other_dir(264).
>
> 4. 262 is able to rename as ance/wait_at_below_ance/pre/wait_dir/desc since
> wait_dir(261) is waiting and 262 is not the ancestor of wait_dir(261).
>
> 5. 263 is rename as ance/wait_at_below_ance/pre/wait_dir/desc/ance since
> wait_dir(261) is waiting and 263 is not the ancestor of wait_dir(261).
>   At the same time, receiving side will encounter error.
>   If anyone calls get_cur_path() to any element in
> ance/wait_at_below_ance/pre/wait_dir/desc/ance like wait_dir(260),
>   there will cause path building loop like this : 261 -> 260 -> 259 ->
> 263 -> 262 -> 261
>
> So fix the problem by check path_loop for this case.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>
> V2: Always check path_loop, and check Allocation ret value.
>
>  fs/btrfs/send.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 44ad144..b946067 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3088,15 +3088,23 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
>
>         *ancestor_ino = 0;
>         while (ino != BTRFS_FIRST_FREE_OBJECTID) {
> +               struct waiting_dir_move *wdm;
>                 fs_path_reset(name);
>
>                 if (is_waiting_for_rm(sctx, ino))
>                         break;
> -               if (is_waiting_for_move(sctx, ino)) {
> +
> +               wdm = get_waiting_dir_move(sctx, ino);
> +               if (wdm) {
>                         if (*ancestor_ino == 0)
>                                 *ancestor_ino = ino;
> -                       ret = get_first_ref(sctx->parent_root, ino,
> -                                           &parent_inode, &parent_gen, name);
> +                       if (wdm->orphanized) {
> +                               ret = gen_unique_name(sctx, ino, gen, name);
> +                               break;
> +                       } else {
> +                               ret = get_first_ref(sctx->parent_root, ino,
> +                                                                       &parent_inode, &parent_gen, name);
> +                       }
>                 } else {
>                         ret = __get_cur_name_and_parent(sctx, ino, gen,
>                                                         &parent_inode,
> @@ -3743,6 +3751,38 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
>                 }
>
>                 /*
> +                * if cur_ino is cur ancestor, can't move now,
> +                * find descendant who is waiting, waiting it.
> +                */

If cur_ino is current ancestor of whom?
"find descendant" -> but below we're looking for an ancestor and
delaying the rename of the current inode (sctx->cur_ino) to happen
after the rename of that ancestor.

> +               if(can_rename) {

Again, please run checkpath.pl against the files.
Kernel coding style, add a space between if and the opening
parenthesis:  if (...) {

> +                       struct fs_path *name = NULL;
> +                       u64 ancestor;
> +                       u64 old_send_progress = sctx->send_progress;
> +
> +                       name = fs_path_alloc();
> +                       if (!valid_path) {

Wrong variable. Must be:

if (!name) {
   (...)


> +                               ret = -ENOMEM;
> +                               goto out;
> +                       }
> +
> +                       sctx->send_progress = sctx->cur_ino + 1;
> +                       ret = path_loop(sctx, name, sctx->cur_ino, sctx->cur_inode_gen, &ancestor);

Need to check if ret < 0 and "goto out" if so.

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



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
