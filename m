Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41680 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbbBHDwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Feb 2015 22:52:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKIud-0003DQ-Ch
	for linux-btrfs@vger.kernel.org; Sun, 08 Feb 2015 04:51:59 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 04:51:59 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 04:51:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1, SSD+non-SSD
Date: Sun, 8 Feb 2015 03:51:54 +0000 (UTC)
Message-ID: <pan$cd5af$3b6c02fa$1b720ab9$26472039@cox.net>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
	<pan$dd18d$5ac5cdf3$89ab930f$74b0f909@cox.net>
	<CAPn+qJhHSj6Jfx8U=-cjN-d0547+L2fGVBpq0SJaDaZ8wEFtuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brian B posted on Sat, 07 Feb 2015 21:41:08 -0500 as excerpted:

>  Sounds like it makes more
> sense to simply do backups to the slower drive and manually restore from
> those if I ever have a checksum error.
> 
> My main goal here was protection from undetectable sector corruption
> ("bitrot" etc.) without having to halve my SSD, but on btrfs I suppose
> it's impossible for bitrot errors to creep into backups, because I'd get
> a checksum error before that happened right?  Then I could just restore
> it from a previous backup.

Well, /as/ the bitrot happened, but you couldn't really do a backup of 
the bitrotted file, because you're correct, you'd get checksum errors due 
to the bitrot and btrfs wouldn't even let you access the file to back it 
up again, which in turn would mean it's time to restore at least that 
file from backup...

So yes, that plan does make sense to me. =:^)

BTW, it's worth noting the btrfs send/receive feature.  If both the ssd 
and the spinning rust backup are btrfs, send/receive should be an 
extremely efficient way to do the backups.  =:^)

Tho it may be worth keeping a more conventionally maintained second-level 
backup that's /not/ on btrfs as well, depending on how critical you 
consider that data.  While btrfs is stabilizing reasonably well now, it's 
not entirely stable yet and probably won't be for, let's say another 
year, and at least here, I really do sleep better knowing I have a non-
btrfs backup available as well.  You could manually checksum it, either 
in whole or in part, to be sure of detecting rot there, tho I've not done 
so here, figuring if I could survive decades without it before btrfs, I 
can survive another few years with it as a second backup.

Given the cost of SSD vs. spinning-rust, if all your data fits on the 
SSD, you should be able to do multiple levels of backup on spinning rust 
without breaking the bank.

(FWIW, altho as I mentioned earlier I have dual SSD btrfs raid1, I do 
still keep my media on spinning rust, NOT on SSD.  So I can't say all my 
data fits on SSD, here, or rather, it might, but that's not how I've set 
it up.  But as it happens the media files are both larger and less 
critical in terms of access speed, so spinning rust for them actually 
works out very well for me.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

