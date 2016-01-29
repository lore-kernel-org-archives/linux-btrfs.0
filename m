Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35744 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbcA2U1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 15:27:07 -0500
Received: by mail-lf0-f47.google.com with SMTP id c192so54164993lfe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 12:27:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AB57B9.6090801@gmail.com>
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
	<CAJCQCtRd70PW6h_peaAmM2UD3xhPW8JX3MMnQK4eH56ybxbfwg@mail.gmail.com>
	<56AB57B9.6090801@gmail.com>
Date: Fri, 29 Jan 2016 21:27:04 +0100
Message-ID: <CAPmG0jbe=errmjH9w94Yjb7sMRbfS3bADBPTEOCB1wmfY-7HhQ@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Henk Slager <eye1tm@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 1:14 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-01-28 18:01, Chris Murphy wrote:
>>
>> On Thu, Jan 28, 2016 at 1:44 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> Interesting, I figured a umount should include telling the drive to
>>>> flush the write cache; but maybe not, if the drive or connection (i.e.
>>>> USB enclosure) doesn't support FUA?
>>>
>>>
>>> It's supposed to send an FUA, but depending on the hardware, this may
>>> either
>>> disappear on the way to the disk, or more likely just be a no-op.  A lot
>>> of
>>> cheap older HDD's just ignore it, and I've seen a lot of USB enclosures
>>> that
>>> just eat the command and don't pass anything to the disk, so sometimes
>>> you
>>> have to get creative to actually flush the cache.  It's worth noting that
>>> most such disks are not safe to use BTRFS on anyway though, because FUA
>>> is
>>> part of what's used to force write barriers.
>>
>>
>> Err. Really?
>>
>> [    0.833452] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
>> 840  DB6Q PQ: 0 ANSI: 5
>> [    0.835810] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>> filtered out
>> [    0.835827] ata3.00: configured for UDMA/100
>> [    0.838010] usb 1-1: new high-speed USB device number 2 using ehci-pci
>> [    0.839785] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [    0.839810] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
>> (250 GB/233 GiB)
>> [    0.840381] sd 0:0:0:0: [sda] Write Protect is off
>> [    0.840393] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    0.840634] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>>
>> This is not a cheap or old HDD. It's not in an enclosure. I get the
>> same message for a new Toshiba 1TiB drive I just stuck in a new Intel
>> NUC. So now what?
>
> Well, depending on how the kernel talks to the device, there are ways around
> this, but most of them are slow (like waiting for the write cache to drain).
> Just like SCT ERC, most drives marketed for 'desktop' usage don't actually
> support FUA, but they report this fact correctly, so the kernel can often
> work around it.  Most of the older drives that have issues actually report
> that they support it, but just treat it like a no-op.  Last I checked,
> Seagate's 'NAS' drives and whatever they've re-branded their other
> enterprise line as, as well as WD's 'Red' drives support both SCT ERC and
> FUA, but I don't know about any other brands (most of the Hitachi, Toshiba,
> and Samsung drives I've seen do not support FUA).  This is in-fact part of
> the reason I'm saving up to get good NAS rated drives for my home server,
> because those almost always support both SCT ERC and FUA.

[    0.895207] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
SCT ERC is supported though.
This is a 4TB (64MB buffer size) WD40EFRX-68WT0N0  FirmWare 82.00A82
and sold as 'NAS' drive.

How long do you think data will stay dirty in the drives writebuffer
(average/min/max)?

Another thing I noticed, is that with a Seagate 8TB SMR drive (no
FUA), the drive might be doing internal (re)writes between zones a
considerable time after OS level 'sync' has finished (I think, you can
also hear the head movements although no I/O reported on OS level /
SATA level). I think it is then not just committing its dirty parts of
the 128MB buffer, that should not take so long. Since then, I am not
so sure how fast I can shutdown+switchoff the system+drive after e.g.
btrfs receive has finished. But maybe the rewriting can be interrupted
and restarted without data corruption, I hope it can, I am just
guessing.

> That said, you may want to test the performance difference with the write
> cache disabled, depending on how the kernel is trying to emulate write
> barriers, it may actually speed things up.
>
>>
>>
>>>> If I don't, my drives make a loud clank, and the smart attribute 192
>>>> Power-off Retract Count, goes up by one. This never happens on a
>>>> normal power off. So some message is being sent to the drive at
>>>> restart/poweroff that's different than just pulling the drive, even if
>>>> that message isn't the same thing as whatever hdparm -Y sends.
>>>>
>>> I'm not saying it's a good idea to not tell the drive to spin down, just
>>> that it won't damage most modern drives as long as they're kept level
>>> while
>>> they spin down and you don't do it all the time.
>>
>>
>> Gotcha.
>>
>>
>>>
>>> Almost every modern hard disk uses a voice-coil actuator for the heads
>>> which
>>> gets balanced such that having no power to the coil causes the forces
>>> from
>>> the spinning disks to park the heads, so pulling power will (more than
>>> 99.9%
>>> of the time) not cause a head cash like a lot of older servo based drives
>>> as
>>> long as you keep the drive level.  The clank you hear is the end of the
>>> head
>>> armature opposite the heads hitting the mechanical stop that's present to
>>> prevent them from completely decoupling from the disk.  This gets
>>> accounted
>>> in SMART attributes because over extremely long times (usually tens
>>> thousands of cycles), this will eventually wear out that mechanical stop,
>>> and things will stop working, so it technically is a failure condition,
>>> but
>>> you're almost certain to hit some other failure condition before this
>>> becomes an issue.
>>
>>
>> OK.
>>
>>>
>>> The interesting thing is that some drives actually _rely_ on this
>>> behavior
>>> to park the heads (I've seen a lot of Seagate desktop drives that appear
>>> to
>>> do this, although they use a rubber stopper instead of metal or plastic,
>>> so
>>> it tends to last longer).
>>
>>
>> Cute.
>>
> Yeah, I've used a lot of Seagate drives that appear to do this, and they've
> always failed in some way other than this failing.  It is kind of nice
> though that it means you get clearly audible confirmation that the drive has
> spun down.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
