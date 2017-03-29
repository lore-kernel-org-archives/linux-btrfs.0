Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46975 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdC2Eh1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 00:37:27 -0400
Date: Tue, 28 Mar 2017 21:36:31 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: enable repair during read for raid56 profile
Message-ID: <20170329043631.GA306@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1490382815-25248-1-git-send-email-bo.li.liu@oracle.com>
 <20170327165944.GK4781@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170327165944.GK4781@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 27, 2017 at 06:59:44PM +0200, David Sterba wrote:
> On Fri, Mar 24, 2017 at 12:13:35PM -0700, Liu Bo wrote:
> > Now that scrub can fix data errors with the help of parity for raid56
> > profile, repair during read is able to as well.
> > 
> > Although the mirror num in raid56 senario has different meanings, i.e.
> 
> (typo: scenario)
>

Thanks!

> > 0 or 1: read data directly
> > > 1:    do recover with parity,
> > it could be fit into how we repair bad block during read.
> 
> Could we possibly add some symbolic names for the RAID56 case?
>

Yes, we could do that here, but I'm afraid it might not be helpful
because most of places still use mirror or mirror_num, such as
btrfs_submit_bio_hook and btrfs_map_bio.

> > 
> > The trick is to use BTRFS_MAP_READ instead of BTRFS_MAP_WRITE to get the
> > device and position on it.
> 
> Please also document the trick in the code before the following.
>

Good point.

Thanks,

-liubo
> > +	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num)) {
> > +		/* use BTRFS_MAP_READ to get the phy dev and sector */
> > +		ret = btrfs_map_block(fs_info, BTRFS_MAP_READ, logical,
> > +				      &map_length, &bbio, 0);
> > +		if (ret) {
> > +			btrfs_bio_counter_dec(fs_info);
> > +			bio_put(bio);
> > +			return -EIO;
> > +		}
> > +		ASSERT(bbio->mirror_num == 1);
> > +	} else {
> > +		ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
> > +				      &map_length, &bbio, mirror_num);
> > +		if (ret) {
> > +			btrfs_bio_counter_dec(fs_info);
> > +			bio_put(bio);
> > +			return -EIO;
> > +		}
> > +		BUG_ON(mirror_num != bbio->mirror_num);
> >  	}
> > -	BUG_ON(mirror_num != bbio->mirror_num);
> > -	sector = bbio->stripes[mirror_num-1].physical >> 9;
> > +
> > +	sector = bbio->stripes[bbio->mirror_num - 1].physical >> 9;
> >  	bio->bi_iter.bi_sector = sector;
> > -	dev = bbio->stripes[mirror_num-1].dev;
> > +	dev = bbio->stripes[bbio->mirror_num - 1].dev;
> >  	btrfs_put_bbio(bbio);
> >  	if (!dev || !dev->bdev || !dev->writeable) {
> >  		btrfs_bio_counter_dec(fs_info);
