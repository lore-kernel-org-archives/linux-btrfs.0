Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3951 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750878AbcAUKG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 05:06:58 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Mason'" <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com> <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com> <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
In-Reply-To: <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
Subject: RE: [PATCH 1/2] btrfs: reada: limit max works count
Date: Thu, 21 Jan 2016 18:06:21 +0800
Message-ID: <00a501d15433$61275d10$23761730$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris Mason

> -----Original Message-----
> From: Chris Mason [mailto:clm@fb.com]
> Sent: Thursday, January 21, 2016 1:48 AM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 1/2] btrfs: reada: limit max works count
> 
> On Wed, Jan 20, 2016 at 10:16:27AM -0500, Chris Mason wrote:
> > On Tue, Jan 12, 2016 at 03:46:26PM +0800, Zhao Lei wrote:
> > > reada create 2 works for each level of tree in recursion.
> > >
> > > In case of a tree having many levels, the number of created works is
> > > 2^level_of_tree.
> > > Actually we don't need so many works in parallel, this patch limit
> > > max works to BTRFS_MAX_MIRRORS * 2.
> >
> > Hi,
> >
> > I don't think you end up calling atomic_dec() for every time that
> > reada_start_machine() is called.  Also, I'd rather not have a global
> > static variable to limit the parallel workers, when we have more than
> > one FS mounted it'll end up limiting things too much.
> >
> > With this patch applied, I'm seeing deadlocks during btrfs/066.    You
> > have to run the scrub tests as well, basically we're just getting
> > fsstress run alongside scrub.
> >
> > I'll run a few more times with it reverted to make sure, but I think
> > it's the root cause.
> 
> I spoke too soon, it ended up deadlocking a few tests later.
>
In logic, even if the calculation of atomic_dec() in this patch having bug,
in worst condition, reada will works in single-thread mode, and will not
introduce deadlock.

And by looking the backtrace in this mail, maybe it is caused by
reada_control->elems in someplace of this patchset.

I recheck xfstests/066 in both vm and physical machine, on top of my pull-request
git today, with btrfs-progs 4.4 for many times, but had not triggered the bug.

Could you tell me your test environment(TEST_DEV size, mount option),
and odds of fails in btrfs/066?

Thanks
Zhaolei

> Sorry for now I'm pulling all the reada patches.  We'll sort out bug fixes vs cleanups in later rcs.
> 
> With all of the reada patches removed, the deadlocks are gone.
> 
> -chris




