Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:50679 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbaL0MIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 07:08:39 -0500
Message-ID: <549EA145.8000203@pobox.com>
Date: Sat, 27 Dec 2014 04:08:37 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <4232026.31LFOYpm2s@merkaba> <20141227093043.GJ25267@carfax.org.uk> <2790499.1m3QJ8oJFe@merkaba>
In-Reply-To: <2790499.1m3QJ8oJFe@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 03:11 AM, Martin Steigerwald wrote:
> Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
>>>
>>>
>>> I only see the lockups of BTRFS is the trees *occupy* all space on the
>>> device.
>>     No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metadata
>> space. What's more, balance does *not* balance the metadata trees. The
>> remaining space -- 154.97 GiB -- is unstructured storage for file
>> data, and you have some 13 GiB of that available for use.
>>
>>     Now, since you're seeing lockups when the space on your disks is
>> all allocated I'd say that's a bug. However, you're the *only* person
>> who's reported this as a regular occurrence. Does this happen with all
>> filesystems you have, or just this one?
>
> Okay, just about terms.

Terms are _really_ important if you want to file and discuss bugs.

> What I call trees is this:
>
> merkaba:~> btrfs fi df /
> Data, RAID1: total=27.99GiB, used=17.21GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=596.12MiB
> GlobalReserve, single: total=208.00MiB, used=0.00B
>
> For me each one of "Data", "System", "Metadata" and "GlobalReserve" is what I
> call a "tree".
>
> How would you call it?

Those are "extents" I think. All of the "Trees" are in the metadata. One 
of the trees is the "extent tree". That extent tree is what contains the 
list of which regions of the disk are data, or metadata, or 
system-metadata (like the superblocks), or the global reserve.

Those extents are then filled with the type of information described.

But all the "trees" are in the metadata extents.

>
> I always thought that BTRFS uses a tree structure not only for metadata, but
> also for data. But I bet strictly spoken thats only to *manage* the chunks it
> allocates and what I see above is the actual chunk usage.
>
> I.e. to get terms straight, how would you call it? I think my understanding of
> how BTRFS handles space allocation is quite correct, but I may use a term
> incorrectly.
>
> I read
>
>> Data, RAID1: total=27.99GiB, used=17.21GiB
>
> as:
>
> I reserved 27,99 GiB for data chunks and used 17,21 GiB in these data chunks
> so far. So I have about 10,5 GiB free in these data chunks at the moment and
> all is good.
>
> What it doesn´t tell me at all is how the allocated space is distributed onto
> these chunks. I may be that some chunks are completely empty or not. It may be
> that each chunk has some space allocated to it but in total there is that
> amount of free space yet. I.e. it doesn´t tell me anything about the free
> space fragmentation inside the chunks.
>
> Yet I still hold my theory that in the case of heavily writing to a COW´d file
> BTRFS seems to prefer to reserve new empty chunks on this /home filesystem of
> my laptop instead of trying to find free space in existing only partially empty
> chunks. And the lockup only happens when it tries to do the latter. And no, I
> think it shouldn´t lockup then. I also think its a bug. I never said
> differently.

Partly correct. The system (as I understand it) will try to fill old 
chunks before allocating to new ones. It also perfers the most empty 
chunk first. But if you fallocate large extents they can have trouble 
finding a home. So lets say you have a systemic process that keeps 
making .51GiB files then it will tend to allocate a new 1GiB data extent 
each time (presuming you used default values) because each successive 
.51GiB region cannot fit in any existing data extent.

Excessive snapshotting can also contribute to this effect, but only 
because it freezes the history.

There are some other odd-out cases.

> And yes, I only ever had this on my /home so far. Not on / which is also RAID
> 1 and has all device space reserved for quite some time, not on /daten which
> only holds large files and is single instead of RAID. Also not on the server,
> but the server FS has lots of unallocated device space still, or on the 2 TiB
> eSATA backup HD, also I do get the impression that BTRFS started to get slower
> there as well at least the rsync based backup script takes quite long
> meanwhile and I see rsync reading from backup BTRFS and in this case almost
> fully ultilizing the disk for longer times. But unlike my /home the backup
> disk has some timely widely distributed snaphots (about 2 week to 1 months
> intervalls, and about last half year).
>
> Neither /home nor / on the SSD have snapshots at the moment. So this is
> happening without snapshots.
>
> Ciao,
>

