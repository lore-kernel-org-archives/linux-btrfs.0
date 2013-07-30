Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54078 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3G3HO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 03:14:57 -0400
Received: by mail-wi0-f171.google.com with SMTP id hr7so2256930wib.16
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 00:14:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373903973-2904-1-git-send-email-jbacik@fusionio.com>
References: <1373903973-2904-1-git-send-email-jbacik@fusionio.com>
Date: Tue, 30 Jul 2013 10:14:56 +0300
Message-ID: <CAOcd+r1Tdsg2tOE3NT9D38EiCe+KBCwJtaQaxHzXhD8NQaKVmA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: update drop progress before stopping snapshot dropping
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for posting that patch, Josef.

On Mon, Jul 15, 2013 at 6:59 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>
> Alex pointed out a problem and fix that exists in the drop one snapshot at
> a
> time patch.  If we decide we need to exit for whatever reason (umount for
> example) we will just exit the snapshot dropping without updating the drop
> progress.  So the next time we go to resume we will BUG_ON() because we
> can't
> find the extent we left off at because we never updated it.  This patch
> fixes
> the problem.
>
> Cc: stable@vger.kernel.org
> Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent-tree.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index bc00b24..8c204e1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7584,11 +7584,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>         wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
>
>         while (1) {
> -               if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
> -                       pr_debug("btrfs: drop snapshot early exit\n");
> -                       err = -EAGAIN;
> -                       goto out_end_trans;
> -               }
>
>                 ret = walk_down_tree(trans, root, path, wc);
>                 if (ret < 0) {
> @@ -7616,7 +7611,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 }
>
>                 BUG_ON(wc->level == 0);
> -               if (btrfs_should_end_transaction(trans, tree_root)) {
> +               if (btrfs_should_end_transaction(trans, tree_root) ||
> +                   (!for_reloc && btrfs_need_cleaner_sleep(root))) {
>                         ret = btrfs_update_root(trans, tree_root,
>                                                 &root->root_key,
>                                                 root_item);
> @@ -7627,6 +7623,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                         }
>
>                         btrfs_end_transaction_throttle(trans, tree_root);
> +                       if (!for_reloc && btrfs_need_cleaner_sleep(root))
> {
> +                               pr_debug("btrfs: drop snapshot early
> exit\n");
> +                               err = -EAGAIN;
> +                               goto out_free;
> +                       }
> +
>                         trans = btrfs_start_transaction(tree_root, 0);
>                         if (IS_ERR(trans)) {
>                                 err = PTR_ERR(trans);
> --
> 1.7.7.6
>
