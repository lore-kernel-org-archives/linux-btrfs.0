Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbcAEMOy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 07:14:54 -0500
Date: Tue, 5 Jan 2016 13:12:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, fdmanana@gmail.com,
        chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: Intialize btrfs_root->highest_objectid when
 loading tree root and subvolume roots
Message-ID: <20160105121234.GT4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20151007092503.GG7734@twin.jikos.cz>
 <8703019.0plYdL21k7@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8703019.0plYdL21k7@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2015 at 07:40:46PM +0530, Chandan Rajendra wrote:
> On Wednesday 07 Oct 2015 11:25:03 David Sterba wrote:
> > On Mon, Oct 05, 2015 at 10:14:24PM +0530, Chandan Rajendra wrote:
> > > +	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
> > > +		mutex_unlock(&root->objectid_mutex);
> > > +		ret = -ENOSPC;
> > 
> > ENOSPC ... I don't think it's right as this could be with a normal
> > enospc during subvolume creation. The problem is that theh inode number
> > space is exhausted, the closest error code I see is EOVERFLOW. As this
> > is an ioctl we can afford to define the meaning of this return value as
> > such (unlike for eg. creat()/open()).
> > 
> > > +		goto free_root_dev;
> > > +	}
> > > +
> > > +	mutex_unlock(&root->objectid_mutex);
> > > +
> > > 
> > >  	return 0;
> 
> David, Are you suggesting that we return -EOVERFLOW from within
> btrfs_init_fs_root() and continue returning -ENOSPC in case of error
> (i.e. tree_root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID) from
> open_ctree()?
> 
> If yes, btrfs_init_fs_root() gets invoked from open_ctree() via
> btrfs_read_fs_root_no_name() and hence we may end up returning -EOVERFLOW when
> servicing the mount() syscall.

Sorry for not answering that. As you're going to resend it, please
use EOVERFLOW in the btrfs_init_fs_root. We should not hit the overflow
error in the mount path.
