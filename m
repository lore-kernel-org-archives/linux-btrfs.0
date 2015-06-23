Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36962 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbbFWPJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 11:09:08 -0400
Received: by igblr2 with SMTP id lr2so13877747igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2015 08:09:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1435055991-10109-2-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
	<1435055991-10109-2-git-send-email-robbieko@synology.com>
Date: Tue, 23 Jun 2015 16:09:07 +0100
Message-ID: <CAL3q7H6wUxUkDY5kq+GKPtY3qmFADQ-yEvHp=gQFUNnzTBmSig@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] Revert "Btrfs: incremental send, remove dead code"
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:39 AM, Robbie Ko <robbieko@synology.com> wrote:
> This reverts commit 5f806c3ae2ff6263a10a6901f97abb74dac03d36.
>
> This is a necessary patch for a subsequent patch in the series (patch 3).

Still confused.
Reverting that commit (5f806c3ae2ff6263a10a6901f97abb74dac03d36) alone
will fix any issue?
Reading the part below gives that understanding, but it's basically a
trimmed down version of the scenario/problem mentioned in patch 3, so
it doesn't seem, nor it's clear, that this revert alone fixes any
problem.

>
> "[PATCH] Btrfs: incremental send, don't delay directory renames
> unnecessarily" changes behavior of wait_for_parent_move function.
> It may cause path loop problem, so fix it in the patch 3.
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
> This cause will cause path building loop like this : 261 -> 260 -> 259 ->
> 263 -> 262 -> 261
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>
> V3: modify comment
>
>  fs/btrfs/send.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 1c1f161..257753b 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3080,6 +3080,48 @@ static struct pending_dir_move *get_pending_dir_moves(struct send_ctx *sctx,
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
> +               fs_path_reset(name);
> +
> +               if (is_waiting_for_rm(sctx, ino))
> +                       break;
> +               if (is_waiting_for_move(sctx, ino)) {
> +                       if (*ancestor_ino == 0)
> +                               *ancestor_ino = ino;
> +                       ret = get_first_ref(sctx->parent_root, ino,
> +                                           &parent_inode, &parent_gen, name);
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
> @@ -3091,6 +3133,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>         struct waiting_dir_move *dm = NULL;
>         u64 rmdir_ino = 0;
>         int ret;
> +       u64 ancestor = 0;
>
>         name = fs_path_alloc();
>         from_path = fs_path_alloc();
> @@ -3122,6 +3165,22 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
>                 goto out;
>
>         sctx->send_progress = sctx->cur_ino + 1;
> +       ret = path_loop(sctx, name, pm->ino, pm->gen, &ancestor);
> +       if (ret) {
> +               LIST_HEAD(deleted_refs);
> +               ASSERT(ancestor > BTRFS_FIRST_FREE_OBJECTID);
> +               ret = add_pending_dir_move(sctx, pm->ino, pm->gen, ancestor,
> +                                          &pm->update_refs, &deleted_refs,
> +                                          pm->is_orphan);
> +               if (ret < 0)
> +                       goto out;
> +               if (rmdir_ino) {
> +                       dm = get_waiting_dir_move(sctx, pm->ino);
> +                       ASSERT(dm);
> +                       dm->rmdir_ino = rmdir_ino;
> +               }
> +               goto out;
> +       }
>         fs_path_reset(name);
>         to_path = name;
>         name = NULL;
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
