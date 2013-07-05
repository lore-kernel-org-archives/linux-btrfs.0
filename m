Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47772 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3GECVu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 22:21:50 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 869617C0696
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jul 2013 20:21:50 -0600 (MDT)
Date: Thu, 4 Jul 2013 22:21:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
Message-ID: <20130705022147.GC2260@localhost.localdomain>
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
 <CAOcd+r0RM0YD+Ycky9S_h-LtLAkkztL1z-Ppp8W_85DuQP0t7w@mail.gmail.com>
 <20130704170337.GU18204@suse.cz>
 <CAOcd+r05Ph8TSeZFw+fdysm2Cr3g7yrpX7q7BHyY81+y8_LYmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r05Ph8TSeZFw+fdysm2Cr3g7yrpX7q7BHyY81+y8_LYmw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 04, 2013 at 10:52:39PM +0300, Alex Lyakas wrote:
> Hi David,
> 
> On Thu, Jul 4, 2013 at 8:03 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Jul 04, 2013 at 06:29:23PM +0300, Alex Lyakas wrote:
> >> > @@ -7363,6 +7365,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
> >> >         wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
> >> >
> >> >         while (1) {
> >> > +               if (!for_reloc && btrfs_fs_closing(root->fs_info)) {
> >> > +                       pr_debug("btrfs: drop snapshot early exit\n");
> >> > +                       err = -EAGAIN;
> >> > +                       goto out_end_trans;
> >> > +               }
> >> Here you exit the loop, but the "drop_progress" in the root item is
> >> incorrect. When the system is remounted, and snapshot deletion
> >> resumes, it seems that it tries to resume from the EXTENT_ITEM that
> >> does not exist anymore, and [1] shows that btrfs_lookup_extent_info()
> >> simply does not find the needed extent.
> >> So then I hit panic in walk_down_tree():
> >> BUG: wc->refs[level - 1] == 0
> >>
> >> I fixed it like follows:
> >> There is a place where btrfs_drop_snapshot() checks if it needs to
> >> detach from transaction and re-attach. So I moved the exit point there
> >> and the code is like this:
> >>
> >>               if (btrfs_should_end_transaction(trans, tree_root) ||
> >>                       (!for_reloc && btrfs_need_cleaner_sleep(root))) {
> >>                       ret = btrfs_update_root(trans, tree_root,
> >>                                               &root->root_key,
> >>                                               root_item);
> >>                       if (ret) {
> >>                               btrfs_abort_transaction(trans, tree_root, ret);
> >>                               err = ret;
> >>                               goto out_end_trans;
> >>                       }
> >>
> >>                       btrfs_end_transaction_throttle(trans, tree_root);
> >>                       if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
> >>                               err = -EAGAIN;
> >>                               goto out_free;
> >>                       }
> >>                       trans = btrfs_start_transaction(tree_root, 0);
> >> ...
> >>
> >> With this fix, I do not hit the panic, and snapshot deletion proceeds
> >> and completes alright after mount.
> >>
> >> Do you agree to my analysis or I am missing something? It seems that
> >> Josef's btrfs-next still has this issue (as does Chris's for-linus).
> >
> > Sound analysis and I agree with the fix. The clean-by-one patch has been
> > merged into 3.10 so we need a stable fix for that.
> Thanks for confirming, David!
> 
> From more testing, I have two more notes:
> 
> # After applying the fix, whenever snapshot deletion is resumed after
> mount, and successfully completes, then I unmount again, and rmmod
> btrfs, linux complains about loosing few "struct extent_buffer" during
> kem_cache_delete().
> So somewhere on that path:
> if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
>     ...
> 	} else {
>     ===> HERE
> 
> and later we perhaps somehow overwrite the contents of "struct
> btrfs_path" that is used in the whole function. Because at the end of
> the function we always do btrfs_free_path(), which inside does
> btrfs_release_path().  I was not able to determine where the leak
> happens, do you have any hint? No other activity happens in the system
> except the resumed snap deletion, and this problem only happens when
> resuming.
> 
> # This is for Josef: after I unmount the fs with ongoing snap deletion
> (after applying my fix), and run the latest btrfsck - it complains a
> lot about problems in extent tree:( But after I mount again, snap
> deletion resumes then completes, then I unmount and btrfsck is happy
> again. So probably it does not account orphan roots properly?
> 

It should but it may not be working properly.  I know it works right for normal
inodes, probably not too hard to fix it for snapshots, I'll throw it on the TODO
list.  Thanks,

Josef
