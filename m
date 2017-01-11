Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:32821 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753361AbdAKUhy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 15:37:54 -0500
Received: by mail-wj0-f194.google.com with SMTP id kp2so92138972wjc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 12:37:53 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Best practices for raid 1
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <CAJCQCtSExodPXzv67PL1ORFyFsQNtyHNB_px8BbEEq+a-6K6+Q@mail.gmail.com>
Date: Wed, 11 Jan 2017 20:37:50 +0000
Cc: Vinko Magecic <vinko.magecic@construction.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <450800E6-A053-48E2-AE08-45B5E5F71E9E@gmail.com>
References: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
 <CAJCQCtSExodPXzv67PL1ORFyFsQNtyHNB_px8BbEEq+a-6K6+Q@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I would like to use this thread to ask few questions: 

If we have 2 devices dying on us and we run RAID6 - this theoretically will still run (despite our current problems). Now let’s say that we booted up raid6 of 10 disk and 2 of them dies but operator does NOT know what are dev ID of disk that died, How does one removes those devices other than using “-missing” ??? I ask because it’s in multiple places stated to use “replace” when your device dies but nobody ever states how to find out which /dev/ node is actually missing  …. so when I want to use a replace, I don’t know what to use within command :/ … This whole thing might have an additional complication - if FS is fool, than one would need to add disks than remove missing. 


> On 10 Jan 2017, at 21:49, Chris Murphy <lists@colorremedies.com> wrote:
> 
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
> 
> 
>> Would that be a `btrfs device add /new/device; btrfs balance start /new/device` ?
> 
> dev add then dev rem; the balance isn't necessary.
> 
>> 
>> 3) When I have the RAID1 with two devices and I want to grow it out, which is the better practice? Create a larger volume, replace the old device with the new device and then do it a second time for the other device, or attaching the new volumes to the label/uuid one at a time and with each one use `btrfs filesystem resize devid:max /mountpoint`.
> 
> If you're replacing a 2x raid1 with two bigger replacements, you'd use
> 'btrfs replace' twice. Maybe it'd work concurrently, I've never tried
> it, but useful for someone to test and see if it explodes because if
> it's allowed, it should work or fail gracefully.
> 
> There's no need to do filesystem resizes when doing either 'replace'
> or 'dev add' followed by 'dev rem' because the fs resize is implied.
> First it's resized/grown with add; and then it's resized/shrink with
> remove. For replace there's a consolidation of steps, it's been a
> while since I've looked at the code so I can't tell you what steps it
> skips, what the state of the devices are in during the replace, which
> one active writes go to.
> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

