Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35886 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcGRLXF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 07:23:05 -0400
Received: by mail-io0-f179.google.com with SMTP id b62so156406985iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 04:23:04 -0700 (PDT)
Subject: Re: Status of SMR with BTRFS
To: Hendrik Friedel <hendrik@friedels.name>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
 <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <96008b98-0100-35e5-50b0-43e923c92010@gmail.com>
Date: Mon, 18 Jul 2016 07:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-17 05:08, Hendrik Friedel wrote:
> Hi Thomasz,
>
> @Dave I have added you to the conversation, as I refer to your notes
> (https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt)
>
> thanks for your reply!
>
>>> It's a Seagate Expansion Desktop 5TB (USB3). It is probably a
>>> ST5000DM000.
>>
>> this is TGMR not SMR disk:
>> http://www.seagate.com/www-content/product-content/desktop-hdd-fam/en-us/docs/100743772a.pdf
>>
>> So it still confirms to standard record strategy ...
>
> I am not convinced. I had not heared TGMR before. But I find TGMR as a
> technology for the head.
> https://pics.computerbase.de/4/0/3/4/4/29-1080.455720475.jpg
TGMR is a derivative of giant magneto-resistance, and is what's been 
used in hard disk drives for decades now.  With limited exceptions in 
recent years and in ancient embedded systems, all modern hard drives are 
TGMR based.
> In any case: the drive behaves like a SMR drive: I ran a benchmark on it
> with up to 200MB/s.
> When copying a file onto the drive in parallel the rate in the benchmark
> dropped to 7MB/s, while that particular file was copied at 40MB/s.
This type of performance degradation is actually not unexpected 
depending on the physical location of the files on disk.  Based on the 
numbers you gave, the datasheet for the disk itself, and some basic 
math, I'd guess that the two files ended up on opposite edges of a 
single platter, which means that the head is seeking back and forth 
almost constantly, which is what's killing your performance.
>
>>
>>>> There are two types:
>>>> 1. SMR managed by device firmware. BTRFS sees that as a normal block
>>>> device … problems you get are not related to BTRFS it self …
>>>
>>> That for sure. But the way BTRFS uses/writes data could cause
>>> problems in
>>> conjunction with these devices still, no?
>> I'm sorry but I'm confused now, what "magical way of using/writing
>> data" you actually mean ? AFAIK btrfs sees the disk as a block device
>
> Well, btrfs does write data very different to many other file systems.
> On every write the file is copied to another place, even if just one bit
> is changed. That's special and I am wondering whether that could cause
> problems.
There's two things that should be clarified here:
1. BTRFS only copies part of the file, not the whole file.  At most, it 
copies out a single block, which on reasonably sized filesystems is 16k 
these days.
2. Copy-on-write semantics are not as special as you might think, ZFS is 
also a COW filesystem, as are all log-structured filesystems (NILFS2, 
LogFS, LFS, WAFL, and a couple of others), and a number of filesystems 
support it to some degree (OCFS2, XFS, and even NTFS).
>
>> Now think slowly and thoroughly about it: who would write a code (and
>> maintain it) for a file system that access device specific data for X
>> amount of vendors with each having Y amount of model specific
>> configurations/caveats/firmwares/protocols ... S.M.A.R.T. emerged to
>> give a unifying interface to device statistics ... this is how bad it
>> was ...
>
> Well, I'm no pro. But I found this:
> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
> And this does sound like improvements to BTRFS can be done for SMR in a
> generic, not vendor/device specific manner.
>
> And I am wondering:
> a) whether it is advisable to use BTRFS on these drives before these
> improvements have been made already
>   i) if not: Are there specific btrfs features that should be avoided,
> or btrfs in general?
It's fine to use BTRFS, you just have to give the drive time to finish 
it's internal bookkeeping before you power it off.  The same is true 
with any filesystem, it's just that COW filesystems that aren't log 
structured tend to require a lot more internal bookkeeping on the drive 
than traditional filesystems.  On a typical non-COW filesystem, this 
takes maybe a minute or two depending on the amount of data written.  On 
a log structured filesystem, it may take only 15-30 seconds (log 
structured filesystems are more similar to the internal layout of an SMR 
drive than most other filesystems).  For a COW filesystem like BTRFS, it 
may take 10-30 minutes depending on how much data got moved because of 
the COW semantics.  It's worth pointing out that these numbers are for 
archival usage (write a few big files infrequently), they go up pretty 
steeply for more traditional usage such as for a root filesystem.
> b) whether these improvements have been made already
Not yet.
>
>> care about your data, do some research ... if not ... maybe raiserFS
>> is for you :)
>
> You are right for sure. And that's what I do here. But I am far away
> from being able to judge myself, so I rely on support.
The fact that you're doing research at all is still better than many 
users I see.

