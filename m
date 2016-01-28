Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33646 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbcA1XBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 18:01:39 -0500
Received: by mail-ig0-f169.google.com with SMTP id z14so24733755igp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 15:01:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AA7D94.4030706@gmail.com>
References: <20160122034538.GA25196@coach.student.rit.edu>
	<pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
	<20160123214127.GA601@fox.wireless.rit.edu>
	<CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
	<20160127224549.GA4891@fox.rh.rit.edu>
	<20160127235528.GA5498@fox.rh.rit.edu>
	<56AA0A0A.1060807@gmail.com>
	<20160128153756.GA19617@fox.rh.rit.edu>
	<CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
	<20160128184736.GB1167@fox.rh.rit.edu>
	<56AA6E17.3060104@gmail.com>
	<CAJCQCtTJ75C2vz0b6v_=qzV304FyhR3q5CdPDqCsRD8U2kspMw@mail.gmail.com>
	<56AA70DC.1000201@gmail.com>
	<CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
	<56AA7D94.4030706@gmail.com>
Date: Thu, 28 Jan 2016 16:01:39 -0700
Message-ID: <CAJCQCtRd70PW6h_peaAmM2UD3xhPW8JX3MMnQK4eH56ybxbfwg@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 1:44 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>> Interesting, I figured a umount should include telling the drive to
>> flush the write cache; but maybe not, if the drive or connection (i.e.
>> USB enclosure) doesn't support FUA?
>
> It's supposed to send an FUA, but depending on the hardware, this may either
> disappear on the way to the disk, or more likely just be a no-op.  A lot of
> cheap older HDD's just ignore it, and I've seen a lot of USB enclosures that
> just eat the command and don't pass anything to the disk, so sometimes you
> have to get creative to actually flush the cache.  It's worth noting that
> most such disks are not safe to use BTRFS on anyway though, because FUA is
> part of what's used to force write barriers.

Err. Really?

[    0.833452] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
840  DB6Q PQ: 0 ANSI: 5
[    0.835810] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    0.835827] ata3.00: configured for UDMA/100
[    0.838010] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.839785] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.839810] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
(250 GB/233 GiB)
[    0.840381] sd 0:0:0:0: [sda] Write Protect is off
[    0.840393] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.840634] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

This is not a cheap or old HDD. It's not in an enclosure. I get the
same message for a new Toshiba 1TiB drive I just stuck in a new Intel
NUC. So now what?


>> If I don't, my drives make a loud clank, and the smart attribute 192
>> Power-off Retract Count, goes up by one. This never happens on a
>> normal power off. So some message is being sent to the drive at
>> restart/poweroff that's different than just pulling the drive, even if
>> that message isn't the same thing as whatever hdparm -Y sends.
>>
> I'm not saying it's a good idea to not tell the drive to spin down, just
> that it won't damage most modern drives as long as they're kept level while
> they spin down and you don't do it all the time.

Gotcha.


>
> Almost every modern hard disk uses a voice-coil actuator for the heads which
> gets balanced such that having no power to the coil causes the forces from
> the spinning disks to park the heads, so pulling power will (more than 99.9%
> of the time) not cause a head cash like a lot of older servo based drives as
> long as you keep the drive level.  The clank you hear is the end of the head
> armature opposite the heads hitting the mechanical stop that's present to
> prevent them from completely decoupling from the disk.  This gets accounted
> in SMART attributes because over extremely long times (usually tens
> thousands of cycles), this will eventually wear out that mechanical stop,
> and things will stop working, so it technically is a failure condition, but
> you're almost certain to hit some other failure condition before this
> becomes an issue.

OK.

>
> The interesting thing is that some drives actually _rely_ on this behavior
> to park the heads (I've seen a lot of Seagate desktop drives that appear to
> do this, although they use a rubber stopper instead of metal or plastic, so
> it tends to last longer).

Cute.

-- 
Chris Murphy
