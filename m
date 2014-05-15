Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-lucinda.wadns.net ([196.220.39.179]:51654 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752164AbaEOQPX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 12:15:23 -0400
Message-ID: <5374E80B.2070604@swiftspirit.co.za>
Date: Thu, 15 May 2014 18:15:07 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: russell@coker.com.au, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: staggered stripes
References: <2751140.Zb1qMBeNgk@xev> <pan$a10c6$96b782de$86a74a2f$b7f37af@cox.net> <4172915.as80o3hoBa@xev>
In-Reply-To: <4172915.as80o3hoBa@xev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/15 04:38 PM, Russell Coker wrote:
> On Thu, 15 May 2014 09:31:42 Duncan wrote:
>>> Does the BTRFS RAID functionality do such staggered stripes?  If not
>>> could it be added?
>> AFAIK nothing like that yet, but it's reasonably likely to be implemented
>> later.  N-way-mirroring is roadmapped for next up after raid56
>> completion, however.
> It's RAID-5/6 when we really need such staggering.  It's a reasonably common
> configuration choice to use two different brands of disk for a RAID-1 array.
> As the correlation between parts of the disks with errors only applied to
> disks of the same make and model (and this is expected due to
> firmware/manufacturing issues) the people who care about such things on RAID-1
> have probably already dealt with the issue.
>
>> You do mention the partition alternative, but not as I'd do it for such a
>> case.  Instead of doing a different sized buffer partition (or using the
>> mkfs.btrfs option to start at some offset into the device) on each
>> device, I'd simply do multiple partitions and reorder them on each
>> device.
> If there are multiple partitions on a device then that will probably make
> performance suck.  Also does BTRFS even allow special treatment of them or
> will it put two copies from a RAID-10 on the same disk?

I suspect the approach is similar to the following:
sd[abcd][1234....] each configured as LVM PVs
sda[1234....] as an LVM VG
sdb[2345....] as an LVM VG
sdc[3456....] as an LVM VG
sdd[4567....] as an LVM VG
btrfs across all four VGs

^ Um - the above is ignoring "DOS"-style partition limitations
>> Tho N-way-mirroring would sure help here too, since if a given
>> area around the same address is assumed to be weak on each device, I'd
>> sure like greater than the current 2-way-mirroring, even if if I had a
>> different filesystem/partition at that spot on each one, since with only
>> two-way-mirroring if one copy is assumed to be weak, guess what, you're
>> down to only one reasonably reliable copy now, and that's not a good spot
>> to be in if that one copy happens to be hit by a cosmic ray or otherwise
>> fail checksum, without another reliable copy to fix it since that other
>> copy is in the weak area already.
>>
>> Another alternative would be using something like mdraid's raid10 "far"
>> layout, with btrfs on top of that...
> In the "copies= option" thread Brendan Hide stated that this sort of thing is
> planned.
>

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

