Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:41944 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeEMF2D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 May 2018 01:28:03 -0400
Received: by mail-oi0-f43.google.com with SMTP id 11-v6so8004754ois.8
        for <linux-btrfs@vger.kernel.org>; Sat, 12 May 2018 22:28:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSHH_y3FaKn9a0f1kEJXNvYuFgMpW9FQhQLMkTEoHDqMQ@mail.gmail.com>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <1835523.2oRAal5OEW@merkaba> <CA+X5Wn7JP_jsErt5gYOUnur0TReeeqpnF6QU5boNtmhfVeaBGQ@mail.gmail.com>
 <CAJCQCtSHH_y3FaKn9a0f1kEJXNvYuFgMpW9FQhQLMkTEoHDqMQ@mail.gmail.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Sun, 13 May 2018 01:28:02 -0400
Message-ID: <CA+X5Wn5gK9ZMKKXd_fSLJQUzw+NSbumSaJDH0KFf+D7Xy_mH5g@mail.gmail.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

Ahh, OK.  As filefrag shows above, the file is fragmented.  And,
because on disk it seems to me like the first 128k is being compressed
to within a 4k block, I'm thinking compression is being forced here on
nocow as you mentioned.

I'll also mention I'm sometimes seeing the "BTRFS: decompress failed"
crash, but sometimes seeing a "general protection fault", but it's
still only on reading this one file.  Kernel message here:
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
that file from backup, etc.

> You've definitely found a bug. A corrupt file shouldn't crash the
> kernel. You could do regression testing and see if it happens with
> older kernels. I'd probably stick to longterm, easier to find already
> built. If these are zstd compressed, then I think you can only go back
> to 4.14.

I booted my April 1, 2016 Arch ISO.  It also crashes on this file.
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

Glad to do that.  That will confirm the copies are different, and rule
out that one disk went bad on a sector that causes a system crash.  I
did the first fragment of one of the files as a test, and after I get
some guidance, I can do the rest using vim & Excel to make it not as
painful as it looks like it would be.

I'm really confused.

I think I'm seeing a bug in btrfs-map-logical.  It's giving me 4 lines
when I'd expect 2.

And, I think it's showing me the mirrored copies are on disk 2&3.
But, it's only when disk 1 is mounted that it crashes.  Degraded with
disks 2&3 work fine.  Maybe it's disk 2 or 3's data is corrupted, and
which mirror it reads from happens to be different when it's degraded
with 2&3 vs any other way?

First, I can mount degraded with disks 2&3, and xxd the file to see
what its contents should look like.  It starts with ASCII "LPKSHHRH",
which google'ing this shows is how all journal files must start, as
their signature; then it's just binary from there.

I ran "filefrag -v [FILENAME]".

I ran "btrfs-map-logical -l [FILEFRAG'S STARTING PHYSICAL OFFSET
NUMBER * 4096 FOR BLOCKSIZE]".  I'd expect 2 lines of output, but I'm
getting 4 lines!  The first 2 are identical except for mirror number
and device name, and the last 2 are identical except for the same.

I ran "dd if=[BTRFS-MAP-LOGICAL DEVICE NAME] of=/root/[FILENAME] bs=1
count=[FILEFRAG'S LENGTH * 4096 FOR BLOCKSIZE]
skip=[BTRFS-MAP-LOGICAL'S PHYSICAL NUMBER}".  I'd expect these 4 files
(corresponding to each output line of btrfs-map-logical) to be the
first 128K of the file.  (filefrag showing length 32, in size of
blocks of 4096 bytes.)  Well, 2 of these files being that, and maybe 2
of these files being random data since btrfs-map-logical seems like
it's giving 2 invalid output lines.

If I xxd the files and compare them, I see the data from disk 2 and
disk 3 from the first 2 btrfs-map-logical lines (so both at physical
1531469824) do have the LPKSHHRH signature, but starting at offset 9
(so 10th byte).  The 9 bytes before it are "3a0c 0000 6b02 0000 0a".
Googling these 9 bytes (with or without spaces) doesn't pull up
anything.  I don't know if that's a btrfs-lzo compression header
(don't know if there would be one per file, or if it would be per
extent.)

Anyways, after the journal LPKSHHRH signature, there are some areas
that don't match, but some do.  Maybe if lzo compression is happening,
we'd expect to see some bytes match and others not.  Also,
interestingly, at 0x1000 (so 4k in) starts a binary header "ad3c 0000
6807 0000 0f" just before "// Copyright 2013... lest is based on..."
which is another file.  So, the first 128k of the journal file got
compressed to be within 4k (lzop default compression does reduce the
first 128k to 2260 bytes.)

The data from the last 2 btrfs-map-logical lines has the lest
copyright message, so I'm thinking I'd just use the first 2 lines from
each btrfs-map-logical run, and ignore the last 2?  Maybe it's getting
tripped up because of the lzo compression?

And, is there a way to see how large each fragment will be with the
lzo compression, so I know where to read to?




# filefrag -v user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-00053b6b6e65e9cf.journal
Filesystem type is: 9123683e
File size of user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-00053b6b6e65e9cf.journal
is 8388608 (2048 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:     640902..    640933:     32:
encoded,shared
   1:       32..      63:     641026..    641057:     32:     640934:
encoded,shared
   2:       64..      95:     643303..    643334:     32:     641058:
encoded,shared
   3:       96..     127:     643305..    643336:     32:     643335:
encoded,shared
   4:      128..     159:     643418..    643449:     32:     643337:
encoded,shared
   5:      160..     191:     643600..    643631:     32:     643450:
encoded,shared
<email snip>
  58:     1841..    2047:     662141..    662347:    207:    1446616:
last,unwritten,shared,eof
user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-00053b6b6e65e9cf.journal:
59 extents found

# blockdev --getbsz /dev/lvm/newMain1
4096 {matches filefrag saying "blocks of 4096 bytes"}

# echo $[4096*640902]
2625134592

# btrfs-map-logical -l 2625134592 /dev/lvm/newMain1
mirror 1 logical 2625134592 physical 1531469824 device /dev/mapper/lvm-newMain2
mirror 2 logical 2625134592 physical 1531469824 device /dev/mapper/lvm-newMain3
mirror 1 logical 2625138688 physical 1531473920 device /dev/mapper/lvm-newMain2
mirror 2 logical 2625138688 physical 1531473920 device /dev/mapper/lvm-newMain3
