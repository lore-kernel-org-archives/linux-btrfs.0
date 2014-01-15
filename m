Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43796 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaAOBfc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 20:35:32 -0500
Date: Wed, 15 Jan 2014 09:35:17 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20140115013516.GA11175@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
 <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
 <20140114173419.GA6498@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140114173419.GA6498@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 14, 2014 at 06:34:19PM +0100, David Sterba wrote:
> On Mon, Dec 30, 2013 at 04:12:55PM +0800, Liu Bo wrote:
> > --- a/ctree.h
> > +++ b/ctree.h
> > @@ -470,6 +470,7 @@ struct btrfs_super_block {
> >  #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
> >  #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
> >  #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
> > +#define BTRFS_FEATURE_INCOMPAT_DEDUP		(1ULL << 9)
> 
> FYI, this incompat bit is taken by Josef's NO_HOLE feature, now heading
> to next merge window, so I've used 10 for dedup in integration branch.

Thanks for the notice, David, I'll update it in the next version.

> 
> > --- a/ioctl.h
> > +++ b/ioctl.h
> > @@ -430,6 +430,15 @@ struct btrfs_ioctl_get_dev_stats {
> >  	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> >  };
> >  
> > +/* deduplication control ioctl modes */
> > +#define BTRFS_DEDUP_CTL_ENABLE 1
> > +#define BTRFS_DEDUP_CTL_DISABLE 2
> > +#define BTRFS_DEDUP_CTL_SET_BS 3
> > +struct btrfs_ioctl_dedup_args {
> > +	__u64 cmd;
> > +	__u64 bs;
> 
> I've spotted that you did not reserve any space for future extensions of
> the ioctl, especially the in-band dedup can be quite heavy, I think
> we'll want some tunables in the future.
> 

Good point, I think 128 bytes can be enough for that, agree?

I didn't put much notice on that because I kept stuck in fixing more urgent ENOSPC
problem, it looks like I can hardly bypass this endless issue with dedup enabled,
I have to fix it thoroughly...

Thanks,
-liubo
