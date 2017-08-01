Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35843 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbdHAR55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:57:57 -0400
Date: Tue, 1 Aug 2017 10:56:39 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Message-ID: <20170801165639.GB26357@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801172857.GY7140@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170801172857.GY7140@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 05:28:57PM +0000, Hugo Mills wrote:
>    Hi,
> 
>    Great to see something addressing the write hole at last.
> 
> On Tue, Aug 01, 2017 at 10:14:23AM -0600, Liu Bo wrote:
> > This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> > separate disk as a journal (aka raid5/6 log), so that after unclean
> > shutdown we can make sure data and parity are consistent on the raid
> > array by replaying the journal.
> 
>    What's the behaviour of the FS if the log device dies during use?
>

Error handling on IOs is still under construction (belongs to known
limitations).

If the log device dies suddenly, I think we could skip the writeback
to backend raid arrays and follow the rule in btrfs, filp FS to
readonly as it may expose data loss.  What do you think?

Thanks,

-liubo

>    Hugo.
> 
> > The idea and the code are similar to the write-through mode of md
> > raid5-cache, so ppl(partial parity log) is also feasible to implement.
> > (If you've been familiar with md, you may find this patch set is
> > boring to read...)
> > 
> > Patch 1-3 are about adding a log disk, patch 5-8 are the main part of
> > the implementation, the rest patches are improvements and bugfixes,
> > eg. readahead for recovery, checksum.
> > 
> > Two btrfs-progs patches are required to play with this patch set, one
> > is to enhance 'btrfs device add' to add a disk as raid5/6 log with the
> > option '-L', the other is to teach 'btrfs-show-super' to show
> > %journal_tail.
> > 
> > This is currently based on 4.12-rc3.
> > 
> > The patch set is tagged with RFC, and comments are always welcome,
> > thanks.
> > 
> > Known limitations:
> > - Deleting a log device is not implemented yet.
> > 
> > 
> > Liu Bo (14):
> >   Btrfs: raid56: add raid56 log via add_dev v2 ioctl
> >   Btrfs: raid56: do not allocate chunk on raid56 log
> >   Btrfs: raid56: detect raid56 log on mount
> >   Btrfs: raid56: add verbose debug
> >   Btrfs: raid56: add stripe log for raid5/6
> >   Btrfs: raid56: add reclaim support
> >   Btrfs: raid56: load r5log
> >   Btrfs: raid56: log recovery
> >   Btrfs: raid56: add readahead for recovery
> >   Btrfs: raid56: use the readahead helper to get page
> >   Btrfs: raid56: add csum support
> >   Btrfs: raid56: fix error handling while adding a log device
> >   Btrfs: raid56: initialize raid5/6 log after adding it
> >   Btrfs: raid56: maintain IO order on raid5/6 log
> > 
> >  fs/btrfs/ctree.h                |   16 +-
> >  fs/btrfs/disk-io.c              |   16 +
> >  fs/btrfs/ioctl.c                |   48 +-
> >  fs/btrfs/raid56.c               | 1429 ++++++++++++++++++++++++++++++++++-----
> >  fs/btrfs/raid56.h               |   82 +++
> >  fs/btrfs/transaction.c          |    2 +
> >  fs/btrfs/volumes.c              |   56 +-
> >  fs/btrfs/volumes.h              |    7 +-
> >  include/uapi/linux/btrfs.h      |    3 +
> >  include/uapi/linux/btrfs_tree.h |    4 +
> >  10 files changed, 1487 insertions(+), 176 deletions(-)
> > 
> 
> -- 
> Hugo Mills             | Some days, it's just not worth gnawing through the
> hugo@... carfax.org.uk | straps
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |


