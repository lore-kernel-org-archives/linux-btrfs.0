Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaIDMXO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Sep 2014 08:23:14 -0400
Date: Thu, 4 Sep 2014 15:23:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Btrfs: kfree()ing ERR_PTRs
Message-ID: <20140904122302.GP6549@mwanda>
References: <20140904110915.GB21504@mwanda>
 <540856D4.8010903@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <540856D4.8010903@bfs.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 04, 2014 at 02:11:00PM +0200, walter harms wrote:
> >  	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
> >  					      vol_args->fd, subvol, ptr,
> >  					      readonly, inherit);
> > +	if (ret)
> > +		goto free_inherit;
> >  
> > -	if (ret == 0 && ptr &&
> > -	    copy_to_user(arg +
> > -			 offsetof(struct btrfs_ioctl_vol_args_v2,
> > -				  transid), ptr, sizeof(*ptr)))
> > +	if (ptr && copy_to_user(arg +
> > +				offsetof(struct btrfs_ioctl_vol_args_v2,
> > +					transid),
> > +				ptr, sizeof(*ptr)))
> >  		ret = -EFAULT;
> 
> 
> this is hard to read.
> perhaps it would help to move ptr into the other other
> 
> if (ret || !ptr )
>   goto free_inherit;

I don't think that's an improvement.

> 
> both are modified by the call btrfs_ioctl_snap_create_transid().
> 

I think you are mixing up ptr and *ptr so that's why you're confused.

regards,
dan carpenter

