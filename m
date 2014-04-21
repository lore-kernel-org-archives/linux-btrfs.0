Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39626 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaDUX7C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 19:59:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcO72-000642-Th
	for linux-btrfs@vger.kernel.org; Tue, 22 Apr 2014 01:59:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 01:59:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 01:59:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: convert from RAID5: enospc errors during balance (500 GB free
 on each device)
Date: Mon, 21 Apr 2014 23:58:46 +0000 (UTC)
Message-ID: <pan$9d7d7$bfa295b1$7c7453$10fbdf2e@cox.net>
References: <CAG6W84JS1-rzAJfGyPmXMTPLqLN=0UbqefRa-BoqgyzFruhJ_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arjen Nienhuis posted on Mon, 21 Apr 2014 08:32:56 +0200 as excerpted:

> I experimented with RAID5, but now I want to get rid of it:
> 
> $ sudo btrfs balance start -dconvert=raid1,soft -v /
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x300): converting, target=16, soft is on
> ERROR: error during balancing '/' - No space left on device There may be
> more info in syslog - try dmesg | tail
> 
> This is in dmesg:
> 
> [ 166.799139] btrfs: relocating block group 13368320589824 flags 129
> [ 248.927524] btrfs: relocating block group 13338255818752 flags 129 ...
> [ 409.184588] btrfs: relocating block group 11607454253056 flags 129
> [ 410.528075] btrfs: relocating block group 11605306769408 flags 129
> [ 411.957809] btrfs: 62 enospc errors during balance
> 
> Extra info:

> Data, RAID1: total=3.26TiB, used=3.25TiB
> Data, RAID5: total=124.00GiB, used=123.90GiB
> System, RAID1: total=32.00MiB, used=508.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=9.00GiB, used=7.97GiB 

> Label: data  uuid: 93be47ab-af7a-4329-8a6c-c6ff220060b0
>         Total devices 3 FS bytes used 3.38TiB
> devid    1 size 1.82TiB used 1.22TiB path /dev/sdd
> devid    2 size 3.64TiB used 2.63TiB path /dev/sdb
> devid    6 size 3.64TiB used 2.87TiB path /dev/sdc
> 
> Btrfs v3.12
> 
> Linux maxi 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC 2014
> x86_64 x86_64 x86_64 GNU/Linux
> 
> I tried scrub (no errors) and I cleared the free space cache. Nothing
> worked.
> 
> Now I'm doing full balance (without 'soft') but that will take days.

Did you try running another balance soft?

Depending on how fully allocated you were originally, those 62 enospce 
errors during the first balance may have simply been before you cleared 
enough space to rewrite additional raid1 data.  You now have two devices 
with plenty of unallocated room on them (the btrfs fi show output), so 
rerunning the soft conversion to raid1 may well be all you needed to do.

Meanwhile... kernel v3.13, btrfs-progs v3.12.  You're just a bit behind, 
as kernel 3.14 is out (and 3.15 is rc2), and btrfs-progs is 3.14 
(possibly 3.14.1, I've not updated in a week or so).  When you run into 
problems, consider updating before reporting, as there are still very 
real fixes going into each new version, and they might just fix the 
problem you're reporting.

That said, I don't know if updating would help here, but it's worth a 
shot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

