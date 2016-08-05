Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5803 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030AbcHEDCG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 23:02:06 -0400
Date: Fri, 5 Aug 2016 13:01:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [4.8] btrfs heats my room with lock contention
Message-ID: <20160805030127.GW12670@dastard>
References: <20160804064105.GT12670@dastard>
 <da05a44e-22f3-bbbb-4757-3f04ad98d758@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <da05a44e-22f3-bbbb-4757-3f04ad98d758@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 04, 2016 at 10:28:44AM -0400, Chris Mason wrote:
> 
> 
> On 08/04/2016 02:41 AM, Dave Chinner wrote:
> >
> >Simple test. 8GB pmem device on a 16p machine:
> >
> ># mkfs.btrfs /dev/pmem1
> ># mount /dev/pmem1 /mnt/scratch
> ># dbench -t 60 -D /mnt/scratch 16
> >
> >And heat your room with the warm air rising from your CPUs. Top
> >half of the btrfs profile looks like:
.....
> >Performance vs CPu usage is:
> >
> >nprocs		throughput		cpu usage
> >1		440MB/s			 50%
> >2		770MB/s			100%
> >4		880MB/s			250%
> >8		690MB/s			450%
> >16		280MB/s			950%
> >
> >In comparision, at 8-16 threads ext4 is running at ~2600MB/s and
> >XFS is running at ~3800MB/s. Even if I throw 300-400 processes at
> >ext4 and XFS, they only drop to ~1500-2000MB/s as they hit internal
> >limits.
> >
> Yes, with dbench btrfs does much much better if you make a subvol
> per dbench dir.  The difference is pretty dramatic.  I'm working on
> it this month, but focusing more on database workloads right now.

You've been giving this answer to lock contention reports for the
past 6-7 years, Chris.  I really don't care about getting big
benchmark numbers with contrived setups - the "use multiple
subvolumes" solution is simply not practical for users or their
workloads.  The default config should behave sanely and not not
contribute to global warming like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
