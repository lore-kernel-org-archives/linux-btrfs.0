Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59232 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaECUw0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 16:52:26 -0400
Received: by mail-qa0-f52.google.com with SMTP id cm18so4534900qab.25
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 13:52:26 -0700 (PDT)
Message-ID: <53655708.8080205@gmail.com>
Date: Sat, 03 May 2014 16:52:24 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Help with space
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <2809235.lZD2oazSeA@xev> <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net> <201405021148.07577.russell@coker.com.au> <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net> <286235B8-24FE-4935-AC13-DB98F1358E32@colorremedies.com> <536519E2.6070807@gmail.com> <4C789231-1BA0-4415-B557-E87A32CCEBFC@colorremedies.com>
In-Reply-To: <4C789231-1BA0-4415-B557-E87A32CCEBFC@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2014 03:09 PM, Chris Murphy wrote:
> 
> On May 3, 2014, at 10:31 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> 
>> On 05/02/2014 03:21 PM, Chris Murphy wrote:
>>>
>>> On May 2, 2014, at 2:23 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>>>
>>>> Something tells me btrfs replace (not device replace, simply
>>>> replace) should be moved to btrfs device replace…
>>>
>>> The syntax for "btrfs device" is different though; replace is like
>>> balance: btrfs balance start and btrfs replace start. And you can
>>> also get a status on it. We don't (yet) have options to stop,
>>> start, resume, which could maybe come in handy for long rebuilds
>>> and a reboot is required (?) although maybe that just gets handled
>>> automatically: set it to pause, then unmount, then reboot, then
>>> mount and resume.
>>>
>>>> Well, I'd say two copies if it's only two devices in the raid1...
>>>> would be true raid1.  But if it's say four devices in the raid1,
>>>> as is certainly possible with btrfs raid1, that if it's not
>>>> mirrored 4-way across all devices, it's not true raid1, but
>>>> rather some sort of hybrid raid,  raid10 (or raid01) if the
>>>> devices are so arranged, raid1+linear if arranged that way, or
>>>> some form that doesn't nicely fall into a well defined raid level
>>>> categorization.
>>>
>>> Well, md raid1 is always n-way. So if you use -n 3 and specify
>>> three devices, you'll get 3-way mirroring (3 mirrors). But I don't
>>> know any hardware raid that works this way. They all seem to be
>>> raid 1 is strictly two devices. At 4 devices it's raid10, and only
>>> in pairs.
>>>
>>> Btrfs raid1 with 3+ devices is unique as far as I can tell. It is
>>> something like raid1 (2 copies) + linear/concat. But that
>>> allocation is round robin. I don't read code but based on how a 3
>>> disk raid1 volume grows VDI files as it's filled it looks like 1GB
>>> chunks are copied like this
>> Actually, MD RAID10 can be configured to work almost the same with an
>> odd number of disks, except it uses (much) smaller chunks, and it does
>> more intelligent striping of reads.
> 
> The efficiency of storage depends on the file system placed on top. Btrfs will allocate space exclusively for metadata, and it's possible much of that space either won't or can't be used. So ext4 or XFS on md probably is more efficient in that regard; but then Btrfs also has compression options so this clouds the efficiency analysis.
> 
> For striping of reads, there is a note in man 4 md about the layout with respect to raid10: "The 'far' arrangement can give sequential read performance equal to that of a RAID0 array, but at the cost of reduced write performance." The default layout for raid10 is near 2. I think either the read performance is a wash with defaults, and md reads are better while writes are worse with the far layout.
> 
> I'm not sure how Btrfs performs reads with multiple devices.
While I haven't tested MD RAID10 specifically, I do know that when used
as a backend for mirrored striping on LVM, it does, by default, get
better read performance than BTRFS (all though the difference is usually
not very significant for most use cases).

As far as how BTRFS preforms reads with multiple devices, it uses the
following algorithm (at least this is my understanding of it, I may be
wrong):
1. Create a 0-indexed list of the devices that the block is stored on.
2. Take the PID of the process that issued the read() call modulo the
number of device that the requested block is stored on, and dispatch the
read to the device with that index in the aforementioned list.
3. If checksum verification fails, then try other devices from the list
in sequential order.

While this algorithm gets relatively good performance for many use
cases, and causes very little overhead in the read path, it is still
sub-optimal in almost all cases, and produces bad results in a few
cases, such as copying very large files, or any other case where only a
single process/thread is reading very large amounts of data.

As far as improving it, dispatching the read to the least recently
accessed device.  Such a strategy would not introduce much more overhead
to the read path ( a few 64-bit compares), and would allow reads to be
striped across devices much more efficiently.  To get much better than
that would require tracking where the last access to each device was,
and dispatching to whichever one was closest.

