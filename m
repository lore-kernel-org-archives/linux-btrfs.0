From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: fix crash when no drive supports DISCARD
Date: Fri, 20 May 2011 13:52:24 +0200
Message-ID: <20110520115224.GW12709@twin.jikos.cz>
References: <20110517152743.GU12709@twin.jikos.cz>
 <1305648031-26379-1-git-send-email-dsterba@suse.cz>
 <201105181129.14201.lidongyang@novell.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, stable@kernel.org
To: Li Dongyang <lidongyang@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105181129.14201.lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 18, 2011 at 11:29:14AM +0800, Li Dongyang wrote:
> Thanks for the fix, I thought EOPNOTSUPP could be useful by the caller
> that time, and maybe we could do somthing like remove the discard
> mount_opt in the fs_info so we can avoid calling it again.

I do not agree that discard should be removed from mount_opt, because
one may add TRIM-capable devices later, it's a whole filesystem option,
while. A disappeared discard mount option will probably cause panic
in administrator's head.

However, if a drive does not support TRIM, the btrfs_issue_discard calls
can take a shortcut and do not call up to blkdev_issue_discard (though
it does return immediatelly), caching the state after first call. But
this is matter of the lower level call (blkdev) and should not be
propagated beyond to the extent "level" (ie. btrfs_discard_extent).


david
