Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38488 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAQXSb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 18:18:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W4IgG-0000Zb-8v
	for linux-btrfs@vger.kernel.org; Sat, 18 Jan 2014 00:18:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 00:18:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 00:18:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: drawbacks of non-ECC RAM
Date: Fri, 17 Jan 2014 23:18:02 +0000 (UTC)
Message-ID: <pan$8d0bb$f4bae0c6$a4261ffd$c2bc88eb@cox.net>
References: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

valleysmail-lol5@yahoo.de posted on Fri, 17 Jan 2014 18:33:35 +0000 as
excerpted:

> I'd like to know if there are drawbacks in using btrfs with non-ECC RAM
> instead of using ext4 with non-ECC RAM. I know that some features of
> btrfs may rely on ECC RAM 

Crossed signals somewhere, as that's entirely incorrect.  Btrfs does have 
date integrity checksumming as one of its features -- one which I'm using 
here BTW with raid1 mode so there's two copies of everything, on 
different devices, in case one goes bad -- but BTRFS IN NO WAY REQUIRES 
ECC RAM.  ECC RAM is a hardware solution to a conceptually similar data 
integrity problem in memory to the problem btrfs addresses as filesystem 
software for non-volatile storage, but the two shouldn't be confused for 
each other or conflated at all -- they're entirely separate in practice, 
and one is hardware while the other is software.

> [...] but is the chance of data corruption or even a
> damaged filesystem higher than when i use ext4 instead of btrfs?

The chances of data corruption or a damaged filesystem are certainly not 
higher on btrfs for that reason, because as I said, ECC memory is 
entirely unrelated to btrfs data checksumming and integrity measures.

However, btrfs /is/ a rather less mature filesystem than ext4 ATM, and is 
in fact just now beginning to stabilize.  As such, there are still bugs 
being actively fixed, and as the warning in mkfs.btrfs says when you 
create a filesystem, it's still critical to keep non-btrfs backups of 
anything you value, AND actually test that you can recover from them, 
because at this point, you just might hit one of those still existing 
corner-case bugs and may very well need to do just that, recover from 
backup!

If that's concerning to you, then it's likely that btrfs isn't a good 
choice as your filesystem at this point.  Perhaps in a year or so, as 
2014 really does look to be the year that btrfs finally begins to really 
stabilize, but not right now.

> I want to know this because i would like to use the snapshot feature of
> btrfs and ext4 does not support that. I will not use btrfs for fixing
> silent data corruption nor for using RAID like features or encryption.
> ZFS however checks files in the background (even if i don't want) and if
> it thinks there is an error it will fix it and i cannot disable this
> feature.

> So errors in RAM may corrupt my files or even more.

While it's possible to disable the checksumming in btrfs, and in fact 
that and COW (copy-on-write) are recommended to be disabled for specific 
use-cases (large "internal-write" files such as VM images, large 
databases, and large pre-allocated files then filled in as the file gets 
written, such as many bittorrent clients create) it's definitely *NOT* 
recommended in general.

And in fact, disabling COW would disable efficient snapshots usage as 
well, so it's probably not what you want.

If you're after snapshotting ability without checksumming, I'd suggest 
looking into something like LVM, which has snapshotting as one of its 
major features, but without checksumming/data-integrity.  LVM is a 
relatively mature technology that a number of distros use by default, and 
you can use the ext4 that you're already familiar with and that is 
reasonably mature as well, on top of LVM.

However, I really think you need to do a bit more research, because it 
appears you are rather confused about filesystem checksumming and data 
integrity at the filesystem level, and are in fact conflating it with the 
entirely separate hardware ECC data integrity at memory level.  The two 
are entirely distinct, and data-integrity at the filesystem level 
certainly isn't the bugbear you make it out to be, but rather, a vital 
part of how some filesystems work, particularly as storage sizes reach 
farther and farther into the multi-terabyte range.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

