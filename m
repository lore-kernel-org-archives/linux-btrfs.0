Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48723 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754933AbdCIOZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 09:25:12 -0500
Date: Thu, 9 Mar 2017 15:24:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: assertion failed: last_size == new_size, file: fs/btrfs/inode.c
Message-ID: <20170309142421.GF14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170227001842.dhrmaw3t3k4hkuii@codemonkey.org.uk>
 <20170227155348.GB13488@lim.localdomain>
 <20170227162342.z6j4bvinnqppwjjm@codemonkey.org.uk>
 <20170301011201.GB9546@lim.localdomain>
 <20170301200319.oqrftzsuj6u4nuuz@codemonkey.org.uk>
 <20170302155801.GA25834@localhost.localdomain>
 <20170303020432.GC26698@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170303020432.GC26698@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 02, 2017 at 06:04:33PM -0800, Liu Bo wrote:
> On Thu, Mar 02, 2017 at 07:58:01AM -0800, Liu Bo wrote:
> > On Wed, Mar 01, 2017 at 03:03:19PM -0500, Dave Jones wrote:
> > > On Tue, Feb 28, 2017 at 05:12:01PM -0800, Liu Bo wrote:
> > >  > On Mon, Feb 27, 2017 at 11:23:42AM -0500, Dave Jones wrote:
> > >  > > On Mon, Feb 27, 2017 at 07:53:48AM -0800, Liu Bo wrote:
> > >  > >  > On Sun, Feb 26, 2017 at 07:18:42PM -0500, Dave Jones wrote:
> > >  > >  > > Hitting this fairly frequently.. I'm not sure if this is the same bug I've
> > >  > >  > > been hitting occasionally since 4.9. The assertion looks new to me at least.
> > >  > >  > >
> > >  > >  > 
> > >  > >  > It was recently introduced by my commit and used to catch data loss at truncate.
> > >  > >  > 
> > >  > >  > Were you running the test with a mkfs.btrfs -O NO_HOLES?
> > >  > >  > (We just queued a fix for the NO_HOLES case in btrfs-next.)
> > >  > > 
> > >  > > No, a fs created with default mkfs.btrfs options.
> > >  > 
> > >  > I have this patch[1] to fix a bug which results in file hole extent, and this
> > >  > bug could lead us to hit the assertion.
> > >  > 
> > >  > Would you try to run the test w/ it, please?
> > >  > 
> > >  > [1]: https://patchwork.kernel.org/patch/9597281/
> > > 
> > > Made no difference. Still see the same trace & assertion.
> > 
> > Some updates here, I've got it reproduced, somehow a corner case ends up
> > with a inline file extent following by some pre-alloc extents, along the
> > way, isize also got updated unexpectedly.  Will try to narrow it down.
> >
> 
> I realized that btrfs now could tolerate files that mix inline extents with
> regular extents,

Where did that change? I thought that inline extent can represent only
the entire file, so any mixing of extents does not make sense to me.
Do you refer to some intermediate state where the file is being
converted from inline to non-inline, thus we could see both types of
extents at some point?

> so we don't need this ASSERT() anymore, will send a patch to
> remove it.
