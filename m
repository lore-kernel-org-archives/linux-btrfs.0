Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33858 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757169AbcHETei (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Aug 2016 15:34:38 -0400
Subject: Re: [4.8] btrfs heats my room with lock contention
To: Dave Chinner <david@fromorbit.com>
References: <20160804064105.GT12670@dastard>
 <da05a44e-22f3-bbbb-4757-3f04ad98d758@fb.com>
 <20160805030127.GW12670@dastard>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <3b07c682-e885-13fc-048c-b4b1b657e6a6@fb.com>
Date: Fri, 5 Aug 2016 15:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <20160805030127.GW12670@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/04/2016 11:01 PM, Dave Chinner wrote:
> On Thu, Aug 04, 2016 at 10:28:44AM -0400, Chris Mason wrote:
>>
>>
>> On 08/04/2016 02:41 AM, Dave Chinner wrote:
>>>
>>> Simple test. 8GB pmem device on a 16p machine:
>>>
>>> # mkfs.btrfs /dev/pmem1
>>> # mount /dev/pmem1 /mnt/scratch
>>> # dbench -t 60 -D /mnt/scratch 16
>>>
>>> And heat your room with the warm air rising from your CPUs. Top
>>> half of the btrfs profile looks like:
> .....
>>> Performance vs CPu usage is:
>>>
>>> nprocs		throughput		cpu usage
>>> 1		440MB/s			 50%
>>> 2		770MB/s			100%
>>> 4		880MB/s			250%
>>> 8		690MB/s			450%
>>> 16		280MB/s			950%
>>>
>>> In comparision, at 8-16 threads ext4 is running at ~2600MB/s and
>>> XFS is running at ~3800MB/s. Even if I throw 300-400 processes at
>>> ext4 and XFS, they only drop to ~1500-2000MB/s as they hit internal
>>> limits.
>>>
>> Yes, with dbench btrfs does much much better if you make a subvol
>> per dbench dir.  The difference is pretty dramatic.  I'm working on
>> it this month, but focusing more on database workloads right now.
>
> You've been giving this answer to lock contention reports for the
> past 6-7 years, Chris.  I really don't care about getting big
> benchmark numbers with contrived setups - the "use multiple
> subvolumes" solution is simply not practical for users or their
> workloads.  The default config should behave sanely and not not
> contribute to global warming like this.
>

The btree setup that makes lock contention here makes some other 
benchmarks faster.  Needing to create subvolumes in order to fix 
performance problems on dbench is far from ideal, but in production here 
the tradeoffs have been worth it.

Basically this one definitely comes up during dbench and fs_mark and 
much less often elsewhere.  For the workloads that hit this lock 
contention, splitting things out into subvolumes hugely reduces metadata 
fragmentation on reads.  So it's not just CPU we're helping with 
subvolumes but spindle time too.

It's true I haven't invested time into guessing when the admin wants to 
split on a per-subvolume basis.  Still, I do love the polar bears, so 
I'll take another shot at the btree lock.

-chris
