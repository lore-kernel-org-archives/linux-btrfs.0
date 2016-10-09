Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32228 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbcJIX4P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 19:56:15 -0400
Date: Mon, 10 Oct 2016 10:56:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is is possible to submit binary image as fstest test case?
Message-ID: <20161009235612.GN9806@dastard>
References: <53250876-4992-971e-ed37-054f03ef555f@cn.fujitsu.com>
 <20161007091838.GG9806@dastard>
 <20161007160551.GD11398@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161007160551.GD11398@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 06:05:51PM +0200, David Sterba wrote:
> On Fri, Oct 07, 2016 at 08:18:38PM +1100, Dave Chinner wrote:
> > On Thu, Oct 06, 2016 at 04:12:56PM +0800, Qu Wenruo wrote:
> > > So I'm wondering if I can just upload a zipped raw image as part of
> > > the test case?
> > 
> > Preferably not. We've managed to avoid pre-built images in xfstests
> > for 15 years, so there'd have to be a really good reason to start
> > doing this, especially as once we open that floodgate we'll end up
> > with everyone wanting to do this and it will blow out the size of
> > the repository in now time.
> > 
> > If the issue is just timing or being unable to trigger an error
> > at the right time, this is what error injection frameworks or
> > debug-only sysfs hooks are for. The XFS kernel code has both,
> > xfstests use both, and they pretty much do away with the need for
> > custom binary filesystem images for such testing...
> 
> Error injection framework may not be alwasy available, eg. in kernels
> built for production. Yet I'd like to make the test possible.

Why would you ever enable error injection on a production kernel?
We simply don't run the error injection tests when the
infrastructure is not there, jsut like we do with all other tests
that are depenent on optional kernel/fs features....

> Also, I find it useful to keep the exact images that are attached to a
> report and not necessarily try to recreate it to trigger a bug. If the
> images are small, hosting them with the sources makes testing easy.
> Big images would probably go to own repository and be linked.
> 
> I don't really expect fstests to store crafted images and would advise
> Qu to not even try to propose that, because the answer was quite
> predictable.

You say that like it's a bad thing?  What's the guarantee that a
specific corrupt image will always be sufficient to trigger the
problem the test is supposed to check? i.e. we could change a
different part of the FS code and that could mask the bug the image
used to trigger. The test then passes, but we haven't actually fix
the bug that the test used to exercise. i.e. we've got a false "we
fixed the problem" report, when all we did is prevent a specific
vector from tripping over it.

Error injection and sysfs hooks into debug code are much more
reliable ways of testing that the root cause of a problem is fixed
and stays fixed.  The reproducing trigger cannot be masked by
changes in other code layers, so we know that if the error
injection/sysfs hook test handles the problem correctly, we have
actually fixed the underlying bug and not just masked it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
