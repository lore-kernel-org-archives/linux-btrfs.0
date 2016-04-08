Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36402 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870AbcDHUQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 16:16:48 -0400
Received: by mail-io0-f172.google.com with SMTP id q128so144822333iof.3
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 13:16:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5708060A.8040105@gmail.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
	<57064231.2070201@gmail.com>
	<CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
	<5707961D.6000803@gmail.com>
	<CAJCQCtQwNDoB75XYdsdcvedbnc1ox3YOi8aaiw0DZ=1Q=21WBw@mail.gmail.com>
	<5707F602.9020504@gmail.com>
	<CAJCQCtSBX1Uk2Ojx0=tePGGO9tdS+6691cM9Gy=K7RK7HAZVoQ@mail.gmail.com>
	<5708060A.8040105@gmail.com>
Date: Fri, 8 Apr 2016 14:16:41 -0600
Message-ID: <CAJCQCtRms_q+d_O-5NQymJRU9da5VVbHAVrdKA7fm7Aez1pLEQ@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 8, 2016 at 1:27 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-08 14:30, Chris Murphy wrote:
>>
>> On Fri, Apr 8, 2016 at 12:18 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2016-04-08 14:05, Chris Murphy wrote:
>>>>
>>>>
>>>> On Fri, Apr 8, 2016 at 5:29 AM, Austin S. Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>>> I entirely agree.  If the fix doesn't require any kind of decision to
>>>>> be
>>>>> made other than whether to fix it or not, it should be trivially
>>>>> fixable
>>>>> with the tools.  TBH though, this particular issue with devices
>>>>> disappearing
>>>>> and reappearing could be fixed easier in the block layer (at least,
>>>>> there
>>>>> are things that need to be fixed WRT it in the block layer).
>>>>
>>>>
>>>>
>>>> Another feature needed for transient failures with large storage, is
>>>> some kind of partial scrub, along the lines of md partial resync when
>>>> there's a bitmap write intent log.
>>>>
>>> In this case, I would think the simplest way to do this would be to have
>>> scrub check if generation matches and not further verify anything that
>>> does
>>> (I think we might be able to prune anything below objects whose
>>> generation
>>> matches, but I'm not 100% certain about how writes cascade up the trees).
>>> I
>>> hadn't really thought about this before, but now that I do, it kind of
>>> surprises me that we don't have something to do this.
>>>
>>
>> And I need to better qualify this: this scrub (or balance) needs to be
>> initiated automatically, perhaps have some reasonable delay after the
>> block layer informs Btrfs the missing device as reappeared. Both the
>> requirement of a full scrub as well as it being a manual scrub, are
>> pretty big gotchas.
>>
> We would still ideally want some way to initiate it manually because:
> 1. It would make it easier to test.
> 2. We should have a way to do it on filesystems that have been reassembled
> after a reboot, not just ones that got the device back in the same boot (or
> it was missing on boot and then appeared).

I'm OK with a mount option, 'autoraidfixup' (not a proposed name!),
that permits the mechanism to happen, but which isn't yet the default.
However, one day I think it should be, because right now we already
allow mounts of devices with different generations and there is no
message indicating this at all, even though the superblocks clearly
show a discrepancy in generation.

mount with one device missing

[264466.609093] BTRFS: has skinny extents
[264912.547199] BTRFS info (device dm-6): disk space caching is enabled
[264912.547267] BTRFS: has skinny extents
[264912.606266] BTRFS: failed to read chunk tree on dm-6
[264912.621829] BTRFS: open_ctree failed

mount -o degraded

[264953.758518] BTRFS info (device dm-6): allowing degraded mounts
[264953.758794] BTRFS info (device dm-6): disk space caching is enabled
[264953.759055] BTRFS: has skinny extents

copy 800MB file
umount
lvchange -ay
mount

[265082.859201] BTRFS info (device dm-6): disk space caching is enabled
[265082.859474] BTRFS: has skinny extents

btrfs scrub start

[265260.024267] BTRFS error (device dm-6): bdev /dev/dm-7 errs: wr 0,
rd 0, flush 0, corrupt 0, gen 1

# btrfs scrub status /mnt/1
scrub status for b01b3922-4012-4de1-af42-63f5b2f68fc3
    scrub started at Fri Apr  8 14:01:41 2016 and finished after 00:00:18
    total bytes scrubbed: 1.70GiB with 1 errors
    error details: super=1
    corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

After scrubbing and fixing everything and zeroing out the counters, if
I fail the device again, I can no longer mount degraded:

[265502.432444] BTRFS: missing devices(1) exceeds the limit(0),
writeable mount is not allowed

because of this nonsense:

[root@f23s ~]# btrfs fi df /mnt/1
Data, RAID1: total=1.00GiB, used=458.06MiB
Data, single: total=1.00GiB, used=824.00MiB
System, RAID1: total=64.00MiB, used=16.00KiB
System, single: total=32.00MiB, used=0.00B
Metadata, RAID1: total=2.00GiB, used=576.00KiB
Metadata, single: total=256.00MiB, used=912.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

a.) the device I'm mounting degraded contains the single chunks, it's
not like the single chunks are actually missing
b.) the manual scrub only fixed the supers, it did not replicate the
newly copied data since it was placed in new single chunks rather than
existing raid1 chunks.
c.) this requires a manual balance convert,soft to actually get
everything back to raid1.

Very non-obvious.

-- 
Chris Murphy
