Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34687 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbcHUCTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 22:19:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bbIMN-00071b-Lm
        for linux-btrfs@vger.kernel.org; Sun, 21 Aug 2016 04:19:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
Date: Sun, 21 Aug 2016 02:19:33 +0000 (UTC)
Message-ID: <pan$37954$2a2891c6$a583cdc5$350ef358@cox.net>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
        <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
        <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl>
        <CAJCQCtS1LPmYN2JY0cayWpCPVzaPq+KQSZZU4g9ifVGT9HCZCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 20 Aug 2016 18:36:21 -0600 as excerpted:

> FAT leaves a lot to be desired but it's pretty universally supported and
> almost trivial to repair *if* the volume is repairable in the first
> place. The much bigger issue with ESP on Linux is this neurotic tendency
> of distros to persistently mount shit that does not need to be mounted.
> Like the ESP, and even the dedicated boot volume. They only need to be
> mounted when being updated and then should be umounted. And worse the
> convention is to do nested mount with /boot and then /boot/efi for the
> ESP so it's twice as bad a practice. By virtue of mounting the ESP the
> dirty bit is set, so any crash means it must be fsck'd and if that
> doesn't work, it's game over for that volume. Fragile setup.

Depends on the distro.  On gentoo, you set it up the way you want of 
course, but the recommendation has always been /boot, and now the ESP, 
not mounted by default.

But that would be /expected/ on gentoo, since being able to configure it 
the way you want is the whole /point/ of running gentoo in the first 
place.  Sort of like arch, only much more so.

Meanwhile, I'm kinda partial to booting in legacy mode in grub2, with 
grub2 installed to the legacy-BIOS partion on multiple gpt-partitioned 
devices, which each one having its own /boot as well, setup so the 
firmware boot device selector can choose which device and thus which 
grub2 installation on that device, I boot from.  That gives me as many 
backup grub2 installations on the legacy BIOS partitions, pointing at as 
many backup /boots on the same device by default, as I care to setup.  Of 
course what's extra nice about that is that you can switch to the /boot 
on another device direct from the grub2 prompt, emergency mode if it 
can't load the /boot off that device, if you like.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

