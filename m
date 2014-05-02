Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48193 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752696AbaEBWdL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 18:33:11 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140502210835.GC24298@carfax.org.uk>
Date: Fri, 2 May 2014 16:33:09 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C7275FFE-6EB0-4A85-B4AE-583C1D1D5BE3@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <2809235.lZD2oazSeA@xev> <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net> <201405021148.07577.russell@coker.com.au> <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net> <286235B8-24FE-4935-AC13-DB98F1358E32@colorremedies.com> <20140502210835.GC24298@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 2, 2014, at 3:08 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Fri, May 02, 2014 at 01:21:50PM -0600, Chris Murphy wrote:
>> 
>> On May 2, 2014, at 2:23 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> 
>>> Something tells me btrfs replace (not device replace, simply replace) 
>>> should be moved to btrfs device replace…
>> 
>> The syntax for "btrfs device" is different though; replace is like balance: btrfs balance start and btrfs replace start. And you can also get a status on it. We don't (yet) have options to stop, start, resume, which could maybe come in handy for long rebuilds and a reboot is required (?) although maybe that just gets handled automatically: set it to pause, then unmount, then reboot, then mount and resume.
>> 
>>> Well, I'd say two copies if it's only two devices in the raid1... would 
>>> be true raid1.  But if it's say four devices in the raid1, as is 
>>> certainly possible with btrfs raid1, that if it's not mirrored 4-way 
>>> across all devices, it's not true raid1, but rather some sort of hybrid 
>>> raid,  raid10 (or raid01) if the devices are so arranged, raid1+linear if 
>>> arranged that way, or some form that doesn't nicely fall into a well 
>>> defined raid level categorization.
>> 
>> Well, md raid1 is always n-way. So if you use -n 3 and specify three devices, you'll get 3-way mirroring (3 mirrors). But I don't know any hardware raid that works this way. They all seem to be raid 1 is strictly two devices. At 4 devices it's raid10, and only in pairs.
>> 
>> Btrfs raid1 with 3+ devices is unique as far as I can tell. It is something like raid1 (2 copies) + linear/concat. But that allocation is round robin. I don't read code but based on how a 3 disk raid1 volume grows VDI files as it's filled it looks like 1GB chunks are copied like this
>> 
>> Disk1	Disk2	Disk3
>> 134		124		235
>> 679		578		689
>> 
>> So 1 through 9 each represent a 1GB chunk. Disk 1 and 2 each have a chunk 1; disk 2 and 3 each have a chunk 2, and so on. Total of 9GB of data taking up 18GB of space, 6GB on each drive. You can't do this with any other raid1 as far as I know. You do definitely run out of space on one disk first though because of uneven metadata to data chunk allocation.
> 
>   The algorithm is that when the chunk allocator is asked for a block
> group (in pairs of chunks for RAID-1), it picks the number of chunks
> it needs, from different devices, in order of the device with the most
> free space. So, with disks of size 8, 4, 4, you get:
> 
> Disk 1: 12345678
> Disk 2: 1357
> Disk 3: 2468
> 
> and with 8, 8, 4, you get:
> 
> Disk 1: 1234568A
> Disk 2: 1234579A
> Disk 3: 6789

Sure in my example I was assuming equal size disks. But it's a good example to have uneven disks also, because it exemplifies all the more the flexibility btrfs replication has, over alternatives, with odd numbered *and* uneven size disks.


Chris Murphy

