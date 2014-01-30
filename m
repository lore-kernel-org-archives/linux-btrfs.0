Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48783 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA3D2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 22:28:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8iJ7-0006eg-1w
	for linux-btrfs@vger.kernel.org; Thu, 30 Jan 2014 04:28:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 04:28:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 04:28:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lost with degraded RAID1
Date: Thu, 30 Jan 2014 03:28:26 +0000 (UTC)
Message-ID: <pan$ef36e$b1a21cb6$c7661d0d$89c4aa14@cox.net>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Johan Kröckel posted on Wed, 29 Jan 2014 20:16:09 +0100 as excerpted:

[btrfs raid1 on a pair of luks-encrypted partitions, one went south and a 
balance back to single was started on the good one, interrupted by a 
reboot.]

> But now, I can't mount bunkerA degraded,RW because degraded filesystems
> are not allowed to be mounted RW (?).

AFAIK that shouldn't be the case.  Degraded should allow the RW mount -- 
I know it did some kernels ago when I tried it then, and if it changed, 
it's news to me too, in which case I need to do some reevaluation here.

What I think /might/ have happened is that there's some other damage to 
the filesystem unrelated to the missing device in the raid1, which forces 
it read-only as soon as btrfs finds that damage.  However, mount -o 
remount,rw,degraded should still work, I /think/.


> The consequence is,
> that I felt unable to do anything other than mounting it RO and back it
> up (all data is fine) to another filesystem. I don't have a new
> substitute disk, yet, so I couldn't test whether I can add a new device
> to a RO-mounted filesystem. Adding a loop device didn't work.

Well, given that btrfs isn't yet entirely stable, and both mkfs.btrfs and 
the btrfs wiki at btrfs.wiki.kernel.org warn to keep tested backups in 
case something goes wrong with the btrfs your testing and you lose that 
copy... you should have already had that backup, and wouldn't need to 
make it, only perhaps update a few files that changed since your last 
backup that you were willing to lose the changes too if it came to it, 
but since you can still mount ro, you might as well take the chance to 
update the backup given that you can.

> What are my options now? What further information could be useful? I
> cant believe, that I have all my data in front of me and have to start
> over again with a new filesystem because of security checks and no
> enforcement option to mount it RW.

As I said, to the best of my (non-dev btrfs user and list regular) 
knowledge, mount -o degraded,rw should work.  If it's not, there's likely 
something else going on triggering the ro remount, and seeing any related 
dmesg output would presumably help.

One other thing that might help is the skip_balance mount option, to 
avoid restarting the in-process balance immediately.  See if that lets 
you mount degraded,rw without immediately forcing back to ro.  You can 
then try resuming the balance.  If that fails, try canceling the balance 
and then starting a new balance using balance filters (see the balance 
questions in the FAQ on the wiki, which link to the balance-filters page).

Meanwhile, at least you have ro access to all the data and can take that 
backup that you apparently ignored the warnings about making, previously.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

