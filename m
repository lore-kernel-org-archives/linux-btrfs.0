Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53080 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaJNWAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 18:00:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XeA8j-0002Xw-QY
	for linux-btrfs@vger.kernel.org; Wed, 15 Oct 2014 00:00:21 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:00:21 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:00:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: what is the best way to monitor raid1 drive failures?
Date: Tue, 14 Oct 2014 22:00:09 +0000 (UTC)
Message-ID: <pan$83686$251b2d40$6e8ece38$bc60b89e@cox.net>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com>
	<543B372F.10509@oracle.com>
	<CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com>
	<543C86C3.7040804@oracle.com>
	<CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Suman C posted on Tue, 14 Oct 2014 07:48:01 -0700 as excerpted:

> Here's a simple raid1 recovery experiment that's not working as
> expected.
> 
> kernel: 3.17, latest mainline progs: 3.16.1
> 
> I started with a simple raid1 mirror of 2 drives (sda and sdb). The
> filesystem is functional, I created one subvol, put some data,
> read/write tested etc..
> 
> yanked the sdb out. (this is physical/hardware). btrfs fi show prints
> drive missing, as expected.
> 
> powered the machine down. removed the "bad"(yanked out sdb) drive and
> replaced it with a new drive. Powered up the machine.
> 
> The new drive shows up as sdb. btrfs fi show still prints drive missing.
> 
> mounted the filesystem with ro,degraded
> 
> tried adding the "new" sdb drive which results in the following error.
> (-f because the new drive has a fs from past)
> 
> # btrfs device add -f /dev/sdb /mnt2/raid1pool /dev/sdb is mounted

While I'm not sure it'll get you past the error, did you try...

# btrfs replace ...

That's the new way to /replace/ a missing device, adding a new one and 
deleting the old one (which can be missing) at the same time.  See the 
btrfs-replace manpage.

While the btrfs-replace manpage says that you have to use the <devid> 
format if the device is missing, it isn't particularly helpful in telling 
what that format actually is.  Do a btrfs fi show and use the appropriate 
devid /number/ from there. =:^)

Please report back as I'm using btrfs raid1 as well, but my own tests are 
rather stale by this point and I'd have to figure it out as I went.  So 
I'm highly interested in your results. =:^)

(FWIW, personally I'd have made that btrfs device replace, instead of 
btrfs replace, to keep it grouped with the other device operations, but 
whatever, it's its own top-level command, now.  Tho at least the
btrfs-device manpage mentions btrfs replace and its manpage as well.  But 
I still think having replace as its own top-level command is confusing.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

