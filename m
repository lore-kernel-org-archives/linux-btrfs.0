Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36091 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbcA1TjV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 14:39:21 -0500
Received: by mail-io0-f169.google.com with SMTP id g73so66978544ioe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 11:39:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160128184736.GB1167@fox.rh.rit.edu>
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
Date: Thu, 28 Jan 2016 12:39:20 -0700
Message-ID: <CAJCQCtT3in9KS1zrQ7B7mTeAK1ODFKUBKXsR7Pz-zbgoduN0XQ@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 11:47 AM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> On Thu, Jan 28, 2016 at 09:18:06AM -0700, Chris Murphy wrote:
>> Those read errors are a persistent counter. Use 'btrfs dev stat' to
>> see them for each device, and use -z to clear. I think this is in
>> DEV_ITEM, and it should be dev.uuid based, so the counter ought to be
>> with this specific device, not merely "sda1". So ... I'd look in the
>> journal for the time during the replace and see where those read
>> errors might have come from if this is supposed to be a new drive and
>> you're not expecting read errors already.
>>
>> Like I mentioned in my first reply to this thread, sct erc... it's
>> very important to get these settings right.
>
> I don't see anything that indicates read errors in my journal or dmesg,
> though it's hard to tell given the rather scary-looking messages I get
> whenever I eject a drive:
>
> [Thu Jan 28 10:38:10 2016] ata6.00: exception Emask 0x10 SAct 0x8 SErr 0x280100 action 0x6 frozen
> [Thu Jan 28 10:38:10 2016] ata6.00: irq_stat 0x08000000, interface fatal error
> [Thu Jan 28 10:38:10 2016] ata6: SError: { UnrecovData 10B8B BadCRC }
> [Thu Jan 28 10:38:10 2016] ata6.00: failed command: READ FPDMA QUEUED
> [Thu Jan 28 10:38:10 2016] ata6.00: cmd 60/00:18:00:79:02/05:00:00:00:00/40 tag 3 ncq 655360 in
>                                     res 40/00:18:00:79:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
> [Thu Jan 28 10:38:10 2016] ata6.00: status: { DRDY }
> [Thu Jan 28 10:38:10 2016] ata6: hard resetting link
> [Thu Jan 28 10:38:10 2016] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>
>> Three things from the man page:
>>
>> -       resize [<devid>:][+/-]<size>[kKmMgGtTpPeE]|[<devid>:]max <path>
>>
>> -           Resize a mounted filesystem identified by path. A
>> particular device can be resized by specifying a devid.
>>
>> -           If max is passed, the filesystem will occupy all available
>> space on the device respecting devid (remember, devid 1 by default).
>>
>>
>> Try:
>>
>> btrfs fi resize 2:max <mountpoint>
>
> OK, I just misunderstood how that syntax worked.

I've gotten tripped by this more than once myself, and have to keep
coming back to the man page; is it max:2 or 2:max or? Actually the
easier thing to do is skip important info and you get a mini cheat
sheet instead of the full man page, so you can do

[chris@f23m ~]$  btrfs fi resize
btrfs filesystem resize: too few arguments
usage: btrfs filesystem resize
[devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>

While you don't get the devid 1 is default clue with this, you get the
syntax formatting.


>All seems good now.
> I'll try to play around with some dummy configurations this weekend to
> see if I can reproduce the post-replace mount bug.

There are bugs and also missing features that seem like bugs!

I broke a raid1 a few weeks ago, I *think* because I mounted rw
degraded and for some reason a single chunk was created on, let's call
it drive A. Later, drive A and B are together again, but drive B
doesn't get a copy of that chunk even after a scrub, but I didn't know
this. Still later drive A is obliterated, and now drive B will not
mount rw, only ro. So no data loss, but the raid1 was broken, I had to
recreate the volume from scratch.

Just before that, I did a replace and also found one device had single
chunks. Since I haven't reproduced it yet, I have no bug report to
file so far. But that'd definitely be a bug. So before and after each
replaced, check btrfs fi df and btrfs fi usage to make sure there are
only raid1 chunks, no single chunks for either data or metadata or
system.

-- 
Chris Murphy
