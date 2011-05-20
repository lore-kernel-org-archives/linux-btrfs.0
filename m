From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: fix crash when no drive supports DISCARD
Date: Fri, 20 May 2011 10:15:46 -0400
Message-ID: <4DD67792.2060409@redhat.com>
References: <20110517152743.GU12709@twin.jikos.cz> <1305648031-26379-1-git-send-email-dsterba@suse.cz> <201105181129.14201.lidongyang@novell.com> <20110520115224.GW12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Li Dongyang <lidongyang@novell.com>,
	David Sterba <dsterba@suse.cz>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, stable@kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110520115224.GW12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2011 07:52 AM, David Sterba wrote:
> On Wed, May 18, 2011 at 11:29:14AM +0800, Li Dongyang wrote:
>> Thanks for the fix, I thought EOPNOTSUPP could be useful by the caller
>> that time, and maybe we could do somthing like remove the discard
>> mount_opt in the fs_info so we can avoid calling it again.
> 
> I do not agree that discard should be removed from mount_opt, because
> one may add TRIM-capable devices later, it's a whole filesystem option,
> while. A disappeared discard mount option will probably cause panic
> in administrator's head.
> 
> However, if a drive does not support TRIM, the btrfs_issue_discard calls
> can take a shortcut and do not call up to blkdev_issue_discard (though
> it does return immediatelly), caching the state after first call. But
> this is matter of the lower level call (blkdev) and should not be
> propagated beyond to the extent "level" (ie. btrfs_discard_extent).
> 

There ought to just be a flag added to btrfs_device to say whether or
not it supports discard, and if we get back EOPNOTSUPP we stop putting
discards down on that device, that way if we have some devices that do
it and some that don't (like for instance if we do that tiered caching
with ssd's thing) we can make sure discard is actually done on drives
that care about it.  Thanks,

Josef
