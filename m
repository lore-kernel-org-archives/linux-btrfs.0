Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730Ab3D2WRw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 18:17:52 -0400
Date: Tue, 30 Apr 2013 00:17:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [bug] 3.9-rc7+next: NULL deref in
 btrfs_next_old_leaf/btrfs_search_slot
Message-ID: <20130429221750.GT16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130418144218.GH16427@twin.jikos.cz>
 <20130425171858.GM16427@twin.jikos.cz>
 <20130427025042.GB999@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130427025042.GB999@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 27, 2013 at 10:50:43AM +0800, Liu Bo wrote:
> > @@ -3486,14 +3486,14 @@ int close_ctree(struct btrfs_root *root)
> >                        percpu_counter_sum(&fs_info->delalloc_bytes));
> >         }
> > 
> > -       free_root_pointers(fs_info, 1);
> > -
> >         btrfs_free_block_groups(fs_info);
> > 
> >         del_fs_roots(fs_info);
> > 
> >         iput(fs_info->btree_inode);
> > 
> > +       free_root_pointers(fs_info, 1);
> > +
> >         btrfs_stop_workers(&fs_info->generic_worker);
> >         btrfs_stop_workers(&fs_info->fixup_workers);
> >         btrfs_stop_workers(&fs_info->delalloc_workers);
> > ---
> 
> Thanks for tracking it Dave, I'm trying to reproduce it here.

Adding sleeps between free_root_pointers and stopping workers should
leave enough space for the threads to work and touch the freed data.

The proposed fix is not entirely correct, it just reduces the race
window. Freeing roots must come after stopping the workers, same holds
for any of the other cleanup functions that may access released
resources. But for example the free block groups need the caching thread
alive so it cannot be trivially fixed by moving everything after
stop_workers and must be decided case by case.

There is another instance of a similar sequence that is mis-ordered and
has to be fixed as well.


david
