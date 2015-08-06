Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59223 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbbHFXHP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Aug 2015 19:07:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZNUFl-0002q9-2u
	for linux-btrfs@vger.kernel.org; Fri, 07 Aug 2015 01:07:13 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 01:07:13 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 01:07:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Removing bad hdd from btrfs volume
Date: Thu, 6 Aug 2015 23:07:07 +0000 (UTC)
Message-ID: <pan$51374$b01c6969$2f4ce293$c18e2ac9@cox.net>
References: <CAOFdcFMnYfLzw+xH71eNNgZyhqrgH4qOccak0m4OAnH31V_H=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Foley posted on Thu, 06 Aug 2015 15:17:04 -0700 as excerpted:

> I have an btrfs volume that spans multiple disks (no raid, just single),
> and earlier this morning I hit some hardware problems with one of the
> disks.
> I tried btrfs dev del /dev/sda1 /, but btrfs was unable to migrate the
> 1gb that appears to be causing the read errors.
> See http://sprunge.us/aeZC Is there some way to figure out which file(s)
> are affected, and if they are stuff I don't care about, is there some
> way to force btrfs to "lose" the 1gb it can't copy off of the failing
> hdd?

Of course that's the classic raid0 trap (with btrfs multi-device single 
being effectively a raid0 with really big stripes).  Raid0 is (ideally) 
never supposed to be used for data that isn't throw-away, either because 
it's literally no-care data, or because there's backups kept 
appropriately updated, as it's generally considered as good as dead the 
moment one device fails or even really starts to go bad.

So ideally, with one device starting to go bad, you scrap the entire 
filesystem, remove the bad device (or trigger sector remap and reuse, but 
that's dangerous as once sectors start to go, generally the badness 
spreads so the entire device can't be considered trustworthy again), and 
mkfs a new filesystem on the remaining devices, with a replacement device 
thrown in as well if desired.

But sometimes the world isn't ideal; on the arguably more practical 
side... Most of my btrfs are raid1, both data/metadata, with the 
remainder being mixed-bg dup, so I've never tried this on single, 
personally, but...

First, you didn't mention versions so be sure you're current, btrfs-progs 
v4.1.2 is current on the user side, kernel 4.1.x (which you appear to 
have, based on the dmesg, BTW, gentoo here too =:^), or 4.2-rc5+ since 
4.2 is close to release now, is current on the kernel side.

Try btrfs scrub.  Assuming a current btrfs-progs, that should correct 
errors in the metadata, which should be raid1 and thus have a second 
hopefully valid copy to read from.  It should detect but not be able to 
correct errors in the single mode data, but should tell you what files 
the errors are in (I believe very old btrfs-progs scrub did not).

Armed with a list of the files with errors, you should be able to delete 
them.  Once all such files are deleted, the 1 GiB chunk that they were in 
should be empty, and a btrfs balance -dusage=0 should eliminate it.

At that point a btrfs dev del should work.

That's the theory, anyway.  As I said, I've not tried it myself.  But 
it's what I'd try if I did have single-mode data on anything and found 
myself in that situation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

