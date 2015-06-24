Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbbFXSVc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 14:21:32 -0400
Date: Wed, 24 Jun 2015 20:21:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [RFC PATCH v2 2/2] Btrfs: improve fsync for nocow file
Message-ID: <20150624182130.GD726@suse.cz>
Reply-To: dsterba@suse.cz
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <1434527672-5762-2-git-send-email-bo.li.liu@oracle.com>
 <20150617155836.GZ6761@twin.jikos.cz>
 <20150618032722.GB8530@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150618032722.GB8530@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 11:27:24AM +0800, Liu Bo wrote:
> > >  #define BTRFS_INODE_IN_DELALLOC_LIST		9
> > >  #define BTRFS_INODE_READDIO_NEED_LOCK		10
> > >  #define BTRFS_INODE_HAS_PROPS		        11
> > > +#define BTRFS_INODE_NOTIMESTAMP			12
> > > +#define BTRFS_INODE_NOISIZE			13
> > 
> > It's not clear what the flags mean and that they're related to syncing
> > under some conditions.
> 
> What do you think about BTRFS_ILOG_NOTIMESTAMP and BTRFS_ILOG_NOISIZE? 

I'd say BTRFS_INODE_FSYNC_NOTIMESTAMP and BTRFS_INODE_FSYNC_NOSIZE

> > > @@ -1983,6 +2001,32 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> > >  		goto out;
> > >  	}
> > >  
> > > +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
> > > +		if (test_and_clear_bit(BTRFS_INODE_NOTIMESTAMP,
> > > +					&BTRFS_I(inode)->runtime_flags) &&
> > > +		    test_and_clear_bit(BTRFS_INODE_NOISIZE,
> > > +					&BTRFS_I(inode)->runtime_flags)) {
> > > +
> > > +			/* make sure data is on disk and catch error */
> > > +			if (!full_sync)
> > > +				ret = filemap_fdatawait_range(inode->i_mapping,
> > > +							      start, end);
> > > +
> > > +			if (!ret && !btrfs_test_opt(root, NOBARRIER)) {
> > > +				mutex_lock(&root->fs_info->
> > > +					   fs_devices->device_list_mutex);
> > > +				ret = barrier_all_devices(root->fs_info);
> > 
> > Calling barrier devices at this point looks very fishy, taking global
> > device locks to sync one file as well. All files in the filesystem will
> > pay the penalty for just one nodatacow file that's being synced.
> 
> Well, I'm afraid this is necessary as this is a fsync, an expensive operation,
> in the normal case, each fsync issues a superblock flush which calls barrier devices.
> 
> I was expecting to not take the global device lock but btrfs is able to
> manage multiple devices which requires us to do so.

I've read the code again and came to the same conclusion, objections
withdrawn.

> > I'm not sure that handling the NOISIZE bit is safe regarding size
> > extending and sync, ie. if it's properly synchronized with i_mutex from
> > all contexts.
> 
> That's also my concern, but the worst case is that someone clears
> NOISIZE bit and we continue on the normal fsync path.

Sounds safe.

> And this NOISIZE bit not only stands for i_size change, but also will be
> cleared when we do COW, I'm not sure if we need to use another bit for
> the COW change or not.

I'm not sure I understand, you mean split the NOISIZE into two bits and
use NOISIZE just for inode size change and the other one for the
cow_file_range case?

Btw, shouln't the NOISIZE bit get cleared inside cow_file_range? Both
calls are in run_delalloc_nocow, this makes sense, but I'm a bit worried
that we could forget to add it somewhere else. I don't think this would
hurt performance, cow_file_range is pretty big.
