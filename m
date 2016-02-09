Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34737 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280AbcBINYb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 08:24:31 -0500
Received: by mail-io0-f172.google.com with SMTP id 9so17065651iom.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 05:24:30 -0800 (PST)
Subject: Re: Use fast device only for metadata?
To: Nikolaus Rath <Nikolaus@rath.org>, linux-btrfs@vger.kernel.org
References: <874mdktk4t.fsf@vostro.rath.org>
 <20160207210713.7e4661a8@jupiter.sol.kaishome.de>
 <1507413.RERLDqpHyU@merkaba> <87twliri6m.fsf@thinkpad.rath.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B9E827.2040000@gmail.com>
Date: Tue, 9 Feb 2016 08:22:47 -0500
MIME-Version: 1.0
In-Reply-To: <87twliri6m.fsf@thinkpad.rath.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-08 16:44, Nikolaus Rath wrote:
> On Feb 07 2016, Martin Steigerwald <martin@lichtvoll.de> wrote:
>> Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
>>> Am Sun, 07 Feb 2016 11:06:58 -0800
>>>
>>> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>>>> Hello,
>>>>
>>>> I have a large home directory on a spinning disk that I regularly
>>>> synchronize between different computers using unison. That takes ages,
>>>> even though the amount of changed files is typically small. I suspect
>>>> most if the time is spend walking through the file system and checking
>>>> mtimes.
>>>>
>>>> So I was wondering if I could possibly speed-up this operation by
>>>> storing all btrfs metadata on a fast, SSD drive. It seems that
>>>> mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and the
>>>> file contents in single mode. However, I could not find a way to tell
>>>> btrfs to use a device *only* for metadata. Is there a way to do that?
>>>>
>>>> Also, what is the difference between using "dup" and "raid1" for the
>>>> metadata?
>>>
>>> You may want to try bcache. It will speedup random access which is
>>> probably the main cause for your slow sync. Unfortunately it requires
>>> you to reformat your btrfs partitions to add a bcache superblock. But
>>> it's worth the efforts.
>>>
>>> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+ hours
>>> to typically 1.5-3 depending on how much data changed.
>>
>> An alternative is using dm-cache, I think it doesn´t need to recreate the
>> filesystem.
>
> Yes, I tried that already but it didn't improve things at all. I wrote a
> message to the lvm list though, so maybe someone will be able to help.
That's interesting.  I've been using BTRFS on dm-cache for a while, and 
have seen measurable improvements in performance.  They are not big 
improvements (only about 5% peak), but they're still improvements, which 
is somewhat impressive considering that the backing storage that's being 
cached is a RAID0 set which gets almost the same raw throughput as the 
SSD that's caching it.  Of course, I'm using it more for the power 
savings (SSD's use less power, and I've got a big enough cache I can 
often spin down the traditional disks in the RAID0 set), and I also 
re-tune my system as hardware and workloads change, and my workloads 
tend to be atypical (lots of sequential isochronous writes, regular long 
sequential reads, and some random reads and rewrites), so YMMV.
>
> Otherwise I'll give bcache a shot. I've avoided it so far because of the
> need to reformat and because of rumours that it doesn't work well with
> LVM or BTRFS. But it sounds as if that's not the case..
It should work fine with _just_ BTRFS, but don't put any other layers 
into the storage system like LVM or dmcrypt or mdraid, it's got some 
pretty pathological interactions with the device mapper and md 
frameworks still.
