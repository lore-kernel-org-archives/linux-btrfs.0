Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35113 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbcBAMJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 07:09:08 -0500
Received: by mail-io0-f169.google.com with SMTP id d63so137343140ioj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 04:09:07 -0800 (PST)
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
 <56ABCE58.20705@gmail.com>
 <CAPmG0jbtPfxKH73mo7u8X-GAX2CK4BYP1SWxtM_a4qP4hGK3Lg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AF4AD6.9050300@gmail.com>
Date: Mon, 1 Feb 2016 07:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbtPfxKH73mo7u8X-GAX2CK4BYP1SWxtM_a4qP4hGK3Lg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-29 17:06, Henk Slager wrote:
> On Fri, Jan 29, 2016 at 9:40 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-01-29 15:27, Henk Slager wrote:
>>>
>>> On Fri, Jan 29, 2016 at 1:14 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> On 2016-01-28 18:01, Chris Murphy wrote:
>>>>>
>>>>>
>>>>> On Thu, Jan 28, 2016 at 1:44 PM, Austin S. Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>> Interesting, I figured a umount should include telling the drive to
>>>>>>> flush the write cache; but maybe not, if the drive or connection (i.e.
>>>>>>> USB enclosure) doesn't support FUA?
>>>>>>
>>>>>>
>>>>>>
>>>>>> It's supposed to send an FUA, but depending on the hardware, this may
>>>>>> either
>>>>>> disappear on the way to the disk, or more likely just be a no-op.  A
>>>>>> lot
>>>>>> of
>>>>>> cheap older HDD's just ignore it, and I've seen a lot of USB enclosures
>>>>>> that
>>>>>> just eat the command and don't pass anything to the disk, so sometimes
>>>>>> you
>>>>>> have to get creative to actually flush the cache.  It's worth noting
>>>>>> that
>>>>>> most such disks are not safe to use BTRFS on anyway though, because FUA
>>>>>> is
>>>>>> part of what's used to force write barriers.
>>>>>
>>>>>
>>>>>
>>>>> Err. Really?
>>>>>
>>>>> [    0.833452] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
>>>>> 840  DB6Q PQ: 0 ANSI: 5
>>>>> [    0.835810] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>>>>> filtered out
>>>>> [    0.835827] ata3.00: configured for UDMA/100
>>>>> [    0.838010] usb 1-1: new high-speed USB device number 2 using
>>>>> ehci-pci
>>>>> [    0.839785] sd 0:0:0:0: Attached scsi generic sg0 type 0
>>>>> [    0.839810] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:
>>>>> (250 GB/233 GiB)
>>>>> [    0.840381] sd 0:0:0:0: [sda] Write Protect is off
>>>>> [    0.840393] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>>>> [    0.840634] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>>>>> enabled, doesn't support DPO or FUA
>>>>>
>>>>> This is not a cheap or old HDD. It's not in an enclosure. I get the
>>>>> same message for a new Toshiba 1TiB drive I just stuck in a new Intel
>>>>> NUC. So now what?
>>>>
>>>>
>>>> Well, depending on how the kernel talks to the device, there are ways
>>>> around
>>>> this, but most of them are slow (like waiting for the write cache to
>>>> drain).
>>>> Just like SCT ERC, most drives marketed for 'desktop' usage don't
>>>> actually
>>>> support FUA, but they report this fact correctly, so the kernel can often
>>>> work around it.  Most of the older drives that have issues actually
>>>> report
>>>> that they support it, but just treat it like a no-op.  Last I checked,
>>>> Seagate's 'NAS' drives and whatever they've re-branded their other
>>>> enterprise line as, as well as WD's 'Red' drives support both SCT ERC and
>>>> FUA, but I don't know about any other brands (most of the Hitachi,
>>>> Toshiba,
>>>> and Samsung drives I've seen do not support FUA).  This is in-fact part
>>>> of
>>>> the reason I'm saving up to get good NAS rated drives for my home server,
>>>> because those almost always support both SCT ERC and FUA.
>>>
>>>
>>> [    0.895207] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
>>> enabled, doesn't support DPO or FUA
>>> SCT ERC is supported though.
>>> This is a 4TB (64MB buffer size) WD40EFRX-68WT0N0  FirmWare 82.00A82
>>> and sold as 'NAS' drive.
>>
>> That is at the same time troubling and not all that surprising (
>> SSD's don't implement it so why should we?'  I hate marketing idiocy...).  I
>> was apparently misinformed about WD's disks (although given the apparent
>> insanity of the firmware on some of their drives, that really doesn't
>> surprise me either).
>>>
>>>
>>> How long do you think data will stay dirty in the drives writebuffer
>>> (average/min/max)?
>>
>> That depends on a huge number of factors, and I don't really have a good
>> answer.  The 1TB 7200RPM single platter Seagate drives I'm using right now
>> (which have a 64MB cache) take less than 0.1 second for streaming writes,
>> and less than 0.5 on average for scattered writes, so it's not too bad most
>> of the time, but it's still a performance hit, and I do get marginally
>> better performance by turning off the on-disk write-cache (I've got a very
>> atypical workload though, so YMMV).
>
> I think you refer to the transfer from PC main RAM via SATA to 64MB buffer.
> What I try to estimate is the transfer-time from 64MB buffer to the
> platter(s). Indeed a huge number of factors and without insight in the
> drives ASIC/firmware design, just assumptions, but anyhow I am giving
> it a try:
Ah, I misunderstood what you meant, sorry for the confusion.
>
> - min:  assume complete 64MB dirty and 1 sequential datablock in outer
> cyl, no seek done, then 64 / 150 = ~0.5s
>
> - max:  assume only 1 physical sector sized max scattered (all non
> sequential) datablocks, 150MB/s outer cyl write speed, 75MB/s inner
> cyl write speed, 4ms avg seektime, no merging writes per head
> position, 1 (side) platter, then
>   ( 4k / 150M ) * 8k = ~200ms +
>   ( 4k / 75M ) * 8k = ~400ms +
>    16k * 4ms = ~64s,
>   so in total more than 1 minute in this very simple and worst-case
> model. Drive firmware can't be so inefficient, so seeks are probably
> mostly mitigated, so then it is likely around 1s or a few seconds.
>
> This all would mean that after default 30s commit in btrfs, the
> drive's powersupply must not fail for 0.5s..few seconds.
> If there is powerloss in this timeframe, the fs can get corrupt, but
> AFAIU, there is previous roots, generations etc that can be used, such
> that btrfs fs can restart without mount failure etc, just possibly 30
> + few seconds dataloss.
In theory, that entirely depends on how the drive batches and possibly 
reorders writes in cache.  If things get reordered poorly, then it's 
fully possible to have all your SB's pointing at invalid tree roots. 
The point of FUA as used by most filesystems is to act as a _very_ 
strong write barrier (it's supposed to flush the write-cache, thus 
anything before it can't get reordered after it).
>
> So if those calculations make sense, I am concluding that I am not
> that worried about lack of FUA in normal (non-SMR) spinning drives.
Understandable, the failure modes it's supposed to be protecting against 
are relatively rare, so unless you are working with data that you can't 
afford to need to restore from backup or are using a system that 
absolutely has to come back online without administrative intervention 
after an unclean shutdown, it's usually not needed.
