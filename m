Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:36531 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbeEMCJh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 May 2018 22:09:37 -0400
Received: by mail-ot0-f182.google.com with SMTP id m11-v6so10562276otf.3
        for <linux-btrfs@vger.kernel.org>; Sat, 12 May 2018 19:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7JP_jsErt5gYOUnur0TReeeqpnF6QU5boNtmhfVeaBGQ@mail.gmail.com>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <1835523.2oRAal5OEW@merkaba> <CA+X5Wn7JP_jsErt5gYOUnur0TReeeqpnF6QU5boNtmhfVeaBGQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 12 May 2018 20:09:36 -0600
Message-ID: <CAJCQCtSHH_y3FaKn9a0f1kEJXNvYuFgMpW9FQhQLMkTEoHDqMQ@mail.gmail.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 12, 2018 at 6:10 PM, james harvey <jamespharvey20@gmail.com> wrote:
> On Sat, May 12, 2018 at 3:51 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
>> Hey James.
>>
>> james harvey - 12.05.18, 07:08:
>>> 100% reproducible, booting from disk, or even Arch installation ISO.
>>> Kernel 4.16.7.  btrfs-progs v4.16.
>>>
>>> Reading one of two journalctl files causes a kernel oops.  Initially
>>> ran into it from "journalctl --list-boots", but cat'ing the file does
>>> it too.  I believe this shows there's compressed data that is invalid,
>>> but its btrfs checksum is invalid.  I've cat'ed every file on the
>>> disk, and luckily have the problems narrowed down to only these 2
>>> files in /var/log/journal.
>>>
>>> This volume has always been mounted with lzo compression.
>>>
>>> scrub has never found anything, and have ran it since the oops.
>>>
>>> Found a user a few years ago who also ran into this, without
>>> resolution, at:
>>> https://www.spinics.net/lists/linux-btrfs/msg52218.html
>>>
>>> 1. Cat'ing a (non-essential) file shouldn't be able to bring down the
>>> system.
>>>
>>> 2. If this is infact invalid compressed data, there should be a way to
>>> check for that.  Btrfs check and scrub pass.
>>
>> I think systemd-journald sets those files to nocow on BTRFS in order to
>> reduce fragmentation: That means no checksums, no snapshots, no nothing.
>> I just removed /var/log/journal and thus disabled journalling to disk.
>> Its sufficient for me to have the recent state in /run/journal.
>>
>> Can you confirm nocow being set via lsattr on those files?
>>
>> Still they should be decompressible just fine.
>>
>>> Hardware is fine.  Passes memtest86+ in SMP mode.  Works fine on all
>>> other files.
>>>
>>>
>>>
>>> [  381.869940] BUG: unable to handle kernel paging request at
>>> 0000000000390e50 [  381.870881] BTRFS: decompress failed
>> […]
>> --
>> Martin
>>
>>
>
> You're right, everything in /var/log/journal has the NoCOW attribute.
>
> This is on a 3 device btrfs RAID1.  If I mount ro,degraded with disks
> 1&2 or 1&3, and read the file, I get a crash.  With disks 2&3, it
> reads fine

Unmounted with all three available, you can use btrfs-map-logical to
extract copy 1 and copy 2 to compare; but it might crash also if one
copy is corrupt. But it's another way to test.


>
> Does this mean that although I've never had a corrupted disk bit
> before on COW/checksummed data, one somehow happened on the small
> fraction of my storage which is NoCOW?  Seems unlikely, but I don't
> know what other explanation there would be.

Usually nocow also means no compression. But in the archives is a
thread where I found that compression can be forced on nocow if the
file is fragment and either the volume is mounted with compression or
the file has inherited chattr +c (I don't remember which or possibly
both). And systemd does submit rotated logs for defragmentation.

But the compression doesn't happen twice. So if it's corruption, it's
corruption in transit. I think you'd come across this more often.


>
> So, I think this means the corrupted disk bit must be on disk 1.
>
> I'm running with LVM, this a small'ish volume, and I would be happy to
> leave a copy of the set of 3 volumes as-is, if anyone wanted to have
> me run anything to help diagnose this and/or try a patch.
>
> Does btrfs have a way to do something like scrub, by comparing the
> mirrored copies of NoCOW data, and alerting you to a mismatch?  I
> realize with the NoCOW, it wouldn't have a checksum to know which is
> accurate.  It would at least be good for there to be a way to alert to
> the corruption.

No csums means the files are ignored.

You've definitely found a bug. A corrupt file shouldn't crash the
kernel. You could do regression testing and see if it happens with
older kernels. I'd probably stick to longterm, easier to find already
built. If these are zstd compressed, then I think you can only go back
to 4.14.


-- 
Chris Murphy
