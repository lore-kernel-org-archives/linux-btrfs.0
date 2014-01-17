Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaAQQO6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 11:14:58 -0500
Date: Fri, 17 Jan 2014 17:14:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20140117161456.GX6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
 <1388391175-29539-16-git-send-email-bo.li.liu@oracle.com>
 <20140114173419.GA6498@twin.jikos.cz>
 <20140115013516.GA11175@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140115013516.GA11175@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 15, 2014 at 09:35:17AM +0800, Liu Bo wrote:
> > > @@ -430,6 +430,15 @@ struct btrfs_ioctl_get_dev_stats {
> > >  	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> > >  };
> > >  
> > > +/* deduplication control ioctl modes */
> > > +#define BTRFS_DEDUP_CTL_ENABLE 1
> > > +#define BTRFS_DEDUP_CTL_DISABLE 2
> > > +#define BTRFS_DEDUP_CTL_SET_BS 3
> > > +struct btrfs_ioctl_dedup_args {
> > > +	__u64 cmd;
> > > +	__u64 bs;
> > 
> > I've spotted that you did not reserve any space for future extensions of
> > the ioctl, especially the in-band dedup can be quite heavy, I think
> > we'll want some tunables in the future.
> > 
> 
> Good point, I think 128 bytes can be enough for that, agree?

Yes, should be enough.
