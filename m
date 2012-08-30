Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:48564 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2H3QZO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 12:25:14 -0400
Date: Thu, 30 Aug 2012 12:25:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Message-ID: <20120830162512.GA2879@localhost.localdomain>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2012 at 09:18:07AM -0600, Mitch Harder wrote:
> I've been trying out different leafsize/nodesize settings by
> benchmarking some typical operations.
> 
> These changes had more impact than I expected.  Using a
> leafsize/nodesize of either 8192 or 16384 provided a noticeable
> improvement in my limited testing.
> 
> These results are similar to some that Chris Mason has already
> reported:  https://oss.oracle.com/~mason/blocksizes/
> 
> I noticed that metadata allocation was more efficient with bigger
> block sizes.  My data was git kernel sources, which will utilize
> btrfs' inlining.  This may have tilted the scales.
> 
> Read operations seemed to benefit the most.  Write operations seemed
> to get punished when the leafsize/nodesize was increased to 64K.
> 
> Are there any known downsides to using a leafsize/nodesize bigger than
> the default 4096?
> 

Once you cross some hardware dependant threshold (usually past 32k) you start
incurring high memmove() overhead in most workloads.  Like all benchmarking its
good to test your workload and see what works best, but 16k should generally be
the best option.  Thanks,

Josef
