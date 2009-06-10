From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix write_dev_supers
Date: Wed, 10 Jun 2009 17:02:48 -0400
Message-ID: <20090610210248.GA11258@think>
References: <6.0.0.20.2.20090608181508.05e4b708@172.19.0.2> <20090609112516.GB4009@think> <6.0.0.20.2.20090610161317.071bb638@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090610161317.071bb638@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2009 at 04:32:31PM +0900, Hisashi Hifumi wrote:
> 
> At 20:25 09/06/09, Chris Mason wrote:
> >On Tue, Jun 09, 2009 at 10:46:55AM +0900, Hisashi Hifumi wrote:
> >> Hi.
> >> 
> >> I got following BUG trace.
> >> This is violation of BUG_ON(!buffer_locked(bh)) check on submit_bh() function.
> >> In write_dev_supers(), if wait parameter is set and buffer_uptodate() check
> >> is negative,  submit_bh() is executed and hit above BUG_ON.
> >> So I fixed this issue.
> >
> >Thanks for finding this bug and sending the patch.
> >
> >This function is very confusing.  If wait parameter is set, it
> >isn't supposed to do any IO at all.  The caller first does
> >write_dev_supers with wait == 0, and that sends all the supers down on
> >all the devices.
> >
> >Then it calls again with wait == 1, which is supposed to make sure all
> >the supers actually got to disk.
> >
> >We should change the wait == 0 behavior to leave a reference held on all
> >the buffers, and wait == 1 to drop that reference.  That way the buffer
> >won't disappear while we are waiting, and we can return an error if the
> >buffer wasn't up to date when wait == 1.
> >
> 
> Like this?
> 
> I changed wait == 0 case to get extra ref and on wait == 1 case if buffer is 
> uptodate, bh releases ref otherwise buffer takes lock to proceed to submit_bh.

That's very close to what I had in mind, thank you.  In reviewing this I
realized that write_dev_supers had other bugs, including a race with
device add/removal.  So, I took your patch and edited it slightly.  You
could you please check the change I put into newformat2 branch?

In this version, wait == 1 only waits for IO and does not try to start
it, I think it makes it more clear overall.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git newformat2

Thanks!

-chris
