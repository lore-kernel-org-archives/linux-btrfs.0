Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37014 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbcBINEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 08:04:25 -0500
Received: by mail-ig0-f169.google.com with SMTP id 5so11292219igt.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 05:04:24 -0800 (PST)
Subject: Re: "layout" of a six drive raid10
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <1E2010FD-CBFD-44BD-B5DB-9ECD5C009391@bueechi.net>
 <pan$b862$fa78f2fd$bea6373b$99d690b8@cox.net>
 <20160209080258.45339bf0@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B9E37B.4020105@gmail.com>
Date: Tue, 9 Feb 2016 08:02:51 -0500
MIME-Version: 1.0
In-Reply-To: <20160209080258.45339bf0@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-09 02:02, Kai Krakow wrote:
> Am Tue, 9 Feb 2016 01:42:40 +0000 (UTC)
> schrieb Duncan <1i5t5.duncan@cox.net>:
>
>> Tho I'd consider benchmarking or testing, as I'm not sure btrfs raid1
>> on spinning rust will in practice fully saturate the gigabit
>> Ethernet, particularly as it gets fragmented (which COW filesystems
>> such as btrfs tend to do much more so than non-COW, unless you're
>> using something like the autodefrag mount option from the get-go, as
>> I do here, tho in that case, striping won't necessarily help a lot
>> either).
>>
>> If you're concerned about getting the last bit of performance
>> possible, I'd say raid10, tho over the gigabit ethernet, the
>> difference isn't likely to be much.
>
> If performance is an issue, I suggest putting an SSD and bcache into
> the equation. I have very nice performance improvements with that,
> especially with writeback caching (random write go to bcache first,
> then to harddisk in background idle time).
>
> Apparently, afaik it's currently not possible to have native bcache
> redundandancy yet - so bcache can only be one SSD. It may be possible
> to use two bcaches and assign the btrfs members alternating to it - tho
> btrfs may decide to put two mirrors on the same bcache then. On the
> other side, you could put bcache on lvm oder mdraid - but I would not
> do it. On the bcache list, multiple people had problems with that
> including btrfs corruption beyond repair.
>
> On the other hand, you could simply go with bcache writearound caching
> (only reads become cached) or writethrough caching (writes go in
> parallel to bcache and btrfs). If the SSD dies, btrfs will still be
> perfectly safe in this case.
>
> If you are going with one of the latter options, the tuning knobs of
> bcache may help you actually cache not only random accesses to bcache
> but also linear accesses. It should help to saturate a gigabit link.
>
> Currently, SANdisk offers a pretty cheap (not top performance) drive
> with 500GB which should perfectly cover this usecase. Tho, I'm not sure
> how stable this drive works with bcache. I only checked Crucial MX100
> and Samsung Evo 840 yet - both working very stable with latest kernel
> and discard enabled, no mdraid or lvm involved.
>
FWIW, the other option if you want good performance and don't want to 
get an SSD is to run BTRFS in raid1 mode on top of two LVM or MD-RAID 
RAID0 volumes.  I do this regularly for VM's and see a roughly 25-30% 
performance increase compared to BTRFS raid10 for my workloads, and 
that's with things laid out such that each block in BTRFS (16k in my 
case) ends up entirely on one disk in the RAID0 volume (you could 
theoretically get better performance by sizing the stripes on the RAID0 
volume such that a block from BTRFS gets spread across all the disks in 
the volume, but that is marginally less safe than forcing each to one).
