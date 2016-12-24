Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37345 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752594AbcLXASM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 19:18:12 -0500
Date: Fri, 23 Dec 2016 16:18:00 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Message-ID: <20161224001800.GA11160@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
 <25132456.GqS7QuRSzf@localhost.localdomain>
 <2606394.PBVynvYKAF@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2606394.PBVynvYKAF@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2016 at 05:27:55PM +0530, Chandan Rajendra wrote:
> On Friday, December 23, 2016 03:57:40 PM Chandan Rajendra wrote:
> > On Friday, December 23, 2016 03:00:18 PM Chandan Rajendra wrote:
> > > The following deadlock is seen when executing generic/113 test,
> > > 
> > >  ---------------------------------------------------------+----------------------------------------------------
> > >   Direct I/O task                                           Fast fsync task
> > >  ---------------------------------------------------------+----------------------------------------------------
> > >   btrfs_direct_IO
> > >     __blockdev_direct_IO
> > >      do_blockdev_direct_IO
> > >       do_direct_IO
> > >        btrfs_get_blocks_direct
> > >         while (blocks needs to written)
> > >          get_more_blocks (first iteration)
> > >           btrfs_get_blocks_direct
> > >            btrfs_create_dio_extent
> > >              down_read(&BTRFS_I(inode) >dio_sem)
> > >              Create and add extent map and ordered extent
> > >              up_read(&BTRFS_I(inode) >dio_sem)
> > >                                                             btrfs_sync_file
> > >                                                               btrfs_log_dentry_safe
> > >                                                                btrfs_log_inode_parent
> > >                                                                 btrfs_log_inode
> > >                                                                  btrfs_log_changed_extents
> > >                                                                   down_write(&BTRFS_I(inode) >dio_sem)
> > >                                                                    Collect new extent maps and ordered extents
> > >                                                                     wait for ordered extent completion
> > >          get_more_blocks (second iteration)
> > >           btrfs_get_blocks_direct
> > >            btrfs_create_dio_extent
> > >              down_read(&BTRFS_I(inode) >dio_sem)
> > >  --------------------------------------------------------------------------------------------------------------
> > > 
> > > In the above description, Btrfs direct I/O code path has not yet started
> > > submitting bios for file range covered by the initial ordered
> > > extent. Meanwhile, The fast fsync task obtains the write semaphore and
> > > waits for I/O on the ordered extent to get completed. However, the
> > > Direct I/O task is now blocked on obtaining the read semaphore.
> > > 
> > > To resolve the deadlock, this commit modifies the Direct I/O code path
> > > to obtain the read semaphore before invoking
> > > __blockdev_direct_IO(). The semaphore is then given up after
> > > __blockdev_direct_IO() returns. This allows the Direct I/O code to
> > > complete I/O on all the ordered extents it creates.
> > >
> > 
> > Btw, I was able to reproduce the issue on kdave/for-next branch with "Merge
> > branch 'for-next-next-4.9-20161125' into for-next-20161125" as the topmost
> > commit. The issue cannot be reproduced yet on latest code available from
> > kdave/for-next branch.
> > 
> >
> 
> Maybe changes in upstream might have masked the issue in the recent
> kdave/for-next branch. I say that because 'git bisect' resulted in the
> following commit ...

I guess that the for-next branch didn't revert this patch[1] as upstream
did, so that generic/113 would complain, however, even w/o that patch,
this fix is still required since the deadlock could be reproduced by
running generic/113 with '-ofragment=data' and in fact Filipe has
proposed a almost same fix but not a real patch in this thread [2].

[1]: Btrfs: adjust len of writes if following a preallocated extent
https://patchwork.kernel.org/patch/9413129/
[2]: https://patchwork.kernel.org/patch/9445231/

Thanks,

-liubo

> 
> e3597e6090ddf40904dce6d0a5a404e2c490cac6
> Author:     Chris Mason <clm@fb.com>
> AuthorDate: Tue Nov 1 12:54:45 2016 -0700
> Commit:     Chris Mason <clm@fb.com>
> CommitDate: Tue Nov 1 12:54:45 2016 -0700
> 
> Parent:     570dd45 btrfs: fix races on root_log_ctx lists
> Parent:     9d1032c btrfs: fix WARNING in btrfs_select_ref_head()
> Merged:     btrfs-next-for-linus-4.8 kdave-master linus-v4.7-rc6 local-v4.7-rc4
> Containing: direct-io-fsync-deadlock kdave-for-next
> Follows:    v4.8-rc8 (57)
> Precedes:   next-20161219 (30006)
> 
> Merge branch 'for-4.9-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.9
> 
> 5 files changed, 29 insertions(+), 9 deletions(-)
> fs/btrfs/extent-tree.c |  3 +++
> fs/btrfs/extent_io.c   |  8 ++++----
> fs/btrfs/inode.c       | 13 +++++++++----
> fs/btrfs/ioctl.c       |  5 +++++
> fs/btrfs/relocation.c  |  9 ++++++++-
> 
> -- 
> chandan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
