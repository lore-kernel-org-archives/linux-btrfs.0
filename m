Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:32951 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdAQMcd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 07:32:33 -0500
Received: by mail-io0-f193.google.com with SMTP id 101so15580367iom.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 04:32:32 -0800 (PST)
Subject: Re: Unocorrectable errors with RAID1
To: Christoph Groth <christoph@grothesque.org>
References: <87o9z7dzvd.fsf@grothesque.org>
 <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com>
 <87fukjdna0.fsf@grothesque.org>
 <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com>
 <87pojmavts.fsf@grothesque.org>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0cedce7a-5641-cbf2-d3d7-f0773fcc14c7@gmail.com>
Date: Tue, 17 Jan 2017 07:32:27 -0500
MIME-Version: 1.0
In-Reply-To: <87pojmavts.fsf@grothesque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-17 04:18, Christoph Groth wrote:
> Austin S. Hemmelgarn wrote:
>
>> There's not really much in the way of great documentation that I know
>> of.  I can however cover the basics here:
>>
>> (...)
>
> Thanks for this explanation.  I'm sure it will be also useful to others.
Glad I could help.
>
>> If the chunk to be allocated was a data chunk, you get -ENOSPC
>> (usually, sometimes you might get other odd results) in the userspace
>> application that triggered the allocation.
>
> It seems that the available space reported by the system df command
> corresponds roughly to the size of the block device minus all the "used"
> space as reported by "btrfs fi df".
That's correct.
>
> If I understand what you wrote correctly this means that when writing a
> huge file it may happen that the system df will report enough free
> space, but btrfs will raise ENOSPC.  However, it should be possible to
> keep writing small files even at this point (assuming that there's
> enough space for the metadata).  Or will btrfs split the huge file into
> small pieces to fit it into the fragmented free space in the chunks?
OK, so the first bit to understanding this is that an extent in a file 
can't be larger than a chunk.  This means that if you have space for 3 
1GB data chunks located in 3 different places on the storage device, you 
can still write a 3GB file to the filesystem, it will just end up with 3 
1GB extents.  The issues with ENOSPC come in when almost all of your 
space is allocated to chunks and one type gets full.  In such a 
situation, if you have metadata space, you can keep writing to the FS, 
but big writes may fail, and you'll eventually end up in a situation 
where you need to delete things to free up space.
>
> Such a situation should be avoided of course.  I'm asking out of curiosity.
>
>>>>> * So scrubbing is not enough to check the health of a btrfs file
>>>>> system?  It’s also necessary to read all the files?
>>>
>>>> Scrubbing checks data integrity, but not the state of the data. IOW,
>>>> you're checking that the data and metadata match with the checksums,
>>>> but not necessarily that the filesystem itself is valid.
>>>
>>> I see, but what should one then do to detect problems such as mine as
>>> soon as possible?  Periodically calculate hashes for all files? I’ve
>>> never seen a recommendation to do that for btrfs.
>
>> Scrub will verify that the data is the same as when the kernel
>> calculated the block checksum.  That's really the best that can be
>> done. In your case, it couldn't correct the errors because both copies
>> of the corrupted blocks were bad (this points at an issue with either
>> RAM or the storage controller BTW, not the disks themselves).  Had one
>> of the copies been valid, it would have intelligently detected which
>> one was bad and fixed things.
>
> I think I understand the problem with the three corrupted blocks that I
> was able to fix by replacing the files.
>
> But there is also the strange "Stale file handle" error with some other
> files that was not found by scrubbing, and also does not seem to appear
> in the output of "btrfs dev stats", which is BTW
>
> [/dev/sda2].write_io_errs   0
> [/dev/sda2].read_io_errs    0
> [/dev/sda2].flush_io_errs   0
> [/dev/sda2].corruption_errs 3
> [/dev/sda2].generation_errs 0
> [/dev/sdb2].write_io_errs   0
> [/dev/sdb2].read_io_errs    0
> [/dev/sdb2].flush_io_errs   0
> [/dev/sdb2].corruption_errs 3
> [/dev/sdb2].generation_errs 0
>
> (The 2 times 3 corruption errors seem to be the uncorrectable errors
> that I could fix by replacing the files.)
Yep, those correspond directly to the uncorrectable errors you mentioned 
in your original post.
>
> To get the "stale file handle" error I need to try to read the affected
> file.  That's why I was wondering whether reading all the files
> periodically is indeed a useful maintenance procedure with btrfs.
In the cases I've seen, no it isn't all that useful.  As far as the 
whole ESTALE thing, that's almost certainly a bug and you either 
shouldn't be getting an error there, or you shouldn't be getting that 
error code there.
>
> "btrfs check" does find the problem, but it can be only run on an
> unmounted file system.

