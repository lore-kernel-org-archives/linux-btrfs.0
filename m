Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33501 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaDIPBx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 11:01:53 -0400
Received: by mail-qg0-f46.google.com with SMTP id 63so2299878qgz.19
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Apr 2014 08:01:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395946611-6568-1-git-send-email-jbacik@fb.com>
References: <1395946611-6568-1-git-send-email-jbacik@fb.com>
Date: Wed, 9 Apr 2014 23:01:53 +0800
Message-ID: <CAP9B-QmJhzV0q1qaMA-WN2wb-Ro-NURWk7LqM_VjW7Jm=eYrXA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not reset last_snapshot after relocation
From: Shilong Wang <wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

2014-03-28 2:56 GMT+08:00 Josef Bacik <jbacik@fb.com>:
> This was done to allow NO_COW to continue to be NO_COW after relocation but it
> is not right.  When relocating we will convert blocks to FULL_BACKREF that we
> relocate.  We can leave some of these full backref blocks behind if they are not
> cow'ed out during the relocation, like if we fail the relocation with ENOSPC and
> then just drop the reloc tree.  Then when we go to cow the block again we won't
> lookup the extent flags because we won't think there has been a snapshot
> recently which means we will do our normal ref drop thing instead of adding back
> a tree ref and dropping the shared ref.  This will cause btrfs_free_extent to
> blow up because it can't find the ref we are trying to free.  This was found
> with my ref verifying tool.  Thanks,

Could we pass error into merge_reloc_roots() something like this:

merge_reloc_roots(struct reloc_control *rc, int err)

and we only skip reset root's last snapshot if  @err is not 0. I think
it is meaningful
to allow NO_COW to continue after relocation.

Thanks,
Wang
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/relocation.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index ec00777..f026a82 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -2318,7 +2318,6 @@ void free_reloc_roots(struct list_head *list)
>  static noinline_for_stack
>  int merge_reloc_roots(struct reloc_control *rc)
>  {
> -       struct btrfs_trans_handle *trans;
>         struct btrfs_root *root;
>         struct btrfs_root *reloc_root;
>         u64 last_snap;
> @@ -2376,26 +2375,6 @@ again:
>                                 list_add_tail(&reloc_root->root_list,
>                                               &reloc_roots);
>                         goto out;
> -               } else if (!ret) {
> -                       /*
> -                        * recover the last snapshot tranid to avoid
> -                        * the space balance break NOCOW.
> -                        */
> -                       root = read_fs_root(rc->extent_root->fs_info,
> -                                           objectid);
> -                       if (IS_ERR(root))
> -                               continue;
> -
> -                       trans = btrfs_join_transaction(root);
> -                       BUG_ON(IS_ERR(trans));
> -
> -                       /* Check if the fs/file tree was snapshoted or not. */
> -                       if (btrfs_root_last_snapshot(&root->root_item) ==
> -                           otransid - 1)
> -                               btrfs_set_root_last_snapshot(&root->root_item,
> -                                                            last_snap);
> -
> -                       btrfs_end_transaction(trans, root);
>                 }
>         }
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
