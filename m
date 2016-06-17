Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbcFQQ3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 12:29:37 -0400
Date: Fri, 17 Jun 2016 18:30:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: let super_stripesize match with sectorsize
Message-ID: <20160617163012.GG4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465940023-27773-1-git-send-email-bo.li.liu@oracle.com>
 <69818794.Hm6NXvuvrY@reserved-192-168-1-6.rchland.ibm.com>
 <20160617060805.GA12750@localhost.localdomain>
 <2394326.6N7EYccQES@reserved-192-168-1-6.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2394326.6N7EYccQES@reserved-192-168-1-6.rchland.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 12:21:50PM +0530, Chandan Rajendra wrote:
> > > t%2dsend%2demail%2dchandan%40linux.vnet.ibm.com) restrict the stripesize
> > > to be either sectorsize or 4096. So I think these restrictions are good
> > > enough to make sure we don't get into the situation explained by you.
> > 
> > It's a workaround anyway, I'd rather fix the kernel to not use
> > stripesize and we can remove all checks against super_stripesize.
> > 
> > The code has evolved a lot to have free space align well to sectorsize,
> > so stripesize is not as necessary as when it's introduced firstly.
> > 
> 
> Yes, I mostly agree with what you are suggesting.
> 
> But, I am not completely sure about the following ...
> 
> static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
> {
>         /* TODO allow them to set a preferred stripe size */
>         return SZ_64K;
> }
> 
> Chris, Josef, David ...  Do you have any objections to replacing invocations
> of find_raid56_stripe_len() with BTRFS_STRIPE_LEN? Or do we need to retain
> find_raid56_stripe_len() to have the ability for having configurable
> stripesize in the future?

The stripe will be configurable some day, so please keep it for now.
