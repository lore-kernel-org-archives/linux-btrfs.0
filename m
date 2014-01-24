Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:38402 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaAXMDJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 07:03:09 -0500
Received: by mail-bk0-f43.google.com with SMTP id mx11so1087848bkb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 04:03:08 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1390520802-17483-1-git-send-email-jbacik@fb.com>
References: <1390520802-17483-1-git-send-email-jbacik@fb.com>
Date: Fri, 24 Jan 2014 12:03:07 +0000
Message-ID: <CAL3q7H5pjok1_KL3n42K-V8Q6XG8uPexOaUpujJgoYobfi5OSA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix qgroup rescan to work with skinny metadata V2
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 23, 2014 at 11:46 PM, Josef Bacik <jbacik@fb.com> wrote:
> Could have sworn I fixed this before but apparently not.  This makes us pass
> btrfs/022 with skinny metadata enabled.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Filipe Manana <fdmanana@gmail.com>

> ---
> V1->V2: use && instead of ||
>
>  fs/btrfs/qgroup.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index d22e0a1..472302a 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1897,9 +1897,17 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>         mutex_unlock(&fs_info->qgroup_rescan_lock);
>
>         for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
> +               u64 num_bytes;
> +
>                 btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
> -               if (found.type != BTRFS_EXTENT_ITEM_KEY)
> +               if (found.type != BTRFS_EXTENT_ITEM_KEY &&
> +                   found.type != BTRFS_METADATA_ITEM_KEY)
>                         continue;
> +               if (found.type == BTRFS_METADATA_ITEM_KEY)
> +                       num_bytes = fs_info->extent_root->leafsize;
> +               else
> +                       num_bytes = found.offset;
> +
>                 ret = btrfs_find_all_roots(trans, fs_info, found.objectid,
>                                            tree_mod_seq_elem.seq, &roots);
>                 if (ret < 0)
> @@ -1944,12 +1952,12 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>                         struct btrfs_qgroup_list *glist;
>
>                         qg = (struct btrfs_qgroup *)(uintptr_t) unode->aux;
> -                       qg->rfer += found.offset;
> -                       qg->rfer_cmpr += found.offset;
> +                       qg->rfer += num_bytes;
> +                       qg->rfer_cmpr += num_bytes;
>                         WARN_ON(qg->tag >= seq);
>                         if (qg->refcnt - seq == roots->nnodes) {
> -                               qg->excl += found.offset;
> -                               qg->excl_cmpr += found.offset;
> +                               qg->excl += num_bytes;
> +                               qg->excl_cmpr += num_bytes;
>                         }
>                         qgroup_dirty(fs_info, qg);
>
> --
> 1.8.3.1
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
