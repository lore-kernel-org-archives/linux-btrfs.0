Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38559 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbaGWFYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 01:24:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X9p2V-0007RG-96
	for linux-btrfs@vger.kernel.org; Wed, 23 Jul 2014 07:24:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 07:24:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 07:24:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG] bogus out of space reported when mounted raid1 degraded
Date: Wed, 23 Jul 2014 05:24:18 +0000 (UTC)
Message-ID: <pan$83a22$939c719d$63069ee2$976101e3@cox.net>
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
	<BEB1C719-6B2A-46DC-9CBA-A22F53C6407C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 22 Jul 2014 20:36:55 -0600 as excerpted:

> On Jul 22, 2014, at 7:34 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
> 
>> BUG 1: The df command is clearly bogus six ways to Sunday. It's a 12.58
>> GiB partition, only 6.78GiB used, thus 5.8GiB free, yet df and
>> apparently gvfs think it's full, maybe systemd too because the journal
>> wigged out and stopped logging events while also kept stopping and
>> starting. So whatever changes occurred to clean up the df reporting,
>> are very problematic at best when mounting degraded.
> 
> Used strace on df, think I found the problem so I put it all into a bug.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=80951

Suggestion for improved bug summary/title:

Current:  df reports bogus filesystem usage when mounted degraded

Problems: While it's product file system and component btrfs...
1) the summary doesn't mention btrfs, and 
2) there's some ambiguity as to whether it's normal or btrfs df.

Proposed improved summaries/titles:

#1: (Non-btrfs) df reports bogus btrfs usage with degraded mount.

#2: With degraded btrfs mount, (non-btrfs) df reports bogus usage.


Meanwhile, to the problem at hand...

There are two root issues here:

The first is a variant of something already discussed in the FAQ and 
reasonably well known on the list: (non-btrfs) df is simply not accurate 
in many cases on a multi-device btrfs, because a multi-device btrfs 
breaks all the old rules and assumptions upon which it bases its 
reporting.  There has been some debate about how it should work, but the 
basic problem is that there's no way to present all the information 
necessary to get a proper picture of the situation while continuing to 
keep output format backward compatibility in ordered to prevent breaking 
the various scripts etc that depend on the existing format.

The best way forward seems to be some sort of at best half-broken 
compromise regarding legacy df output, maintaining backward output format 
compatibility and at least not breaking too badly in the legacy-
assumption single-device filesystem case, but not really working so well 
in all the various multi-device btrfs cases, because the output format is 
simply too constrained to present the necessary information properly.  
With some work, it should be possible to make at least the most common 
multi-device btrfs cases not /entirely/ broken as well, altho the old 
assumptions constrain output format such that there will always be corner-
cases that don't present well -- for these legacy df is just that, 
legacy, and a more appropriate tool is needed.

And a two-device btrfs raid1 mounted degraded with one device missing is 
just such a corner-case, at least presently.  Given the second root issue 
below, however, IMO the existing presentation was as accurate as could be 
expected under the circumstances.

The second half of the solution (still to root issue #1), then, is 
providing a more appropriate btrfs specific tool free of these legacy 
assumptions and output format constraints.  Currently, the solution there 
actually ships as two different reports which must be taken together to 
get a proper picture of the situation, currently with some additional 
interpretation required as well.  Of course I'm talking about btrfs 
filesystem show along with btrfs filesystem df.  

The biggest catch here is that "additional interpretation required" bit.  
There's a bit of it required in normal operation, but for the degraded-
mount case knowledge of root-issue #2 below is required for proper 
interpretation as well.


Which brings us to root-issue #2:

With btrfs raid1 the chunk-allocator policy forces allocation in pairs, 
with each chunk of the pair forced to a different device.

Since the btrfs in question is raid1 (both data and metadata) with two 
devices when undegraded, loss of a single device and degraded-mount means 
the above chunk allocation policy cannot succeed as there's no second 
device available to write the mirror-chunk to.

Note that the situation with a two-device raid1 but with one missing is 
rather different than with a three-device raid1 with one missing, as in 
the latter case and assuming there's still unallocated space left on all 
devices, a pair-chunk-allocation could still succeed, since it could 
still allocate one chunk-mirror on each of the two remaining devices.

The critical bit to understand here is that (AFAIK), degraded-mount does 
*NOT* trigger a chunk-allocation-policy waiver, which means that with a 
two-device btrfs raid1 with a device-missing, no additional chunks can be 
allocated as the pair-chunks-at-a-time-allocated-on-different-devices 
policy cannot be filled.

(Pardon my yelling, but this is the critical bit...)

** ON BTRFS RAID1, TWO DEVICES MUST BE PRESENT IN ORDERED TO ALLOCATE NEW 
CHUNKS.  MOUNTING DEGRADED WITH A SINGLE DEVICE MEANS NO NEW CHUNK 
ALLOCATION, WHICH MEANS YOU'RE LIMITED TO FILLING UP EXISTING CHUNKS **


Conclusions in light of the above, particularly root-issue #2:

Let's take another look at your btrfs fi df and btrfs fi show output from 
earlier in the thread:

>> # btrfs fi df
>> Data, RAID1: total=6.00GiB, used=5.99GiB
>> System, RAID1: total=32.00MiB, used=32.00KiB
>> Metadata, RAID1: total=768.00MiB, used=412.41MiB
>> unknown, single: total=160.00MiB, used=0.00
>> 
>> # btrfs fi show
>> Label: 'Rawhide2'  uuid: f857c336-b8f5-4f5d-9500-a705ee1b6977
>> 	Total devices 2 FS bytes used 6.39GiB
>> 	devid    1 size 12.58GiB used 6.78GiB path /dev/sda6
>> 	*** Some devices missing

Facts:

1) btrfs fi show says only a single device, tho it does have nearly 6 GiB 
of unallocated space left.

2) btrfs fi df says data is raid1, 5.99 GiB used, 6.00 GiB allocated.

3) 0.01 GiB free in the existing data allocation.

4) Can't allocate more since there's only a single device and the
raid1 data allocation policy requires two devices.

See the problem?

Under those circumstances, your (non-btrfs) df output...

>> # df -h
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/sda6        26G   13G   20M 100% /

... is as accurate as could be expected under the definitely NOT routine, 
definitely rather corner-case due to degraded-mount, no further chunk 
allocation possible with current raid1 policy, circumstances.

Indeed, 20 M available is perhaps a bit more than the 0.01 GiB btrfs fi df 
is indicating, altho rounded to hundredths of a GiB, that's within 
acceptable rounding error.


Of course as reported in a different followup and as might be expected, 
with a rebalance -dconvert=single -mconvert=single, that pair-allocation-
policy gets converted to a single allocation policy, and you can again 
allocate additional chunks from that available nearly 6 GiB unallocated 
according to btrfs fi show.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

