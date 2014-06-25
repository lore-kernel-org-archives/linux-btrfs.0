Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47592 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065AbaFYQBX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 12:01:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WzpdR-0000ML-1n
	for linux-btrfs@vger.kernel.org; Wed, 25 Jun 2014 18:01:21 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 18:01:21 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 18:01:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs on whole disk (no partitions)
Date: Wed, 25 Jun 2014 16:01:06 +0000 (UTC)
Message-ID: <pan$1341b$d2234f6c$81aec330$bd4f59f8@cox.net>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
	<pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
	<yq1bntjizkr.fsf@sermon.lab.mkp.net>
	<CAK5rZE4Eo+e_wbyzqPauYO=9HC9CEEF8Dftnw0D6zr1+7Z+GBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Wed, 25 Jun 2014 15:01:49 +0200 as excerpted:

> Note that gdisk gives default 8 sector alignment value for AF disks.
> That is 'sector' meant by gdisk is 'Logical Sector'!
> Sufficiently determined user may create misaligned partitions by playing
> with alignment value and partition start/end values.

AFAIK, for gdisk it's actually 2048 sector (1 MiB) alignment by default, 
on new devices or if you clear and redo the entire partition table.  On 
pre-partitioned devices, gdisk will attempt to identify current 
alignment, but will set 8-sector alignment on devices > 300 GiB even 
where previous alignment vales are less than that.  See the gdisk manpage 
under the "l" option for more.

The same applies to cgdisk (under the Align option in its manpage).

This has been the documented gdisk behavior for some versions now (I've 
been using it for awhile and remember when the default behavior changed), 
altho I'm referring to the 0.8.10 manpages for the version I have 
installed right now.

Tho here, I started my first partition, the BIOS boot partition, at 1 MiB 
and made it 3 MiB in size, so it ends at 4 MiB, with everything beyond 
that 4 MiB aligned.  The second partition is the EFI system partition, 
124 MiB in size so ending at 128 MiB, with everything beyond that 128 MiB 
aligned.  The next partition is /boot, 256 MiB, followed by a 640 MiB 
/var/log, ending at 1 GiB, with everything beyond that aligned on GiB 
boundaries.

That makes for easier reconstruction should I lose both copies of the GPT 
partition table. Plus, as Linus says, "real men" publish it on the net 
and then use the net for backup, and I've posted my partition table 
several times, so if I need to I can just look it up in my postings right 
here. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

