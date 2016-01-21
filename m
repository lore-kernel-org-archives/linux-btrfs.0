Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31655 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757755AbcAUDhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 22:37:24 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Mason'" <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <9d3a1b584cec0081382f832ab0a7f9b31b1d9798.1452584763.git.zhaolei@cn.fujitsu.com> <20160120151627.kuy3auwiguoe6xc6@floor.thefacebook.com> <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
In-Reply-To: <20160120174823.ck5zeoihwsrbvoih@floor.thefacebook.com>
Subject: RE: [PATCH 1/2] btrfs: reada: limit max works count
Date: Thu, 21 Jan 2016 11:36:49 +0800
Message-ID: <009001d153fc$f629bed0$e27d3c70$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



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
> I spoke too soon, it ended up deadlocking a few tests later.  Sorry for now I'm
> pulling all the reada patches.  We'll sort out bug fixes vs cleanups in later rcs.
> 
> With all of the reada patches removed, the deadlocks are gone.
> 
Sorry for hear it.

Actually I run xfstests with all patch applied, and see no regression in my env:

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 lenovo 4.4.0-rc6_HEAD_8e16378041f7f3531c256fd3e17a36a4fca92d29_+
MKFS_OPTIONS  -- /dev/sdb6
MOUNT_OPTIONS -- /dev/sdb6 /var/ltf/tester/scratch_mnt

btrfs/066 151s ... 164s
Ran: btrfs/066
Passed all 1 tests

I'll investigate the root reason.

Thanks
Zhaolei

> -chris




