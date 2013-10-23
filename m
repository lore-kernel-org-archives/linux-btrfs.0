Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6391 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660Ab3JWVn3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 17:43:29 -0400
Date: Thu, 24 Oct 2013 08:43:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, Eryu Guan <eguan@redhat.com>,
        xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests btrfs/020: test device replace on RO btrfs
Message-ID: <20131023214323.GQ2797@dastard>
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
 <1382546683-454-1-git-send-email-eguan@redhat.com>
 <526801EF.8030307@giantdisaster.de>
 <52680B23.9020604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52680B23.9020604@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 23, 2013 at 12:45:07PM -0500, Eric Sandeen wrote:
> On 10/23/13 12:05 PM, Stefan Behrens wrote:
> > On Thu, 24 Oct 2013 00:44:43 +0800, Eryu Guan wrote:
> >> +# real QA test starts here
> >> +_supported_fs btrfs
> >> +_supported_os Linux
> > 
> > It is still unclear to me why everybody adds this "_supported_os Linux"
> > to the Btrfs tests. Is it because loop devices are used in this
> > particular test btrfs/020 or is it because of Btrfs itself?
> > tests/btrfs/001..010 and tests/btrfs/012..020 contain the "_supported_os
> > Linux".
> 
> Historically xfstests could be run on IRIX & Linux, so some tests needed
> to differentiate for the capabilities of the OS.
> 
> We could probably look at how _supported_os works, and make sure that
> if it's absent, it means "no OS restrictions" and document it as such.

It already does work this way. If you don't add it, then the test
will always run.

However, it also has the documentation factor of saying "we expect
this to work on Linux's btrfs implementation *only*". IOWs, it's
good practice to add the _supported_os field as xfstests is not
designed to be Linux specific....

> "_supported_fs btrfs" is probably sufficient to know that we can run this
> test; if btrfs is ever ported to, say, Solaris, it *should* run there too.  ;)

Unless, of course, there are differences in implementation, which
there would be given that, for example, Solaris handles devices
significantly differently to Linux. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
