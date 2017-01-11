Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32978 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756087AbdAKUHg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 15:07:36 -0500
Received: by mail-it0-f67.google.com with SMTP id c20so267046itb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 12:07:36 -0800 (PST)
Subject: Re: Best practices for raid 1
To: Chris Murphy <lists@colorremedies.com>,
        Vinko Magecic <vinko.magecic@construction.com>
References: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
 <CAJCQCtSExodPXzv67PL1ORFyFsQNtyHNB_px8BbEEq+a-6K6+Q@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <78305370-186d-213b-e85f-8be7ebc14f7d@gmail.com>
Date: Wed, 11 Jan 2017 15:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSExodPXzv67PL1ORFyFsQNtyHNB_px8BbEEq+a-6K6+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-10 16:49, Chris Murphy wrote:
> On Tue, Jan 10, 2017 at 2:07 PM, Vinko Magecic
> <vinko.magecic@construction.com> wrote:
>> Hello,
>>
>> I set up a raid 1 with two btrfs devices and came across some situations in my testing that I can't get a straight answer on.
>>
>> 1) When replacing a volume, do I still need to `umount /path` and then `mount -o degraded ...` the good volume before doing the `btrfs replace start ...` ?
>
> No. If the device being replaced is unreliable, use -r to limit the
> reads from the device being replaced.
>
>
>
>> I didn't see anything that said I had to and when I tested it without mounting the volume it was able to replace the device without any issue. Is that considered bad and could risk damage or has `replace` made it possible to replace devices without umounting the filesystem?
>
> It's always been possible even before 'replace'.
> btrfs dev add <dev3>
> btrfs dev rem <dev1>
>
> But there are some bugs in dev replace that Qu is working on; I think
> they mainly negatively impact raid56 though.
>
> The one limitation of 'replace' is that the new block device must be
> equal to or larger than the block device being replaced; where dev add
>> dev rem doesn't require this.
The other thing to remember is that you can resize the FS on the device 
being replaced so that it will fit on the new device.  I actually 
regularly do this when re-partitioning or moving filesystems between 
devices as a safety precaution so that I can be sure it will fit in the 
new location.  I would only suggest doing this though if that device is 
still reliable, as it may move data around on that device, and it 
obviously doesn't work if the device being replaced is missing.
>
>
>> 2) Everything I see about replacing a drive says to use `/old/device /new/device` but what if the old device can't be read or no longer exists?
>
> The command works whether the device is present or not; but if it's
> present and working then any errors on one device can be corrected by
> the other, whereas if the device is missing, then any errors on the
> remaining device can't be corrected. Off hand I'm not sure if the
> replace continues and an error just logged...I think that's what
> should happen.
IIRC, that's what happens up to some (arbitrary) threshold, at which 
point the replace fails.
>
>
>> Would that be a `btrfs device add /new/device; btrfs balance start /new/device` ?
>
> dev add then dev rem; the balance isn't necessary.
A better way to put it is that the balance is implicit in the removal of 
the device.  The data that was on that device has to go somewhere, and 
the easiest way to do that is just to run a balance that's not allowed 
to allocate anything on the device being removed.
>
>>
>> 3) When I have the RAID1 with two devices and I want to grow it out, which is the better practice? Create a larger volume, replace the old device with the new device and then do it a second time for the other device, or attaching the new volumes to the label/uuid one at a time and with each one use `btrfs filesystem resize devid:max /mountpoint`.
>
> If you're replacing a 2x raid1 with two bigger replacements, you'd use
> 'btrfs replace' twice. Maybe it'd work concurrently, I've never tried
> it, but useful for someone to test and see if it explodes because if
> it's allowed, it should work or fail gracefully.
In theory, it _might_ be possible to get dev replace to work 
concurrently.  As of right now, I know that the current implementation 
does not work with more than one instance running per FS (because it 
uses devid 0 for the new device during the replace, and devids have to 
be unique), but I don't know for certain what it does if you try to run 
another (it _should_ refuse to start, I'm not certain if that's what it 
actually does, and I don't have the time to check right now).

That said, there are many reasons to just serialize replaces most of the 
time, the most notable being that replace does not just read from the 
device being replaced (although most of the reads go to that device), 
and that serializing the replace operations has less impact on the rest 
of the system (it is designed to be used on live systems).
>
> There's no need to do filesystem resizes when doing either 'replace'
> or 'dev add' followed by 'dev rem' because the fs resize is implied.
> First it's resized/grown with add; and then it's resized/shrink with
> remove. For replace there's a consolidation of steps, it's been a
> while since I've looked at the code so I can't tell you what steps it
> skips, what the state of the devices are in during the replace, which
> one active writes go to.
Last time I checked, this was not the case for replace, and a resize to 
max size was still necessary.  That was almost 3 months ago though (I've 
been lucky and not needed to replace anything since then), so I may be 
incorrect about the current state of things.
