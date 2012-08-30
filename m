Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41510 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2H3VuL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 17:50:11 -0400
Date: Thu, 30 Aug 2012 17:50:08 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Message-ID: <20120830215008.GB2879@localhost.localdomain>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
 <20120830162512.GA2879@localhost.localdomain>
 <201208302334.49399.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201208302334.49399.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2012 at 03:34:49PM -0600, Martin Steigerwald wrote:
> Am Donnerstag, 30. August 2012 schrieb Josef Bacik:
> > On Thu, Aug 30, 2012 at 09:18:07AM -0600, Mitch Harder wrote:
> > > I've been trying out different leafsize/nodesize settings by
> > > benchmarking some typical operations.
> > > 
> > > These changes had more impact than I expected.  Using a
> > > leafsize/nodesize of either 8192 or 16384 provided a noticeable
> > > improvement in my limited testing.
> > > 
> > > These results are similar to some that Chris Mason has already
> > > reported:  https://oss.oracle.com/~mason/blocksizes/
> > > 
> > > I noticed that metadata allocation was more efficient with bigger
> > > block sizes.  My data was git kernel sources, which will utilize
> > > btrfs' inlining.  This may have tilted the scales.
> > > 
> > > Read operations seemed to benefit the most.  Write operations seemed
> > > to get punished when the leafsize/nodesize was increased to 64K.
> > > 
> > > Are there any known downsides to using a leafsize/nodesize bigger
> > > than the default 4096?
> > 
> > Once you cross some hardware dependant threshold (usually past 32k) you
> > start incurring high memmove() overhead in most workloads.  Like all
> > benchmarking its good to test your workload and see what works best,
> > but 16k should generally be the best option.  Thanks,
> 
> I wanted to ask about 32k either.
> 
> I used 32k on one 2,5 inch external esata disk. But I never measured 
> anything so far.
> 
> I wonder what a good value for SSD might be. I tend to not use anymore 
> than 16k, but thats just some gut feeling right now. Nothing based on a 
> well-founded explaination.
>

32k really starts to depend on your workload.  Generally speaking everybody will
be faster with 16k, but 32k starts to depend on your workload and hardware, and
then anything about 64k really starts to hurt with memmove().  With this sort of
thing SSD vs not isn't going to make much of a difference, erase blocks tend to
be several megs in size so you aren't going to get anywhere close to avoiding
the internal RMW cycle inside the ssd.  Thanks,

Josef
