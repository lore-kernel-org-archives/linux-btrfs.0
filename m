Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42945 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab3GOQlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 12:41:32 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D42A47C067F
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 10:41:31 -0600 (MDT)
Date: Mon, 15 Jul 2013 12:41:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
Message-ID: <20130715164129.GB3085@localhost.localdomain>
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
 <CAOcd+r0RM0YD+Ycky9S_h-LtLAkkztL1z-Ppp8W_85DuQP0t7w@mail.gmail.com>
 <20130704170337.GU18204@suse.cz>
 <CAOcd+r05Ph8TSeZFw+fdysm2Cr3g7yrpX7q7BHyY81+y8_LYmw@mail.gmail.com>
 <CAOcd+r1eSPRb5ysoOTD4xbK59+JVcN4K7n6PkFGWwdZ7cm3aZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1eSPRb5ysoOTD4xbK59+JVcN4K7n6PkFGWwdZ7cm3aZg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 14, 2013 at 07:20:04PM +0300, Alex Lyakas wrote:
> Hi,
> 
> On Thu, Jul 4, 2013 at 10:52 PM, Alex Lyakas
> <alex.btrfs@zadarastorage.com> wrote:
> > Hi David,
> >
> > On Thu, Jul 4, 2013 at 8:03 PM, David Sterba <dsterba@suse.cz> wrote:
> >> On Thu, Jul 04, 2013 at 06:29:23PM +0300, Alex Lyakas wrote:
> >>> > @@ -7363,6 +7365,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
> >>> >         wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
> >>> >
> >>> >         while (1) {
> >>> > +               if (!for_reloc && btrfs_fs_closing(root->fs_info)) {
> >>> > +                       pr_debug("btrfs: drop snapshot early exit\n");
> >>> > +                       err = -EAGAIN;
> >>> > +                       goto out_end_trans;
> >>> > +               }
> >>> Here you exit the loop, but the "drop_progress" in the root item is
> >>> incorrect. When the system is remounted, and snapshot deletion
> >>> resumes, it seems that it tries to resume from the EXTENT_ITEM that
> >>> does not exist anymore, and [1] shows that btrfs_lookup_extent_info()
> >>> simply does not find the needed extent.
> >>> So then I hit panic in walk_down_tree():
> >>> BUG: wc->refs[level - 1] == 0
> >>>
> >>> I fixed it like follows:
> >>> There is a place where btrfs_drop_snapshot() checks if it needs to
> >>> detach from transaction and re-attach. So I moved the exit point there
> >>> and the code is like this:
> >>>
> >>>               if (btrfs_should_end_transaction(trans, tree_root) ||
> >>>                       (!for_reloc && btrfs_need_cleaner_sleep(root))) {
> >>>                       ret = btrfs_update_root(trans, tree_root,
> >>>                                               &root->root_key,
> >>>                                               root_item);
> >>>                       if (ret) {
> >>>                               btrfs_abort_transaction(trans, tree_root, ret);
> >>>                               err = ret;
> >>>                               goto out_end_trans;
> >>>                       }
> >>>
> >>>                       btrfs_end_transaction_throttle(trans, tree_root);
> >>>                       if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
> >>>                               err = -EAGAIN;
> >>>                               goto out_free;
> >>>                       }
> >>>                       trans = btrfs_start_transaction(tree_root, 0);
> >>> ...
> >>>
> >>> With this fix, I do not hit the panic, and snapshot deletion proceeds
> >>> and completes alright after mount.
> >>>
> >>> Do you agree to my analysis or I am missing something? It seems that
> >>> Josef's btrfs-next still has this issue (as does Chris's for-linus).
> >>
> >> Sound analysis and I agree with the fix. The clean-by-one patch has been
> >> merged into 3.10 so we need a stable fix for that.
> > Thanks for confirming, David!
> >
> > From more testing, I have two more notes:
> >
> > # After applying the fix, whenever snapshot deletion is resumed after
> > mount, and successfully completes, then I unmount again, and rmmod
> > btrfs, linux complains about loosing few "struct extent_buffer" during
> > kem_cache_delete().
> > So somewhere on that path:
> > if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
> >     ...
> >         } else {
> >     ===> HERE
> >
> > and later we perhaps somehow overwrite the contents of "struct
> > btrfs_path" that is used in the whole function. Because at the end of
> > the function we always do btrfs_free_path(), which inside does
> > btrfs_release_path().  I was not able to determine where the leak
> > happens, do you have any hint? No other activity happens in the system
> > except the resumed snap deletion, and this problem only happens when
> > resuming.
> >
> I found where the memory leak happens. When we abort snapshot deletion
> in the middle, then this btrfs_root is basically left alone hanging in
> the air. It is out of the "dead_roots" already, so when del_fs_roots()
> is called during unmount, it will not free this root and its
> root->node (which is the one that triggers memory leak warning on
> kmem_cache_destroy) and perhaps other stuff too. The issue still
> exists in btrfs-next.
> 
> Simplest fix I came up with was:
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d275681..52a2c54 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7468,6 +7468,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>         int err = 0;
>         int ret;
>         int level;
> +       bool root_freed = false;
> 
>         path = btrfs_alloc_path();
>         if (!path) {
> @@ -7641,6 +7642,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 free_extent_buffer(root->commit_root);
>                 btrfs_put_fs_root(root);
>         }
> +       root_freed = true;
> +
>  out_end_trans:
>         btrfs_end_transaction_throttle(trans, tree_root);
>  out_free:
> @@ -7649,6 +7652,18 @@ out_free:
>  out:
>         if (err)
>                 btrfs_std_error(root->fs_info, err);
> +
> +       /*
> +        * If the root was not freed by any reason, this means that FS had
> +        * a problem and will probably be unmounted soon.
> +        * But we need to put the root back into the 'dead_roots' list,
> +        * so that it will be properly freed during unmount.
> +        */
> +       if (!root_freed) {
> +               WARN_ON(err == 0);
> +               btrfs_add_dead_root(root);
> +       }
> +
>         return err;
>  }
> 
> With this fix, I don't see any memleak warnings (also by enabling
> LEAK_DEBUG) while aborting and resuming snapshot deletion.
> 
> 
> > # This is for Josef: after I unmount the fs with ongoing snap deletion
> > (after applying my fix), and run the latest btrfsck - it complains a
> > lot about problems in extent tree:( But after I mount again, snap
> > deletion resumes then completes, then I unmount and btrfsck is happy
> > again. So probably it does not account orphan roots properly?
> >
> > David, will you provide a fixed patch, if possible?
> >
> 
> Josef, David, I feel that I am not helpful enough by pinpointing the
> problem and suggesting a fix, but not providing actual patch that
> fixes it and can be applied. The reason is that it is difficult for me
> to test the fix thoroughly on the latest upstream kernel (like
> btrfs-next), for reasons I'm sure you understand. So I appreciate if
> you could post these two fixes to the upstream kernel; but otherwise,
> I will try to work and test them on the latest kernel myself.
> 

This is perfect, you've given great fixes and great analysis.  Since you have an
actual patch for this one please re-send with a Signed-off-by and such so I can
apply it.  Thanks,

Josef
