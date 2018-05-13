Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:46820 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeEMLBy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 May 2018 07:01:54 -0400
Received: by mail-ot0-f179.google.com with SMTP id t1-v6so11187892ott.13
        for <linux-btrfs@vger.kernel.org>; Sun, 13 May 2018 04:01:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSHH_y3FaKn9a0f1kEJXNvYuFgMpW9FQhQLMkTEoHDqMQ@mail.gmail.com>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <1835523.2oRAal5OEW@merkaba> <CA+X5Wn7JP_jsErt5gYOUnur0TReeeqpnF6QU5boNtmhfVeaBGQ@mail.gmail.com>
 <CAJCQCtSHH_y3FaKn9a0f1kEJXNvYuFgMpW9FQhQLMkTEoHDqMQ@mail.gmail.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Sun, 13 May 2018 07:01:53 -0400
Message-ID: <CA+X5Wn4KDSWLyGq8pbGaSiZVYhj-z+nt4QCf_-WTufE1GV1jfA@mail.gmail.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*** Disregard previous post.  I read btrfs-map-logical.c, and the
reply below is more sensical than my last. I now understand since I
wasn't specifying a byte size to btrfs-map-logical, it was defaulting
to the nodesize which is 16k.  Filefrag shows the first fragment is
128k, but below I discuss how that's compressed down to less than 4k,
so reading 16k goes into another file and jumps to another logical
area, forcing the extra lines to show the physical locations. ***

(Conversation order changed to put program output at bottom)

On Sat, May 12, 2018 at 10:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, May 12, 2018 at 6:10 PM, james harvey <jamespharvey20@gmail.com> wrote:
>> Does this mean that although I've never had a corrupted disk bit
>> before on COW/checksummed data, one somehow happened on the small
>> fraction of my storage which is NoCOW?  Seems unlikely, but I don't
>> know what other explanation there would be.
>
> Usually nocow also means no compression. But in the archives is a
> thread where I found that compression can be forced on nocow if the
> file is fragment and either the volume is mounted with compression or
> the file has inherited chattr +c (I don't remember which or possibly
> both). And systemd does submit rotated logs for defragmentation.
>
> But the compression doesn't happen twice. So if it's corruption, it's
> corruption in transit. I think you'd come across this more often.

Ahh, OK.  As filefrag shows below, the file is fragmented.  And,
because on disk it seems to me like 128k fragments are being
compressed to less than 4k blocks (lzop is able to compress the
filie's first 128k down to 2k'ish, so this is realistic) I'm thinking
compression is being forced here on nocow as you mentioned it could
be.

I'll also mention I'm sometimes seeing the "BTRFS: decompress failed"
crash, but sometimes seeing a "general protection fault", but it's
still only on reading this one file.  GPF style kernel message here:
https://pastebin.com/SckjTasE

>> So, I think this means the corrupted disk bit must be on disk 1.
>>
>> I'm running with LVM, this a small'ish volume, and I would be happy to
>> leave a copy of the set of 3 volumes as-is, if anyone wanted to have
>> me run anything to help diagnose this and/or try a patch.
>>
>> Does btrfs have a way to do something like scrub, by comparing the
>> mirrored copies of NoCOW data, and alerting you to a mismatch?  I
>> realize with the NoCOW, it wouldn't have a checksum to know which is
>> accurate.  It would at least be good for there to be a way to alert to
>> the corruption.
>
> No csums means the files are ignored.

IMO, it would be a really important feature to add, possibly to scrub,
to compare non-checksummed data across mirrors for differences.
Without a checksum, it couldn't fix anything, but could alert the user
there's a problem.  So, user could determine which is corrupt, restore
that file from backup, just know something is wrong, etc.

> You've definitely found a bug. A corrupt file shouldn't crash the
> kernel. You could do regression testing and see if it happens with
> older kernels. I'd probably stick to longterm, easier to find already
> built. If these are zstd compressed, then I think you can only go back
> to 4.14.

I booted my April 1, 2016, Arch ISO.  It also crashes on this file.
Linux 4.4.5.  I could download older ISOs and try further back if
requested, but I'm thinking this likely means it's not a regression
but always been there.

>> You're right, everything in /var/log/journal has the NoCOW attribute.
>>
>> This is on a 3 device btrfs RAID1.  If I mount ro,degraded with disks
>> 1&2 or 1&3, and read the file, I get a crash.  With disks 2&3, it
>> reads fine
>
> Unmounted with all three available, you can use btrfs-map-logical to
> extract copy 1 and copy 2 to compare; but it might crash also if one
> copy is corrupt. But it's another way to test.

Glad to do that.

I started with "filefrag -v [FILENAME]".  It shows 59 fragments.
Except for the last one, maximum length 32, in units of 4096 byte
blocks.

For each fragment, I ran twice (once for each -c copy):
"btrfs-map-logical -l [FILEFRAG'S STARTING PHYSICAL OFFSET NUMBER *
4096 FOR BLOCKSIZE] -b 4096 -o frag[FRAGMENT NUMBER].[COPY NUMBER] -c
[COPY NUMBER] [FILENAME]".

Fragments [0-27], [29-39], and [56-58] (with 58 being a full 207 4k
blocks) match.

Fragments 28, and [40-55] are completely different.

Why reading 4096 for each fragment?  Well, I tried the first fragment,
and found it has an extra 9 byte header the actual file doesn't have.
("3a0c 0000 6b02 0000 0a".)  I'm assuming that's a btrfs-lzo header.
Then, there's ASCII "LPKSHHRH" which happens to be journald's
beginning of file (starting at byte 0) signature.  After the signature
is different binary data than the actual file for about 2k, then
zeros.  If I run lzop on the first 128k of the file, it winds up
2k'ish.  A larger read from btrfs-map-logical, starting at 0x100 (4k)
is a different file, with its own 9 byte header then "//Copyright
2013... lest is based on..." which is definitely another file.  All of
this put together is telling me these fragments are lzo compressed.

(I realize that although I can see the first 128k fragment compresses
to about 2k, other 128k fragments might compress to more than 4k, so
there might be more differences between the mirrors than I've
discovered.)

btrfs-map-logical isn't crashing, because it appears to be giving data
in its compressed form, so isn't tripping up on invalid compressed
data.
