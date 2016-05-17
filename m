Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbcEQNh6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:37:58 -0400
Date: Tue, 17 May 2016 15:37:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com
Subject: Re: [PATCH 2/2] Btrfs: add valid checks for chunk loading
Message-ID: <20160517133730.GR511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <1462212951-28113-2-git-send-email-bo.li.liu@oracle.com>
 <20160504135626.GV29353@twin.jikos.cz>
 <20160513235717.GC27734@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160513235717.GC27734@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 04:57:17PM -0700, Liu Bo wrote:
> > > +								      chunk));
> > > +		return -EIO;
> > > +	}
> > >  	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
> > >  		btrfs_err(root->fs_info,
> > >  			"invalid chunk length %llu", length);
> > >  		return -EIO;
> > >  	}
> > > -	if (!is_power_of_2(stripe_len)) {
> > > +	if (stripe_len != BTRFS_STRIPE_LEN) {
> > 
> > Again too strict. As mentined elsewhere, add a helper to validate
> > stripe_len and use it so we don't open-code it.
> 
> I'm not sure I understand the comment about open-code, right now
> the value must be BTRFS_STRIPE_LEN and we don't set any other value,
> are we going to add a helper for just (stripe_len != BTRFS_STRIPE_LEN)?

mkfs.btrfs will create stripesize == 4k, forcing this to
BTRFS_STRIPE_LEN will suddenly prevent mounting of lots of filesystems.
IIRC the stripe length check was done in several places so even if the
helper is simple we'll change the condition in one place once we'll
decide what are the acceptable values.
