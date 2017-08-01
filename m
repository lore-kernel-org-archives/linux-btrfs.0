Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41722 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751928AbdHASZV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:25:21 -0400
Date: Tue, 1 Aug 2017 11:24:12 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Message-ID: <20170801172411.GE26357@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 07:42:14PM +0200, Goffredo Baroncelli wrote:
> Hi Liu,
> 
> On 2017-08-01 18:14, Liu Bo wrote:
> > This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> > separate disk as a journal (aka raid5/6 log), so that after unclean
> > shutdown we can make sure data and parity are consistent on the raid
> > array by replaying the journal.
> > 
> 
> it would be possible to have more information ?
> - what is logged ? data, parity or data + parity ?

Patch 5 has more details(sorry for not making it clear that in the
cover letter).

So both data and parity are logged so that while replaying the journal
everything is written to whichever disk it should be written to.

> - in the past I thought that it would be sufficient to log only the stripe position involved by a RMW cycle, and then start a scrub on these stripes in case of an unclean shutdown: do you think that it is feasible ?

An unclean shutdown causes inconsistence between data and parity, so
scrub won't help as it's not able to tell which one (data or parity)
is valid.

With nodatacow, we do overwrite, so RMW during unclean shutdown is not safe.
With datacow, we don't do overwrite, but the following situation may happen,
say we have a raid5 setup with 3 disks, the stripe length is 64k, so

1) write 64K  --> now the raid layout is
[64K data + 64K random + 64K parity]
2) write another 64K --> now the raid layout after RMW is
[64K 1)'s data + 64K 2)'s data + 64K new parity]

If unclean shutdown occurs before 2) finishes, then parity may be
corrupted and then 1)'s data may be recovered wrongly if the disk
which holds 1)'s data is offline.

> - does this journal disk also host other btrfs log ?
>

No, purely data/parity and some associated metadata.

Thanks,

-liubo

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
> 
> -- 
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
