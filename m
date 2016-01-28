Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:45489 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbcA1Srj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 13:47:39 -0500
Received: from fox.rh.rit.edu (fox.rh.rit.edu [129.21.125.28])
	by cartman.routify.me (Postfix) with ESMTPSA id E3C4781F59
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 13:47:37 -0500 (EST)
Date: Thu, 28 Jan 2016 13:47:36 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 disk upgrade method
Message-ID: <20160128184736.GB1167@fox.rh.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu>
 <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
 <20160127224549.GA4891@fox.rh.rit.edu>
 <20160127235528.GA5498@fox.rh.rit.edu>
 <56AA0A0A.1060807@gmail.com>
 <20160128153756.GA19617@fox.rh.rit.edu>
 <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 09:18:06AM -0700, Chris Murphy wrote:
> Those read errors are a persistent counter. Use 'btrfs dev stat' to
> see them for each device, and use -z to clear. I think this is in
> DEV_ITEM, and it should be dev.uuid based, so the counter ought to be
> with this specific device, not merely "sda1". So ... I'd look in the
> journal for the time during the replace and see where those read
> errors might have come from if this is supposed to be a new drive and
> you're not expecting read errors already.
> 
> Like I mentioned in my first reply to this thread, sct erc... it's
> very important to get these settings right.

I don't see anything that indicates read errors in my journal or dmesg,
though it's hard to tell given the rather scary-looking messages I get
whenever I eject a drive:

[Thu Jan 28 10:38:10 2016] ata6.00: exception Emask 0x10 SAct 0x8 SErr 0x280100 action 0x6 frozen
[Thu Jan 28 10:38:10 2016] ata6.00: irq_stat 0x08000000, interface fatal error
[Thu Jan 28 10:38:10 2016] ata6: SError: { UnrecovData 10B8B BadCRC }
[Thu Jan 28 10:38:10 2016] ata6.00: failed command: READ FPDMA QUEUED
[Thu Jan 28 10:38:10 2016] ata6.00: cmd 60/00:18:00:79:02/05:00:00:00:00/40 tag 3 ncq 655360 in
                                    res 40/00:18:00:79:02/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[Thu Jan 28 10:38:10 2016] ata6.00: status: { DRDY }
[Thu Jan 28 10:38:10 2016] ata6: hard resetting link
[Thu Jan 28 10:38:10 2016] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 320)

> Three things from the man page:
> 
> -       resize [<devid>:][+/-]<size>[kKmMgGtTpPeE]|[<devid>:]max <path>
> 
> -           Resize a mounted filesystem identified by path. A
> particular device can be resized by specifying a devid.
> 
> -           If max is passed, the filesystem will occupy all available
> space on the device respecting devid (remember, devid 1 by default).
> 
> 
> Try:
> 
> btrfs fi resize 2:max <mountpoint>

OK, I just misunderstood how that syntax worked. All seems good now.
I'll try to play around with some dummy configurations this weekend to
see if I can reproduce the post-replace mount bug.

Thanks, everyone!

--Sean

