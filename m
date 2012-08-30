Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57192 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2H3Veu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 17:34:50 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Date: Thu, 30 Aug 2012 23:34:49 +0200
Cc: Josef Bacik <jbacik@fusionio.com>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com> <20120830162512.GA2879@localhost.localdomain> (sfid-20120830_183916_436101_60C7E225)
In-Reply-To: <20120830162512.GA2879@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208302334.49399.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 30. August 2012 schrieb Josef Bacik:
> On Thu, Aug 30, 2012 at 09:18:07AM -0600, Mitch Harder wrote:
> > I've been trying out different leafsize/nodesize settings by
> > benchmarking some typical operations.
> > 
> > These changes had more impact than I expected.  Using a
> > leafsize/nodesize of either 8192 or 16384 provided a noticeable
> > improvement in my limited testing.
> > 
> > These results are similar to some that Chris Mason has already
> > reported:  https://oss.oracle.com/~mason/blocksizes/
> > 
> > I noticed that metadata allocation was more efficient with bigger
> > block sizes.  My data was git kernel sources, which will utilize
> > btrfs' inlining.  This may have tilted the scales.
> > 
> > Read operations seemed to benefit the most.  Write operations seemed
> > to get punished when the leafsize/nodesize was increased to 64K.
> > 
> > Are there any known downsides to using a leafsize/nodesize bigger
> > than the default 4096?
> 
> Once you cross some hardware dependant threshold (usually past 32k) you
> start incurring high memmove() overhead in most workloads.  Like all
> benchmarking its good to test your workload and see what works best,
> but 16k should generally be the best option.  Thanks,

I wanted to ask about 32k either.

I used 32k on one 2,5 inch external esata disk. But I never measured 
anything so far.

I wonder what a good value for SSD might be. I tend to not use anymore 
than 16k, but thats just some gut feeling right now. Nothing based on a 
well-founded explaination.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
