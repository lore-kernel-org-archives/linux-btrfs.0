Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5043 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759175AbcAUOPd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 09:15:33 -0500
Date: Thu, 21 Jan 2016 09:14:44 -0500
From: Chris Mason <clm@fb.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: reada: limit max works count
Message-ID: <20160121141444.gygz5lrkerq67lxz@floor.thefacebook.com>
References: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com>
 <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com>
 <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
 <00a501d15433$61275d10$23761730$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <00a501d15433$61275d10$23761730$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 06:06:21PM +0800, Zhao Lei wrote:
> Hi, Chris Mason
> 
> > -----Original Message-----
> > From: Chris Mason [mailto:clm@fb.com]
> > Sent: Thursday, January 21, 2016 1:48 AM
> > To: Zhao Lei <zhaolei@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> > Subject: Re: [PATCH 1/2] btrfs: reada: limit max works count
> > 
> > On Wed, Jan 20, 2016 at 10:16:27AM -0500, Chris Mason wrote:
> > > On Tue, Jan 12, 2016 at 03:46:26PM +0800, Zhao Lei wrote:
> > > > reada create 2 works for each level of tree in recursion.
> > > >
> > > > In case of a tree having many levels, the number of created works is
> > > > 2^level_of_tree.
> > > > Actually we don't need so many works in parallel, this patch limit
> > > > max works to BTRFS_MAX_MIRRORS * 2.
> > >
> > > Hi,
> > >
> > > I don't think you end up calling atomic_dec() for every time that
> > > reada_start_machine() is called.  Also, I'd rather not have a global
> > > static variable to limit the parallel workers, when we have more than
> > > one FS mounted it'll end up limiting things too much.
> > >
> > > With this patch applied, I'm seeing deadlocks during btrfs/066.    You
> > > have to run the scrub tests as well, basically we're just getting
> > > fsstress run alongside scrub.
> > >
> > > I'll run a few more times with it reverted to make sure, but I think
> > > it's the root cause.
> > 
> > I spoke too soon, it ended up deadlocking a few tests later.
> >
> In logic, even if the calculation of atomic_dec() in this patch having bug,
> in worst condition, reada will works in single-thread mode, and will not
> introduce deadlock.
> 
> And by looking the backtrace in this mail, maybe it is caused by
> reada_control->elems in someplace of this patchset.
> 
> I recheck xfstests/066 in both vm and physical machine, on top of my pull-request
> git today, with btrfs-progs 4.4 for many times, but had not triggered the bug.

Just running 066 alone doesn't trigger it for me.  I have to run
everything from 00->066.

My setup is 5 drives.  I use a script to carve them up into logical
volumes, 5 for the test device and 5 for the scratch pool.  I think it
should reproduce with a single drive, if you still can't trigger I'll
confirm that.

> 
> Could you tell me your test environment(TEST_DEV size, mount option),
> and odds of fails in btrfs/066?

100% odds of failing, one time it made it up to btrfs/072.  I think more
important than the drive setup is that I have all the debugging on.
CONFIG_DEBUG_PAGEALLOC, spinlock debugging, mutex debugging and lock dep
enabled.

-chris
