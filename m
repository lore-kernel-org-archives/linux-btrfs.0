Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35327 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbcA2UmH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 15:42:07 -0500
Received: by mail-io0-f170.google.com with SMTP id d63so84430689ioj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 12:42:06 -0800 (PST)
Subject: Re: RAID1 disk upgrade method
To: Henk Slager <eye1tm@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu>
 <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
 <20160127224549.GA4891@fox.rh.rit.edu> <20160127235528.GA5498@fox.rh.rit.edu>
 <56AA0A0A.1060807@gmail.com> <20160128153756.GA19617@fox.rh.rit.edu>
 <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
 <20160128184736.GB1167@fox.rh.rit.edu> <56AA6E17.3060104@gmail.com>
 <CAJCQCtTJ75C2vz0b6v_=qzV304FyhR3q5CdPDqCsRD8U2kspMw@mail.gmail.com>
 <56AA70DC.1000201@gmail.com>
 <CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
 <56AA7D94.4030706@gmail.com>
 <CAJCQCtRd70PW6h_peaAmM2UD3xhPW8JX3MMnQK4eH56ybxbfwg@mail.gmail.com>
 <56AB57B9.6090801@gmail.com>
 <CAPmG0jbe=errmjH9w94Yjb7sMRbfS3bADBPTEOCB1wmfY-7HhQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56ABCE58.20705@gmail.com>
Date: Fri, 29 Jan 2016 15:40:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbe=errmjH9w94Yjb7sMRbfS3bADBPTEOCB1wmfY-7HhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-29 15:27, Henk Slager wrote:
> On Fri, Jan 29, 2016 at 1:14 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-01-28 18:01, Chris Murphy wrote:
>>>
>>> On Thu, Jan 28, 2016 at 1:44 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>>
>>>>> Interesting, I figured a umount should include telling the drive to
>>>>> flush the write cache; but maybe not, if the drive or connection (i.e.
>>>>> USB enclosure) doesn't support FUA?
>>>>
>>>>
>>>> It's supposed to send an FUA, but depending on the hardware, this may
>>>> either
>>>> disappear on the way to the disk, or more likely just be a no-op.  A lot
>>>> of
>>>> cheap older HDD's just ignore it, and I've seen a lot of USB enclosures
>>>> that
>>>> just eat the command and don't pass anything to the disk, so sometimes
>>>> you
>>>> have to get creative to actually flush the cache.  It's worth noting that
>>>> most such disks are not safe to use BTRFS on anyway though, because FUA
>>>> is
>>>> part of what's used to force write barriers.
>>>
>>>
>>> Err. Really?
>>>
>>> [    0.833452] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
>>> 840  DB6Q PQ: 0 ANSI: 5
>>> [    0.835810] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>>> filtered out
>>> [    0.835827] ata3.00: configured for UDMA/100
>>> [    0.838010] usb 1-1: new high-speed USB device number 2 using ehci-pci
>>> [    0.839785] sd 0:0:0:0: Attached scsi generic sg0 type 0
>>> [    0.839810] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
>>> (250 GB/233 GiB)
>>> [    0.840381] sd 0:0:0:0: [sda] Write Protect is off
>>> [    0.840393] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>> [    0.840634] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>>> enabled, doesn't support DPO or FUA
>>>
>>> This is not a cheap or old HDD. It's not in an enclosure. I get the
>>> same message for a new Toshiba 1TiB drive I just stuck in a new Intel
>>> NUC. So now what?
>>
>> Well, depending on how the kernel talks to the device, there are ways around
>> this, but most of them are slow (like waiting for the write cache to drain).
>> Just like SCT ERC, most drives marketed for 'desktop' usage don't actually
>> support FUA, but they report this fact correctly, so the kernel can often
>> work around it.  Most of the older drives that have issues actually report
>> that they support it, but just treat it like a no-op.  Last I checked,
>> Seagate's 'NAS' drives and whatever they've re-branded their other
>> enterprise line as, as well as WD's 'Red' drives support both SCT ERC and
>> FUA, but I don't know about any other brands (most of the Hitachi, Toshiba,
>> and Samsung drives I've seen do not support FUA).  This is in-fact part of
>> the reason I'm saving up to get good NAS rated drives for my home server,
>> because those almost always support both SCT ERC and FUA.
>
> [    0.895207] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> SCT ERC is supported though.
> This is a 4TB (64MB buffer size) WD40EFRX-68WT0N0  FirmWare 82.00A82
> and sold as 'NAS' drive.
That is at the same time troubling and not all that surprising (
SSD's don't implement it so why should we?'  I hate marketing 
idiocy...).  I was apparently misinformed about WD's disks (although 
given the apparent insanity of the firmware on some of their drives, 
that really doesn't surprise me either).
>
> How long do you think data will stay dirty in the drives writebuffer
> (average/min/max)?
That depends on a huge number of factors, and I don't really have a good 
answer.  The 1TB 7200RPM single platter Seagate drives I'm using right 
now (which have a 64MB cache) take less than 0.1 second for streaming 
writes, and less than 0.5 on average for scattered writes, so it's not 
too bad most of the time, but it's still a performance hit, and I do get 
marginally better performance by turning off the on-disk write-cache 
(I've got a very atypical workload though, so YMMV).
>
> Another thing I noticed, is that with a Seagate 8TB SMR drive (no
> FUA), the drive might be doing internal (re)writes between zones a
> considerable time after OS level 'sync' has finished (I think, you can
> also hear the head movements although no I/O reported on OS level /
> SATA level). I think it is then not just committing its dirty parts of
> the 128MB buffer, that should not take so long. Since then, I am not
> so sure how fast I can shutdown+switchoff the system+drive after e.g.
> btrfs receive has finished. But maybe the rewriting can be interrupted
> and restarted without data corruption, I hope it can, I am just
> guessing.
This really doesn't surprise me, and is a large part of why I will be 
avoiding SMR drives for a long as possible.  The very design means that 
unless you have a battery backed write-cache, you've got serious 
potential to lose data due to unclean shutdowns.  One which is properly 
designed should have no issues with this, but proper design of anything 
these days is becoming the exception, not the rule.

