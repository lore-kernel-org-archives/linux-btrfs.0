Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:32972 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754286AbdAJVtf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 16:49:35 -0500
Received: by mail-yw0-f195.google.com with SMTP id k6so14830715ywk.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 13:49:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
References: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 10 Jan 2017 14:49:34 -0700
Message-ID: <CAJCQCtSExodPXzv67PL1ORFyFsQNtyHNB_px8BbEEq+a-6K6+Q@mail.gmail.com>
Subject: Re: Best practices for raid 1
To: Vinko Magecic <vinko.magecic@construction.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2017 at 2:07 PM, Vinko Magecic
<vinko.magecic@construction.com> wrote:
> Hello,
>
> I set up a raid 1 with two btrfs devices and came across some situations in my testing that I can't get a straight answer on.
>
> 1) When replacing a volume, do I still need to `umount /path` and then `mount -o degraded ...` the good volume before doing the `btrfs replace start ...` ?

No. If the device being replaced is unreliable, use -r to limit the
reads from the device being replaced.



> I didn't see anything that said I had to and when I tested it without mounting the volume it was able to replace the device without any issue. Is that considered bad and could risk damage or has `replace` made it possible to replace devices without umounting the filesystem?

It's always been possible even before 'replace'.
btrfs dev add <dev3>
btrfs dev rem <dev1>

But there are some bugs in dev replace that Qu is working on; I think
they mainly negatively impact raid56 though.

The one limitation of 'replace' is that the new block device must be
equal to or larger than the block device being replaced; where dev add
> dev rem doesn't require this.


> 2) Everything I see about replacing a drive says to use `/old/device /new/device` but what if the old device can't be read or no longer exists?

The command works whether the device is present or not; but if it's
present and working then any errors on one device can be corrected by
the other, whereas if the device is missing, then any errors on the
remaining device can't be corrected. Off hand I'm not sure if the
replace continues and an error just logged...I think that's what
should happen.


>Would that be a `btrfs device add /new/device; btrfs balance start /new/device` ?

dev add then dev rem; the balance isn't necessary.

>
> 3) When I have the RAID1 with two devices and I want to grow it out, which is the better practice? Create a larger volume, replace the old device with the new device and then do it a second time for the other device, or attaching the new volumes to the label/uuid one at a time and with each one use `btrfs filesystem resize devid:max /mountpoint`.

If you're replacing a 2x raid1 with two bigger replacements, you'd use
'btrfs replace' twice. Maybe it'd work concurrently, I've never tried
it, but useful for someone to test and see if it explodes because if
it's allowed, it should work or fail gracefully.

There's no need to do filesystem resizes when doing either 'replace'
or 'dev add' followed by 'dev rem' because the fs resize is implied.
First it's resized/grown with add; and then it's resized/shrink with
remove. For replace there's a consolidation of steps, it's been a
while since I've looked at the code so I can't tell you what steps it
skips, what the state of the devices are in during the replace, which
one active writes go to.


-- 
Chris Murphy
