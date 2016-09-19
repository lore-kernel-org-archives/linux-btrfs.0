Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44649 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbcISCXy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Sep 2016 22:23:54 -0400
Subject: Re: RAID1 availability issue[2], Hot-spare and auto-replace
To: Chris Murphy <lists@colorremedies.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
 <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
 <20160917203519.GE933@twin.jikos.cz>
 <f1b74a5d-1fdf-2970-86fc-206a4bb26d78@oracle.com>
 <CAJCQCtStO0eO9CqLTW00mZHZd8jDJJV4V-ir4-OQzd2AfyXWSQ@mail.gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0f17527e-3cee-9423-5a99-3e9af7c61e88@oracle.com>
Date: Mon, 19 Sep 2016 10:25:42 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtStO0eO9CqLTW00mZHZd8jDJJV4V-ir4-OQzd2AfyXWSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Chris Murphy,

  Thanks for writing in detail, it makes sense..

  Generally hot spare is to reduce the risk of double disk failures
  leading to the data lose at the data centers before the data is
  reconstructed again for redundancy.

On 09/19/2016 01:28 AM, Chris Murphy wrote:
> On Sun, Sep 18, 2016 at 2:34 AM, Anand Jain <anand.jain@oracle.com> wrote:
>>
>> (updated the subject, was [1])
>>
>>> IMO the hot-spare feature makes most sense with the raid56,
>>
>>
>>   Why. ?
>
> Raid56 is not scalable, has less redundancy in most all
> configurations, rebuild impacts the entire array performance, and in
> the case of raid6 two drives lost means incredibly slow rebuild. All
> of that adds up to more disk for raid56 to be mitigated with a hot
> spare being available for immediate rebuild.
>
> Who currently would use hot spare right now?

  Probably you mean to say hot spare is not P1 right now, looking at
  other things to fix, I agree.  raid1 availability issue is p1.
  I do get ping-ed on it once in a while.

  I am curious what do you recommend as a btrfs vm data solution for
  the enterprise production ?

Thanks, Anand

> Problem 1 is Btrfs raid10
> is not scalable like other raid10 implementations (mdadm, lvm,
> hardware). Problem 2 is Btrfs the raid56 parity scrub bug; and
> arguably also partial stripe writes not being CoW. I think hot spare
> is pointless with those two problems still being true, and the way to
> mitigate them right now is a clusterfs. Hot spare doesn't mitigate
> these Btrfs weaknesses.
>
>
>>
>>> which is stuck where it is, so we need to get it working first.
>>
>>
>>
>>   We need at least one RAID which does not have the availability
>>   issue. We could achieve that with raid1, there are patches
>>   which needs maintainer time.
>
> I agree with the idea of degraded raid1 chunks. It's a nasty surprise
> to realize this only once it's too late and there's data loss. That
> there is a user space work around, maybe makes it less of a big deal?
> But I don't think it's documented on gotchas page with the soft
> conversion work around to do the rebuild properly: scrub/balance alone
> is not correct.
>
> I kinda think we need a list of priorities for multiple device stuff,
> and honestly hot spare while important I think is bottom of the list.
>
> 1. multiple fs UUID dev UUID corruption problem (the cloned device problem)
> 2. degraded volumes new bg's are single profile (Anand's April patchset)
> 3. raid56 bad parity created during scrub when data strip is bad and gets fixed
> 4. better faulty device tolerance (no crashing)
> 5. raid10 scaling, needs a way for even number block devices of the
> same size to get fixed mirroring so it can tolerate multiple drive
> failures so long as a mirrored pair don't fail
> 6. raid56 partial stripe RMW need to be CoW, doesn't matter if it
> slows things down, if you don't like it, use raid10
> 7. raid1 threaded/async reads (whatever the correct term is to read
> from all raid1 drives rather than PID based)
> 8. better faulty device notifications
> 9. raid56 parity needs to be checksummed
> 10. hotspare
>
>
> 2 and 3 might seem tied. Both can result in data loss, both have user
> space work arounds (undocumented); but 2 has a greater chance of
> happening than 3.
>
> 4 is probably worse than 3, but 4 is much more nebulous and 3 produces
> a big negative perception.
>
> I'm sure someone could argue hotspare could get squeezed in between 4
> and 5; but that's really my one bias in the list, I don't care about
> hot spare. I think it's more scalable to take advantage of Btrfs
> uniqueness to shrink the file system to drop the bad drive to regain
> full redundancy, rather than do hot spares, this is faster, and
> doesn't waste a drive that's not doing any work.
>
> I see shrink as more scalable with hard drives than hot spares,
> especially in the case of data single profile with clusterfs's: drop
> the bad device and its data, autodelete the lost files, rebuild
> metadata to regain complete fs redundancy,  inform the cluster of
> partial data loss - boom the array is completely fixed, let the
> cluster figure out what to do next. Plus each brick isn't spinning an
> unused hot spare. There is in effect a hot spare *somewhere* partially
> used somewhere else in a cluster fs anyway. I see hot spare as an edge
> case need, especially with hard drives. It's not a general purpose
> need.
>
