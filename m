Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34454 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161146AbcA1UpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 15:45:16 -0500
Received: by mail-ig0-f173.google.com with SMTP id ik10so22344222igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 12:45:16 -0800 (PST)
Subject: Re: RAID1 disk upgrade method
To: Chris Murphy <lists@colorremedies.com>
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
Cc: Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AA7D94.4030706@gmail.com>
Date: Thu, 28 Jan 2016 15:44:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-28 15:24, Chris Murphy wrote:
> On Thu, Jan 28, 2016 at 12:49 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-01-28 14:46, Chris Murphy wrote:
>>>
>>> On Thu, Jan 28, 2016 at 12:37 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> On 2016-01-28 13:47, Sean Greenslade wrote:
>>>>>
>>>>>
>>>>> On Thu, Jan 28, 2016 at 09:18:06AM -0700, Chris Murphy wrote:
>>>>>>
>>>>>>
>>>>>> Those read errors are a persistent counter. Use 'btrfs dev stat' to
>>>>>> see them for each device, and use -z to clear. I think this is in
>>>>>> DEV_ITEM, and it should be dev.uuid based, so the counter ought to be
>>>>>> with this specific device, not merely "sda1". So ... I'd look in the
>>>>>> journal for the time during the replace and see where those read
>>>>>> errors might have come from if this is supposed to be a new drive and
>>>>>> you're not expecting read errors already.
>>>>>>
>>>>>> Like I mentioned in my first reply to this thread, sct erc... it's
>>>>>> very important to get these settings right.
>>>>>
>>>>>
>>>>>
>>>>> I don't see anything that indicates read errors in my journal or dmesg,
>>>>> though it's hard to tell given the rather scary-looking messages I get
>>>>> whenever I eject a drive:
>>>>>
>>>>> [Thu Jan 28 10:38:10 2016] ata6.00: exception Emask 0x10 SAct 0x8 SErr
>>>>> 0x280100 action 0x6 frozen
>>>>> [Thu Jan 28 10:38:10 2016] ata6.00: irq_stat 0x08000000, interface fatal
>>>>> error
>>>>> [Thu Jan 28 10:38:10 2016] ata6: SError: { UnrecovData 10B8B BadCRC }
>>>>> [Thu Jan 28 10:38:10 2016] ata6.00: failed command: READ FPDMA QUEUED
>>>>> [Thu Jan 28 10:38:10 2016] ata6.00: cmd
>>>>> 60/00:18:00:79:02/05:00:00:00:00/40 tag 3 ncq 655360 in
>>>>>                                        res
>>>>> 40/00:18:00:79:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
>>>>> [Thu Jan 28 10:38:10 2016] ata6.00: status: { DRDY }
>>>>> [Thu Jan 28 10:38:10 2016] ata6: hard resetting link
>>>>> [Thu Jan 28 10:38:10 2016] ata6: SATA link up 3.0 Gbps (SStatus 123
>>>>> SControl 320)
>>>>>
>>>> If by eject you mean disconnect form the system, this is exactly the
>>>> output
>>>> I would expect if you haven't done something to tell the kernel the disk
>>>> is
>>>> disappearing.
>>>
>>>
>>>
>>> How about something like:
>>>
>>> # hdparm -Y /dev/sdb
>>> # echo 1 /sys/block/sdb/device/delete
>>>
>>> Then physically disconnect the drive, assuming hot-plug is supported
>>> by all hardware?
>>>
>> That should safely disconnect the device, but you may still have to touch
>> some of the PM related stuff in the /sys/class/ directories for the disk
>> itself, and possibly do something to force it to flush the write cache
>> (toggling the write cache off then back on again usually does this).
>
> Interesting, I figured a umount should include telling the drive to
> flush the write cache; but maybe not, if the drive or connection (i.e.
> USB enclosure) doesn't support FUA?
It's supposed to send an FUA, but depending on the hardware, this may 
either disappear on the way to the disk, or more likely just be a no-op. 
  A lot of cheap older HDD's just ignore it, and I've seen a lot of USB 
enclosures that just eat the command and don't pass anything to the 
disk, so sometimes you have to get creative to actually flush the cache. 
  It's worth noting that most such disks are not safe to use BTRFS on 
anyway though, because FUA is part of what's used to force write barriers.
>
> I wonder what the kernel sends to the device on restart/poweroff?
For most SATA drives, I'm pretty certain that it doesn't do much of 
anything, although it may well tell the disk to spin down.  I'm not as 
versed on the SATA spec as I am WRT SCSI, but I am pretty certain that 
there isn't any command that is 100% guaranteed to spin down the disk.

For SCSI drives, there's a specific command to tell the device to power 
down (and a corresponding one to spin up, which is how HBA's do 
sequenced spin-up of drives) which gets issued.

For USB, it's technically the same command set as SCSI, except most USB 
enclosures don't properly translate the command to the drive.
>
>   That
>> said, the hdparm -Y is probably not nessecary depending on what else you do
>> (it technically isn't even guaranteed to spin down the disk anyway, and
>> internal design of most modern HDD's means that as long as you keep the
>> drive level while you're removing power, you don't technically have to spin
>> it down first).
>
> If I don't, my drives make a loud clank, and the smart attribute 192
> Power-off Retract Count, goes up by one. This never happens on a
> normal power off. So some message is being sent to the drive at
> restart/poweroff that's different than just pulling the drive, even if
> that message isn't the same thing as whatever hdparm -Y sends.
>
I'm not saying it's a good idea to not tell the drive to spin down, just 
that it won't damage most modern drives as long as they're kept level 
while they spin down and you don't do it all the time.

Almost every modern hard disk uses a voice-coil actuator for the heads 
which gets balanced such that having no power to the coil causes the 
forces from the spinning disks to park the heads, so pulling power will 
(more than 99.9% of the time) not cause a head cash like a lot of older 
servo based drives as long as you keep the drive level.  The clank you 
hear is the end of the head armature opposite the heads hitting the 
mechanical stop that's present to prevent them from completely 
decoupling from the disk.  This gets accounted in SMART attributes 
because over extremely long times (usually tens thousands of cycles), 
this will eventually wear out that mechanical stop, and things will stop 
working, so it technically is a failure condition, but you're almost 
certain to hit some other failure condition before this becomes an issue.

The interesting thing is that some drives actually _rely_ on this 
behavior to park the heads (I've seen a lot of Seagate desktop drives 
that appear to do this, although they use a rubber stopper instead of 
metal or plastic, so it tends to last longer).
