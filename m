Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33595 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967246AbcA1UYI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 15:24:08 -0500
Received: by mail-io0-f172.google.com with SMTP id f81so67158023iof.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 12:24:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AA70DC.1000201@gmail.com>
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
Date: Thu, 28 Jan 2016 13:24:07 -0700
Message-ID: <CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 12:49 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-01-28 14:46, Chris Murphy wrote:
>>
>> On Thu, Jan 28, 2016 at 12:37 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2016-01-28 13:47, Sean Greenslade wrote:
>>>>
>>>>
>>>> On Thu, Jan 28, 2016 at 09:18:06AM -0700, Chris Murphy wrote:
>>>>>
>>>>>
>>>>> Those read errors are a persistent counter. Use 'btrfs dev stat' to
>>>>> see them for each device, and use -z to clear. I think this is in
>>>>> DEV_ITEM, and it should be dev.uuid based, so the counter ought to be
>>>>> with this specific device, not merely "sda1". So ... I'd look in the
>>>>> journal for the time during the replace and see where those read
>>>>> errors might have come from if this is supposed to be a new drive and
>>>>> you're not expecting read errors already.
>>>>>
>>>>> Like I mentioned in my first reply to this thread, sct erc... it's
>>>>> very important to get these settings right.
>>>>
>>>>
>>>>
>>>> I don't see anything that indicates read errors in my journal or dmesg,
>>>> though it's hard to tell given the rather scary-looking messages I get
>>>> whenever I eject a drive:
>>>>
>>>> [Thu Jan 28 10:38:10 2016] ata6.00: exception Emask 0x10 SAct 0x8 SErr
>>>> 0x280100 action 0x6 frozen
>>>> [Thu Jan 28 10:38:10 2016] ata6.00: irq_stat 0x08000000, interface fatal
>>>> error
>>>> [Thu Jan 28 10:38:10 2016] ata6: SError: { UnrecovData 10B8B BadCRC }
>>>> [Thu Jan 28 10:38:10 2016] ata6.00: failed command: READ FPDMA QUEUED
>>>> [Thu Jan 28 10:38:10 2016] ata6.00: cmd
>>>> 60/00:18:00:79:02/05:00:00:00:00/40 tag 3 ncq 655360 in
>>>>                                       res
>>>> 40/00:18:00:79:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
>>>> [Thu Jan 28 10:38:10 2016] ata6.00: status: { DRDY }
>>>> [Thu Jan 28 10:38:10 2016] ata6: hard resetting link
>>>> [Thu Jan 28 10:38:10 2016] ata6: SATA link up 3.0 Gbps (SStatus 123
>>>> SControl 320)
>>>>
>>> If by eject you mean disconnect form the system, this is exactly the
>>> output
>>> I would expect if you haven't done something to tell the kernel the disk
>>> is
>>> disappearing.
>>
>>
>>
>> How about something like:
>>
>> # hdparm -Y /dev/sdb
>> # echo 1 /sys/block/sdb/device/delete
>>
>> Then physically disconnect the drive, assuming hot-plug is supported
>> by all hardware?
>>
> That should safely disconnect the device, but you may still have to touch
> some of the PM related stuff in the /sys/class/ directories for the disk
> itself, and possibly do something to force it to flush the write cache
> (toggling the write cache off then back on again usually does this).

Interesting, I figured a umount should include telling the drive to
flush the write cache; but maybe not, if the drive or connection (i.e.
USB enclosure) doesn't support FUA?

I wonder what the kernel sends to the device on restart/poweroff?



 That
> said, the hdparm -Y is probably not nessecary depending on what else you do
> (it technically isn't even guaranteed to spin down the disk anyway, and
> internal design of most modern HDD's means that as long as you keep the
> drive level while you're removing power, you don't technically have to spin
> it down first).

If I don't, my drives make a loud clank, and the smart attribute 192
Power-off Retract Count, goes up by one. This never happens on a
normal power off. So some message is being sent to the drive at
restart/poweroff that's different than just pulling the drive, even if
that message isn't the same thing as whatever hdparm -Y sends.


-- 
Chris Murphy
