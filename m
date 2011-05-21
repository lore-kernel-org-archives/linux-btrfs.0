From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH] btrfs: fix crash when no drive supports DISCARD
Date: Sat, 21 May 2011 16:26:04 +0800
Message-ID: <201105211626.05071.lidongyang@novell.com>
References: <20110517152743.GU12709@twin.jikos.cz> <20110520115224.GW12709@twin.jikos.cz> <4DD67792.2060409@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: David Sterba <dsterba@suse.cz>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, stable@kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD67792.2060409@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, May 20, 2011 10:15:46 PM Josef Bacik wrote:
> On 05/20/2011 07:52 AM, David Sterba wrote:
> > On Wed, May 18, 2011 at 11:29:14AM +0800, Li Dongyang wrote:
> >> Thanks for the fix, I thought EOPNOTSUPP could be useful by the caller
> >> that time, and maybe we could do somthing like remove the discard
> >> mount_opt in the fs_info so we can avoid calling it again.
> > 
> > I do not agree that discard should be removed from mount_opt, because
> > one may add TRIM-capable devices later, it's a whole filesystem option,
> > while. A disappeared discard mount option will probably cause panic
> > in administrator's head.
> > 
> > However, if a drive does not support TRIM, the btrfs_issue_discard calls
> > can take a shortcut and do not call up to blkdev_issue_discard (though
> > it does return immediatelly), caching the state after first call. But
> > this is matter of the lower level call (blkdev) and should not be
> > propagated beyond to the extent "level" (ie. btrfs_discard_extent).
> > 
> 
> There ought to just be a flag added to btrfs_device to say whether or
> not it supports discard, and if we get back EOPNOTSUPP we stop putting
> discards down on that device, that way if we have some devices that do
> it and some that don't (like for instance if we do that tiered caching
> with ssd's thing) we can make sure discard is actually done on drives
> that care about it.  Thanks,
> 
> Josef
> 
This should be the best way. but if we do not export the EOPNOTSUPP to callers
of btrfs_discard_extent, we will get no errors if we run fstrim on a btrfs which
all the devices don't have trim, I think this is not what we want.

Before commit 5378e60734f5b7bfe1b43dc191aaf6131c1befe7, btrfs_discard_extent
will only return the error of btrfs_map_block,so I think we should move the BUG_ONs in
to btrfs_discard_extent from the callers as actually they are testing the result of
btrfs_map_block.

Thanks
Li Dongyang
