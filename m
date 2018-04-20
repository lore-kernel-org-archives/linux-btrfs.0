Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbeDTMAo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 08:00:44 -0400
Date: Fri, 20 Apr 2018 13:58:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 12/16] btrfs: track running balance in a simpler way
Message-ID: <20180420115811.GM21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1524146555.git.dsterba@suse.com>
 <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
 <6ab5bdc1-45a2-d0a4-cdc7-587731c4103a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6ab5bdc1-45a2-d0a4-cdc7-587731c4103a@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 20, 2018 at 03:52:24PM +0800, Anand Jain wrote:
> 
> 
> On 04/20/2018 12:33 AM, David Sterba wrote:
> > Currently fs_info::balance_running is 0 or 1 and does not use the
> > semantics of atomics. The pause and cancel check for 0, that can happen
> > only after __btrfs_balance exits for whatever reason.
> > 
> > Parallel calls to balance ioctl may enter btrfs_ioctl_balance multiple
> > times but will block on the balance_mutex that protects the
> > fs_info::flags bit.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/ctree.h   |  6 +++++-
> >   fs/btrfs/disk-io.c |  1 -
> >   fs/btrfs/ioctl.c   |  6 +++---
> >   fs/btrfs/volumes.c | 18 ++++++++++--------
> >   4 files changed, 18 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 011cb9a8a967..fda94a264eb7 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -726,6 +726,11 @@ struct btrfs_delayed_root;
> >    * (device replace, resize, device add/delete, balance)
> >    */
> >   #define BTRFS_FS_EXCL_OP			16
> > +/*
> > + * Indicate that balance has been set up from the ioctl and is in the main
> > + * phase. The fs_info::balance_ctl is initialized.
> > + */
> > +#define BTRFS_FS_BALANCE_RUNNING		17
> 
> 
>   Change looks good to me as such and its a good idea to drop
>     fs_info::balance_running;
> 
>   However instead of making BTRFS_FS_BALANCE_RUNNING part of
>     btrfs_fs_info::flags
>   pls make it part of
>     btrfs_balance_control::flags
> 
>   Because:
>   We already have BTRFS_BALANCE_RESUME there.
>   And at fs_info level BTRFS_FS_EXCL_OP tells someone excl is running.
>   And if its a balance (either in running or implicit-paused state)
>   then btrfs_fs_info::balance_ctl is not NULL.

This would work fine, if the btrfs_balance_control::flags were not copy
of the ioctl structure. There are the filter flags stored there, in
addition to BTRFS_BALANCE_RESUME.

>From that point it's the balance ioctl interface and adding the internal
runtime flag does not seem to fit.

The status bit could be tracked separatelly in btrfs_balance_control so
it does not use the whole filesystem flag namespace, as it's always used
under balance mutex.

As this is simple change to the patch, I'll do that.
