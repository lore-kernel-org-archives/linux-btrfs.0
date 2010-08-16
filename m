From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.35 performance results
Date: Mon, 16 Aug 2010 16:04:44 -0400
Message-ID: <20100816200444.GJ993@think>
References: <4C5C57FB.4090003@dangyankee.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <steve@dangyankee.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5C57FB.4090003@dangyankee.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 06, 2010 at 01:44:11PM -0500, Steven Pratt wrote:
> Here is the latest set of performance runs from the 2.6.35-rc5 tree.
> Included is a refresh of all the other filesystems with some changes
> for barriers on and off since this has been somewhat of a hot topic
> recently.
> 
> New data linked in to the history graphs here:
> http://btrfs.boxacle.net/repository/raid/history/History.html
> 
> From a BTRFS performance perspective, we took a major regression on
> write heavy workloads. As much as a 10x hit!  The problems seems to
> be due to this changeset:
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=5da9d01b66458b180a6bee0e637a1d0a3effc622
> Btrfs: Shrink delay allocated space in a synchronized
> 
> Shrink delayed allocation space in a synchronized manner is more
> controllable than flushing all delay allocated space in an async
> thread.
> 
> This changeset introduced "btrfs_start_one_delalloc_inode" in
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commitdiff;h=5da9d01b66458b180a6bee0e637a1d0a3effc622
> 
> In heavy write workloads this new function is now dominating the profiles:
> 
> samples  %        app name                 symbol name
> 8914973  65.1261  btrfs.ko                 btrfs_start_one_delalloc_inode

Hi Steve,

I think I know why this is a problem and how to fix it, but I'm having a
trouble reproducing this exact setup.  Which of your tests was this
oprofile from?

-chris
