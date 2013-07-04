Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3GDRDk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jul 2013 13:03:40 -0400
Date: Thu, 4 Jul 2013 19:03:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
Message-ID: <20130704170337.GU18204@suse.cz>
Reply-To: dsterba@suse.cz
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
 <CAOcd+r0RM0YD+Ycky9S_h-LtLAkkztL1z-Ppp8W_85DuQP0t7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r0RM0YD+Ycky9S_h-LtLAkkztL1z-Ppp8W_85DuQP0t7w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 04, 2013 at 06:29:23PM +0300, Alex Lyakas wrote:
> > @@ -7363,6 +7365,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
> >         wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
> >
> >         while (1) {
> > +               if (!for_reloc && btrfs_fs_closing(root->fs_info)) {
> > +                       pr_debug("btrfs: drop snapshot early exit\n");
> > +                       err = -EAGAIN;
> > +                       goto out_end_trans;
> > +               }
> Here you exit the loop, but the "drop_progress" in the root item is
> incorrect. When the system is remounted, and snapshot deletion
> resumes, it seems that it tries to resume from the EXTENT_ITEM that
> does not exist anymore, and [1] shows that btrfs_lookup_extent_info()
> simply does not find the needed extent.
> So then I hit panic in walk_down_tree():
> BUG: wc->refs[level - 1] == 0
> 
> I fixed it like follows:
> There is a place where btrfs_drop_snapshot() checks if it needs to
> detach from transaction and re-attach. So I moved the exit point there
> and the code is like this:
> 
> 		if (btrfs_should_end_transaction(trans, tree_root) ||
> 			(!for_reloc && btrfs_need_cleaner_sleep(root))) {
> 			ret = btrfs_update_root(trans, tree_root,
> 						&root->root_key,
> 						root_item);
> 			if (ret) {
> 				btrfs_abort_transaction(trans, tree_root, ret);
> 				err = ret;
> 				goto out_end_trans;
> 			}
> 
> 			btrfs_end_transaction_throttle(trans, tree_root);
> 			if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
> 				err = -EAGAIN;
> 				goto out_free;
> 			}
> 			trans = btrfs_start_transaction(tree_root, 0);
> ...
> 
> With this fix, I do not hit the panic, and snapshot deletion proceeds
> and completes alright after mount.
> 
> Do you agree to my analysis or I am missing something? It seems that
> Josef's btrfs-next still has this issue (as does Chris's for-linus).

Sound analysis and I agree with the fix. The clean-by-one patch has been
merged into 3.10 so we need a stable fix for that.

thanks,
david
